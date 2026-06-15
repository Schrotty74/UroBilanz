const assert = require("node:assert/strict");
const fs = require("node:fs");
const path = require("node:path");
const {
  isoWeek,
  parseCsv,
  parseDate,
  parseDayDate,
  toMesstag,
} = require("../assets/js/core.js");

const monthNames = ["Januar", "Februar", "März", "April", "Mai", "Juni", "Juli", "August", "September", "Oktober", "November", "Dezember"];
const dayNames = ["Sonntag", "Montag", "Dienstag", "Mittwoch", "Donnerstag", "Freitag", "Samstag"];

function fmtTime(date) {
  return `${String(date.getHours()).padStart(2, "0")}:${String(date.getMinutes()).padStart(2, "0")}`;
}

function parseAmount(value) {
  const cleaned = String(value || "").replace("ml", "").replaceAll(".", "").trim();
  return Number(cleaned) || 0;
}

function splitList(value) {
  return String(value || "").split("|").map((item) => item.trim()).filter(Boolean);
}

function splitListKeepingEmpty(value) {
  return String(value || "").split("|").map((item) => item.trim());
}

function zipTimesAmounts(times, amounts) {
  const count = Math.max(times.length, amounts.length);
  return Array.from({ length: count }, (_, index) => ({ time: times[index] || "", ml: amounts[index] || 0 }));
}

function entryFromRawRow(entry) {
  const date = parseDate(entry.Datum || "");
  if (!date) return null;
  return {
    original: date,
    type: entry.Typ === "Wasser" ? "Wasser" : entry.Typ === "Hinweis" ? "Hinweis" : "Urin",
    ml: Math.round(Number(entry.ml || 0)),
    note: (entry.Hinweis || "").trim(),
  };
}

function dateFromMesstagTime(messtag, time) {
  const [h = 0, m = 0] = String(time || "00:00").split(":").map(Number);
  const date = new Date(messtag.getFullYear(), messtag.getMonth(), messtag.getDate(), h, m);
  if (h < 6) date.setDate(date.getDate() + 1);
  return date;
}

function localDayKey(date) {
  return `${date.getFullYear()}-${String(date.getMonth() + 1).padStart(2, "0")}-${String(date.getDate()).padStart(2, "0")}`;
}

function entriesFromDay(day) {
  const note = day.notesText || "";
  const make = (item, type, entryNote = "") => ({ original: dateFromMesstagTime(day.messtag, item.time), type, ml: item.ml, note: entryNote });
  const entries = [
    ...day.urine.map((item) => make(item, "Urin", (day.noteRows || []).filter((noteRow) => noteRow.time === item.time).map((noteRow) => noteRow.note).join(" / "))),
    ...day.water.map((item) => make(item, "Wasser")),
    ...(day.generalNotes || []).map((generalNote) => ({
      original: new Date(day.messtag.getFullYear(), day.messtag.getMonth(), day.messtag.getDate(), 12, 0),
      type: "Hinweis",
      ml: 0,
      note: generalNote,
    })),
  ];
  if (!entries.length && note) {
    entries.push({ original: new Date(day.messtag.getFullYear(), day.messtag.getMonth(), day.messtag.getDate(), 12, 0), type: "Hinweis", ml: 0, note });
  }
  return entries.sort((a, b) => a.original - b.original);
}

function processDailyRows(raw) {
  const days = raw.map((entry) => {
    const messtag = parseDayDate(entry.Messtag || "");
    assert.ok(messtag);
    const iso = isoWeek(messtag);
    const urine = zipTimesAmounts(splitList(entry["Urin Uhrzeit"] || ""), splitList(entry["Urin ml"] || "").map(parseAmount));
    const water = zipTimesAmounts(splitList(entry["Wasser Uhrzeit"] || ""), splitList(entry["Wasser ml"] || "").map(parseAmount));
    const notesText = (entry.Hinweise || "").trim();
    const generalNotes = splitList(entry["Allgemeine Hinweise"] || "");
    const urineNoteSlots = splitListKeepingEmpty(entry["Urin Hinweis"] || "");
    const noteRows = urine
      .map((item, index) => ({ time: item.time, note: urineNoteSlots[index] || "" }))
      .filter((item) => item.note);
    return {
      messtag,
      key: localDayKey(messtag),
      year: messtag.getFullYear(),
      month: messtag.getMonth() + 1,
      monthName: monthNames[messtag.getMonth()],
      dayName: dayNames[messtag.getDay()],
      week: Number(entry.KW || iso.week),
      urine,
      water,
      notes: notesText ? [notesText] : [],
      noteRows,
      generalNotes,
      urineTotal: String(entry["Urin gesamt ml"] || "").trim() ? parseAmount(entry["Urin gesamt ml"]) : urine.reduce((sum, item) => sum + item.ml, 0),
      waterTotal: String(entry["Wasser gesamt ml"] || "").trim() ? parseAmount(entry["Wasser gesamt ml"]) : water.reduce((sum, item) => sum + item.ml, 0),
      urineCount: Number(entry["Urin Anzahl"] || urine.length),
      notesText,
    };
  });
  return days.flatMap(entriesFromDay);
}

function groupEntries(rows) {
  const byDay = new Map();
  for (const row of rows) {
    const messtag = toMesstag(row.original);
    const key = localDayKey(messtag);
    if (!byDay.has(key)) byDay.set(key, { key, messtag, urine: [], water: [], notes: [] });
    const day = byDay.get(key);
    if (row.type === "Urin") day.urine.push({ time: fmtTime(row.original), ml: row.ml });
    if (row.type === "Wasser") day.water.push({ time: fmtTime(row.original), ml: row.ml });
    if (row.note) day.notes.push(row.note);
  }
  return Array.from(byDay.values()).map((day) => ({
    ...day,
    urineTotal: day.urine.reduce((sum, item) => sum + item.ml, 0),
    waterTotal: day.water.reduce((sum, item) => sum + item.ml, 0),
    urineCount: day.urine.length,
    notesText: [...new Set(day.notes)].join(" | "),
  }));
}

function noteRowsForDay(day, rows) {
  const entryDayKey = (entry) => localDayKey(toMesstag(entry.original));
  return rows
    .filter((entry) => entryDayKey(entry) === day.key && entry.type === "Urin" && entry.note)
    .map((entry) => ({ time: fmtTime(entry.original), note: entry.note }));
}

function alignedNoteRows(rows, urineTimes) {
  if (!rows.length) return [];
  const unmatched = rows.slice();
  const result = urineTimes.map((time) => {
    const notes = unmatched.filter((item) => item.time === time).map((item) => item.note).join(" | ");
    for (let index = unmatched.length - 1; index >= 0; index -= 1) {
      if (unmatched[index].time === time) unmatched.splice(index, 1);
    }
    return notes;
  });
  result.push(...unmatched.map((item) => item.note));
  return result;
}

function entryKey(entry) {
  return [entry.original.getTime(), entry.type, entry.ml, entry.note.trim()].join("|");
}

function isCompleteMeasurementDay(day) {
  const minutes = [...day.urine, ...day.water].map((item) => {
    const [hour, minute] = item.time.split(":").map(Number);
    return (hour < 6 ? hour + 24 : hour) * 60 + minute;
  });
  if (!minutes.length) return false;
  return Math.max(...minutes) - Math.min(...minutes) >= 8 * 60;
}

function summarize(days) {
  const evaluated = days.filter(isCompleteMeasurementDay);
  const incompleteDays = days.length - evaluated.length;
  const urineTotal = evaluated.reduce((sum, day) => sum + day.urineTotal, 0);
  const lowDays = evaluated.filter((day) => day.urineTotal < 700).length;
  return {
    days: evaluated.length,
    incompleteDays,
    urineTotal,
    alert: incompleteDays
      ? evaluated.length
        ? `${lowDays ? "niedrig" : "normal"} · ${incompleteDays} unvollständig`
        : "unvollständig"
      : lowDays
        ? "niedrig"
        : "normal",
  };
}

function toCsv(rows) {
  const headers = Object.keys(rows[0]);
  const escape = (value) => {
    const text = String(value ?? "");
    return /[",\n;]/.test(text) ? `"${text.replaceAll('"', '""')}"` : text;
  };
  return [headers.join(","), ...rows.map((row) => headers.map((header) => escape(row[header])).join(","))].join("\n");
}

function entriesToRawCsv(entries) {
  return toCsv(entries.sort((a, b) => a.original - b.original).map((entry) => ({
    Datum: `${entry.original.getDate()}.${entry.original.getMonth() + 1}.${entry.original.getFullYear()} ${fmtTime(entry.original)}`,
    Typ: entry.type,
    ml: entry.ml,
    Hinweis: entry.note,
  })));
}

const rawCsv = [
  "Datum,Typ,ml,Hinweis",
  "1.6.2026 06:10,Urin,250,",
  "1.6.2026 06:20,Wasser,300,",
  "2.6.2026 05:30,Urin,120,Nachtwert",
].join("\n");
let entries = parseCsv(rawCsv).map(entryFromRawRow).filter(Boolean);
let days = groupEntries(entries);
assert.equal(days.length, 1, "00:00 bis 05:59 gehoert zum Vortag");
assert.equal(days[0].urineTotal, 370);
assert.equal(days[0].waterTotal, 300);

const duplicateMerge = parseCsv(rawCsv).map(entryFromRawRow).filter(Boolean);
const existing = new Set(entries.map(entryKey));
entries = [...entries, ...duplicateMerge.filter((entry) => !existing.has(entryKey(entry)))];
assert.equal(entries.length, 3, "CSV-Ergaenzung darf Duplikate nicht verdoppeln");

entries.push({ original: new Date(2026, 5, 1, 8, 0), type: "Urin", ml: 400, note: "" });
entries[0] = { ...entries[0], ml: 260 };
entries = entries.filter((entry) => !(entry.type === "Wasser" && entry.ml === 300));
days = groupEntries(entries);
assert.equal(days[0].urineTotal, 780, "Manuelle Eingabe und Bearbeitung werden neu summiert");
assert.equal(days[0].waterTotal, 0, "Einzelloeschen entfernt den Wasserwert");

const exported = entriesToRawCsv(entries);
assert.match(exported, /^Datum,Typ,ml,Hinweis/);
assert.match(exported, /1\.6\.2026 08:00,Urin,400,/);

const dailyCsv = [
  "Jahr,Monat,KW,Messtag,Tag,Urin Uhrzeit,Urin ml,Urin Hinweis,Urin Anzahl,Urin gesamt ml,Wasser Uhrzeit,Wasser ml,Wasser gesamt ml,Hinweise,Allgemeine Hinweise",
  "2026,Juni,23,01.06.2026,Montag,06:10 | 08:00,260 | 400, | Demo,2,660,06:20,300,300,Demo,",
].join("\n");
const dailyEntries = processDailyRows(parseCsv(dailyCsv));
assert.equal(dailyEntries.length, 3);
assert.equal(groupEntries(dailyEntries)[0].notesText, "Demo");
assert.equal(dailyEntries.find((entry) => fmtTime(entry.original) === "08:00")?.note, "Demo");

const noteAlignmentCsv = [
  "Datum,Typ,ml,Hinweis",
  "21.5.2026 09:16,Urin,100,wenig Stuhl",
  "21.5.2026 11:26,Urin,250,wenig Stuhl",
  "21.5.2026 14:26,Urin,200,",
  "21.5.2026 16:29,Urin,80,Katastrophe heute",
  "21.5.2026 18:20,Urin,150,",
  "22.5.2026 05:27,Urin,120,",
  "23.5.2026 07:43,Urin,50,Stuhlgang",
  "23.5.2026 11:33,Urin,130,massiv weniger seit Tadalafil.",
  "23.5.2026 14:36,Urin,390,besser jetzt aber noch immer unterbrochen",
  "23.5.2026 16:32,Urin,260,",
  "23.5.2026 18:24,Urin,170,",
  "23.5.2026 22:11,Urin,120,",
  "24.5.2026 05:24,Urin,100,sehr wenig für einen Morgenurin",
].join("\n");
const noteAlignmentEntries = parseCsv(noteAlignmentCsv).map(entryFromRawRow).filter(Boolean);
const alignmentDays = groupEntries(noteAlignmentEntries);
const noteAlignmentDay21 = alignmentDays.find((day) => day.key === "2026-05-21");
assert.ok(noteAlignmentDay21);
const alignedNotes21 = alignedNoteRows(noteRowsForDay(noteAlignmentDay21, noteAlignmentEntries), noteAlignmentDay21.urine.map((item) => item.time));
assert.equal(alignedNotes21[0], "wenig Stuhl");
assert.equal(alignedNotes21[1], "wenig Stuhl");
assert.equal(alignedNotes21[3], "Katastrophe heute");
assert.equal(alignedNotes21[5], "");
const noteAlignmentDay = alignmentDays.find((day) => day.key === "2026-05-23");
assert.ok(noteAlignmentDay);
assert.deepEqual(noteAlignmentDay.urine.map((item) => item.time), ["07:43", "11:33", "14:36", "16:32", "18:24", "22:11", "05:24"]);
const alignedNotes = alignedNoteRows(noteRowsForDay(noteAlignmentDay, noteAlignmentEntries), noteAlignmentDay.urine.map((item) => item.time));
assert.equal(alignedNotes[0], "Stuhlgang");
assert.equal(alignedNotes[1], "massiv weniger seit Tadalafil.");
assert.equal(alignedNotes[2], "besser jetzt aber noch immer unterbrochen");
assert.equal(alignedNotes[3], "");
assert.equal(alignedNotes[6], "sehr wenig für einen Morgenurin");

const edgeEntries = [
  { original: new Date(2031, 0, 1, 8, 0), type: "Urin", ml: 420, note: "" },
  { original: new Date(2031, 0, 1, 8, 20), type: "Wasser", ml: 320, note: "" },
  { original: new Date(2031, 0, 2, 6, 0), type: "Urin", ml: 600, note: "" },
  { original: new Date(2031, 0, 2, 18, 0), type: "Wasser", ml: 1600, note: "" },
];
const edgeSummary = summarize(groupEntries(edgeEntries));
assert.equal(edgeSummary.days, 1, "Unvollstaendige Tage duerfen nicht als bewertete Tage zaehlen");
assert.equal(edgeSummary.incompleteDays, 1);
assert.equal(edgeSummary.urineTotal, 600, "Unvollstaendige Tagesmenge darf Summen nicht verfaelschen");
assert.equal(edgeSummary.alert, "niedrig · 1 unvollständig");

const webAppSource = fs.readFileSync(path.join(__dirname, "..", "app.js"), "utf8");
const webCoreSource = fs.readFileSync(path.join(__dirname, "..", "assets", "js", "core.js"), "utf8");
const webIndexSource = fs.readFileSync(path.join(__dirname, "..", "index.html"), "utf8");
assert.match(webAppSource, /urobilanz@mailbox\.org/, "Support-E-Mail fehlt");
assert.match(webAppSource, /github\.com\/Schrotty74\/UroBilanz/, "GitHub-Link fehlt");
assert.match(webAppSource, /Keine CSV-Werte, Hinweise oder Gesundheitsdaten/, "Datenschutz-Hinweis im Fehlerbericht fehlt");
assert.doesNotMatch(webAppSource.match(/function buildBugReport\(\)[\s\S]*?function refreshBugReport/)?.[0] || "", /state\.rows|state\.days|rawCsv/, "Fehlerbericht darf keine Messdaten lesen");
assert.match(webCoreSource, /const APP_VERSION = "1\.7\.1"/, "Zentrale Web-App-Version fehlt");
assert.match(webAppSource, /const appVersion = APP_VERSION/, "Web-App verwendet nicht die zentrale Version");
assert.match(webIndexSource, /id="openAbout"/, "Klickbarer Logo-Ausloeser fuer das Ueber-Modal fehlt");
assert.match(webIndexSource, /id="aboutDialog"/, "Ueber-Modal fehlt");
assert.match(webIndexSource, /Schrotty74/, "Entwicklerangabe im Ueber-Modal fehlt");
assert.match(webAppSource, /els\.closeAbout\.addEventListener\("click"/, "Schliessen-Button des Ueber-Modals fehlt");
assert.match(webAppSource, /event\.target === els\.aboutDialog/, "Schliessen per Klick ausserhalb des Ueber-Modals fehlt");
assert.match(webIndexSource, /id="medicalReport"/, "Arztbericht-Ausloeser fehlt");
assert.match(webIndexSource, /id="medicalReportDialog"/, "Arztbericht-Zeitraumdialog fehlt");
assert.match(webAppSource, /buildMedicalReportHTML/, "Arztbericht-Modul wird nicht verwendet");
assert.match(webAppSource, /medicalReportDays/, "Arztbericht-Zeitraumfilter fehlt");
assert.match(webIndexSource, /id="backupMenu"/, "Gemeinsames Backup-Menue fehlt");
assert.match(webIndexSource, /data-i18n="complete_backup"/, "Komplett-Backup fehlt");
assert.match(webIndexSource, /data-i18n="daily_backup"/, "Tagesbackup fehlt");

console.log("Web workflow smoke test passed");
