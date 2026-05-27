const monthNames = [
  "Januar",
  "Februar",
  "März",
  "April",
  "Mai",
  "Juni",
  "Juli",
  "August",
  "September",
  "Oktober",
  "November",
  "Dezember",
];
const dayNames = ["Sonntag", "Montag", "Dienstag", "Mittwoch", "Donnerstag", "Freitag", "Samstag"];

let state = {
  rows: [],
  days: [],
  year: "all",
  month: "all",
  rawCsv: "",
};

const els = {
  status: document.querySelector("#status"),
  csvInput: document.querySelector("#csvInput"),
  emptyCsvInput: document.querySelector("#emptyCsvInput"),
  mergeCsvInput: document.querySelector("#mergeCsvInput"),
  themeSelect: document.querySelector("#themeSelect"),
  appMark: document.querySelector("#appMark"),
  addEntry: document.querySelector("#addEntry"),
  entryDialog: document.querySelector("#entryDialog"),
  entryForm: document.querySelector("#entryForm"),
  cancelEntry: document.querySelector("#cancelEntry"),
  entryDate: document.querySelector("#entryDate"),
  entryTime: document.querySelector("#entryTime"),
  entryType: document.querySelector("#entryType"),
  entryMl: document.querySelector("#entryMl"),
  entryNote: document.querySelector("#entryNote"),
  yearFilter: document.querySelector("#yearFilter"),
  monthFilter: document.querySelector("#monthFilter"),
  rememberData: document.querySelector("#rememberData"),
  forgetData: document.querySelector("#forgetData"),
  backupCsv: document.querySelector("#backupCsv"),
  exportDays: document.querySelector("#exportDays"),
  emptyState: document.querySelector("#emptyState"),
  metrics: document.querySelector("#metrics"),
  alertTable: document.querySelector("#alertTable"),
  yearTable: document.querySelector("#yearTable"),
  monthTable: document.querySelector("#monthTable"),
  weekTable: document.querySelector("#weekTable"),
  dayTable: document.querySelector("#dayTable"),
  dailyChart: document.querySelector("#dailyChart"),
  monthChart: document.querySelector("#monthChart"),
};

function parseCsv(text) {
  const delimiter = detectDelimiter(text);
  const rows = [];
  let current = "";
  let row = [];
  let quoted = false;

  for (let i = 0; i < text.length; i += 1) {
    const char = text[i];
    const next = text[i + 1];
    if (char === '"' && quoted && next === '"') {
      current += '"';
      i += 1;
    } else if (char === '"') {
      quoted = !quoted;
    } else if (char === delimiter && !quoted) {
      row.push(current);
      current = "";
    } else if ((char === "\n" || char === "\r") && !quoted) {
      if (char === "\r" && next === "\n") i += 1;
      row.push(current);
      if (row.some((value) => value.length)) rows.push(row);
      row = [];
      current = "";
    } else {
      current += char;
    }
  }
  if (current.length || row.length) {
    row.push(current);
    rows.push(row);
  }

  const headers = rows.shift()?.map(normalizeHeader) || [];
  return rows.map((values) =>
    Object.fromEntries(headers.map((header, index) => [header, String(values[index] ?? "").trim()]))
  );
}

function parseDate(value) {
  const match = String(value || "").trim().match(/^(\d{1,2})\.(\d{1,2})\.(\d{4})\s+(\d{1,2}):(\d{2})$/);
  if (!match) return null;
  const [, d, m, y, h, min] = match.map(Number);
  return new Date(y, m - 1, d, h, min);
}

function detectDelimiter(text) {
  const firstLine = String(text || "").split(/\r?\n/)[0] || "";
  const commaCount = (firstLine.match(/,/g) || []).length;
  const semicolonCount = (firstLine.match(/;/g) || []).length;
  return semicolonCount > commaCount ? ";" : ",";
}

function normalizeHeader(header) {
  return String(header || "")
    .replace(/^\uFEFF/, "")
    .trim();
}

function parseDayDate(value) {
  const match = String(value || "").match(/^(\d{1,2})\.(\d{1,2})\.(\d{4})$/);
  if (!match) return null;
  const [, d, m, y] = match.map(Number);
  return new Date(y, m - 1, d);
}

function toMesstag(date) {
  const result = new Date(date.getFullYear(), date.getMonth(), date.getDate());
  if (date.getHours() < 6) result.setDate(result.getDate() - 1);
  return result;
}

function isoWeek(date) {
  const d = new Date(Date.UTC(date.getFullYear(), date.getMonth(), date.getDate()));
  const day = d.getUTCDay() || 7;
  d.setUTCDate(d.getUTCDate() + 4 - day);
  const yearStart = new Date(Date.UTC(d.getUTCFullYear(), 0, 1));
  const week = Math.ceil(((d - yearStart) / 86400000 + 1) / 7);
  return { year: d.getUTCFullYear(), week };
}

function fmtDate(date) {
  return date.toLocaleDateString("de-AT", { day: "2-digit", month: "2-digit", year: "numeric" });
}

function fmtNumber(value) {
  return Number(value).toLocaleString("de-DE");
}

function fmtTime(date) {
  return date.toLocaleTimeString("de-AT", { hour: "2-digit", minute: "2-digit" });
}

function processRows(raw, rawCsv = "") {
  state.rawCsv = rawCsv;
  if (raw[0] && Object.prototype.hasOwnProperty.call(raw[0], "Messtag")) {
    processDailyRows(raw);
    return;
  }

  const rows = raw
    .map(entryFromRawRow)
    .filter(Boolean)
    .sort((a, b) => a.original - b.original);

  rebuildFromEntries(rows, rawCsv);
}

function rebuildFromEntries(rows, rawCsv = "") {
  const byDay = new Map();
  for (const row of rows) {
    const messtag = toMesstag(row.original);
    const iso = isoWeek(messtag);
    row.messtag = messtag;
    row.messtagKey = messtag.toISOString().slice(0, 10);
    row.isoYear = iso.year;
    row.week = iso.week;
    if (!byDay.has(row.messtagKey)) {
      byDay.set(row.messtagKey, {
        messtag: row.messtag,
        key: row.messtagKey,
        year: row.messtag.getFullYear(),
        month: row.messtag.getMonth() + 1,
        monthName: monthNames[row.messtag.getMonth()],
        dayName: dayNames[row.messtag.getDay()],
        week: row.week,
        urine: [],
        water: [],
        notes: [],
      });
    }
    const day = byDay.get(row.messtagKey);
    const target = row.type === "Wasser" ? day.water : day.urine;
    target.push({ time: fmtTime(row.original), ml: row.ml });
    if (row.note) day.notes.push(row.note);
  }

  const days = Array.from(byDay.values()).map((day) => ({
    ...day,
    urineTotal: day.urine.reduce((sum, item) => sum + item.ml, 0),
    waterTotal: day.water.reduce((sum, item) => sum + item.ml, 0),
    urineCount: day.urine.length,
    notesText: [...new Set(day.notes)].join(" | "),
  }));

  state.rows = rows;
  state.days = days;
  state.rawCsv = rawCsv || entriesToRawCsv(rows);
  if (!state.days.length) {
    throw new Error("Keine gültigen Einträge gefunden. Erwartet werden Spalten wie Datum, Typ, ml, Hinweis.");
  }
  buildFilters();
  render();
}

function processDailyRows(raw) {
  const days = raw
    .map((entry) => {
      const messtag = parseDayDate(entry.Messtag || "");
      if (!messtag) return null;
      const iso = isoWeek(messtag);
      const urineTimes = splitList(entry["Urin Uhrzeit"] || entry["● Urin Uhrzeit"] || "");
      const urineAmounts = splitList(entry["Urin ml"] || entry["● Urin ml"] || "").map(parseAmount);
      const waterTimes = splitList(entry["Wasser Uhrzeit"] || entry["💧 Wasser Uhrzeit"] || "");
      const waterAmounts = splitList(entry["Wasser ml"] || entry["💧 Wasser ml"] || "").map(parseAmount);
      const urine = zipTimesAmounts(urineTimes, urineAmounts);
      const water = zipTimesAmounts(waterTimes, waterAmounts);
      const rawUrineTotal = entry["Urin gesamt ml"] || entry["● Urin gesamt ml"] || "";
      const rawWaterTotal = entry["Wasser gesamt ml"] || entry["💧 Wasser gesamt ml"] || "";
      const notesText = (entry.Hinweise || "").trim();
      return {
        messtag,
        key: messtag.toISOString().slice(0, 10),
        year: messtag.getFullYear(),
        month: messtag.getMonth() + 1,
        monthName: entry.Monat || monthNames[messtag.getMonth()],
        dayName: entry.Tag || dayNames[messtag.getDay()],
        week: Number(entry.KW || iso.week),
        urine,
        water,
        notes: notesText ? [notesText] : [],
        urineTotal: String(rawUrineTotal).trim() ? parseAmount(rawUrineTotal) : urine.reduce((sum, item) => sum + item.ml, 0),
        waterTotal: String(rawWaterTotal).trim() ? parseAmount(rawWaterTotal) : water.reduce((sum, item) => sum + item.ml, 0),
        urineCount: Number(entry["Urin Anzahl"] || entry["● Urin Anzahl"] || urine.length),
        notesText,
      };
    })
    .filter(Boolean)
    .sort((a, b) => a.messtag - b.messtag);

  state.rows = [];
  state.days = days;
  state.rows = days.flatMap(entriesFromDay);
  state.rawCsv = entriesToRawCsv(state.rows);
  if (!state.days.length) {
    throw new Error("Tagesdaten-Format erkannt, aber keine Messtage gefunden.");
  }
  buildFilters();
  render();
}

function entryFromRawRow(entry) {
  const date = parseDate(entry.Datum || "");
  if (!date) return null;
  return {
    original: date,
    type: entry.Typ === "Wasser" ? "Wasser" : "Urin",
    ml: Math.round(Number(entry.ml || 0)),
    note: (entry.Hinweis || "").trim(),
  };
}

function entriesFromDay(day) {
  const note = day.notesText || "";
  let noteUsed = false;
  const make = (item, type) => {
    const original = dateFromMesstagTime(day.messtag, item.time);
    const entry = { original, type, ml: item.ml, note: noteUsed ? "" : note };
    noteUsed = true;
    return entry;
  };
  return [...day.urine.map((item) => make(item, "Urin")), ...day.water.map((item) => make(item, "Wasser"))].sort((a, b) => a.original - b.original);
}

function dateFromMesstagTime(messtag, time) {
  const [h = 0, m = 0] = String(time || "00:00").split(":").map(Number);
  const date = new Date(messtag.getFullYear(), messtag.getMonth(), messtag.getDate(), h, m);
  if (h < 6) date.setDate(date.getDate() + 1);
  return date;
}

function entryKey(entry) {
  return [entry.original.getTime(), entry.type, entry.ml, entry.note.trim()].join("|");
}

function entriesToRawCsv(entries) {
  const rows = entries
    .slice()
    .sort((a, b) => a.original - b.original)
    .map((entry) => ({
      Datum: `${entry.original.getDate()}.${entry.original.getMonth() + 1}.${entry.original.getFullYear()} ${fmtTime(entry.original)}`,
      Typ: entry.type,
      ml: entry.ml,
      Hinweis: entry.note,
    }));
  return toCsv(rows);
}

function splitList(value) {
  return String(value || "")
    .split("|")
    .map((item) => item.trim())
    .filter(Boolean);
}

function parseAmount(value) {
  const cleaned = String(value || "")
    .replace("ml", "")
    .replaceAll(".", "")
    .trim();
  return Number(cleaned) || 0;
}

function zipTimesAmounts(times, amounts) {
  const count = Math.max(times.length, amounts.length);
  return Array.from({ length: count }, (_, index) => ({
    time: times[index] || "",
    ml: amounts[index] || 0,
  }));
}

function filteredDays() {
  return state.days.filter((day) => {
    const yearOk = state.year === "all" || String(day.year) === state.year;
    const monthOk = state.month === "all" || String(day.month) === state.month;
    return yearOk && monthOk;
  });
}

function aggregate(days, keys, buildLabel) {
  const grouped = new Map();
  for (const day of days) {
    const key = keys.map((k) => day[k]).join("-");
    if (!grouped.has(key)) {
      grouped.set(key, {
        ...buildLabel(day),
        days: 0,
        urineTotal: 0,
        waterTotal: 0,
        urineCount: 0,
        lowDays: 0,
      });
    }
    const row = grouped.get(key);
    row.days += 1;
    row.urineTotal += day.urineTotal;
    row.waterTotal += day.waterTotal;
    row.urineCount += day.urineCount;
    if (day.urineTotal < 800) row.lowDays += 1;
  }
  return Array.from(grouped.values()).map((row) => ({
    ...row,
    urineAverage: Math.round(row.urineTotal / row.days),
    alert: row.lowDays ? "niedrig" : "normal",
  }));
}

function buildFilters() {
  const years = [...new Set(state.days.map((day) => day.year))];
  els.yearFilter.innerHTML = `<option value="all">Alle Jahre</option>${years
    .map((year) => `<option value="${year}">${year}</option>`)
    .join("")}`;
  els.monthFilter.innerHTML = `<option value="all">Alle Monate</option>${monthNames
    .map((name, index) => `<option value="${index + 1}">${name}</option>`)
    .join("")}`;
}

function render() {
  const hasData = state.days.length > 0;
  els.emptyState.classList.toggle("active", !hasData);
  document.querySelectorAll(".view").forEach((view) => {
    if (!hasData) view.classList.remove("active");
  });
  document.querySelector(".tabs").style.display = hasData ? "flex" : "none";
  document.querySelector(".toolbar").style.display = "";
  els.yearFilter.disabled = !hasData;
  els.monthFilter.disabled = !hasData;
  els.backupCsv.disabled = !hasData;
  els.exportDays.disabled = !hasData;

  if (!hasData) {
    els.status.textContent = localStorage.getItem("urinSavedCsv")
      ? "Gespeicherte Daten vorhanden. Daten merken ist aktiv."
      : "Keine Daten geladen.";
    return;
  }

  const activeView = document.querySelector(".tab.active")?.dataset.view || "dashboard";
  document.body.dataset.view = activeView;
  document.querySelector(`#${activeView}`).classList.add("active");
  const days = filteredDays();
  const first = state.days[0]?.messtag;
  const last = state.days.at(-1)?.messtag;
  els.status.textContent = `${state.days.length} Messtage · ${first ? fmtDate(first) : "-"} bis ${last ? fmtDate(last) : "-"}`;

  renderMetrics(days);
  renderTables(days);
  drawLineChart(els.dailyChart, days.slice(-120));
  drawMonthChart(els.monthChart, aggregate(state.days, ["year", "month"], (day) => ({
    label: `${day.year}-${String(day.month).padStart(2, "0")}`,
  })));
}

function applyTheme(theme) {
  const themeAliases = { light: "classic-light", dark: "classic-dark" };
  const validThemes = new Set(["classic-light", "classic-dark", "violet-night", "liquid-dark", "medical-light", "high-contrast", "summer", "cream-sage"]);
  const selectedTheme = validThemes.has(themeAliases[theme] || theme) ? (themeAliases[theme] || theme) : "classic-light";
  const darkThemes = new Set(["classic-dark", "violet-night", "liquid-dark", "high-contrast"]);
  document.body.dataset.theme = selectedTheme;
  document.body.classList.toggle("dark", darkThemes.has(selectedTheme));
  els.themeSelect.value = selectedTheme;
  els.appMark.src = darkThemes.has(selectedTheme) ? "./assets/urobilanz-icon-dark.svg" : "./assets/urobilanz-icon-light.svg";
  localStorage.setItem("urinTheme", selectedTheme);
  if (state.days.length) render();
}

function renderMetrics(days) {
  const urineTotal = days.reduce((sum, day) => sum + day.urineTotal, 0);
  const waterTotal = days.reduce((sum, day) => sum + day.waterTotal, 0);
  const low = days.filter((day) => day.urineTotal < 800).length;
  const metrics = [
    ["Messtage", days.length],
    ["● Urin gesamt ml", fmtNumber(urineTotal)],
    ["● Urin Ø ml/Tag", fmtNumber(Math.round(urineTotal / Math.max(days.length, 1)))],
    ["💧 Wasser gesamt ml", fmtNumber(waterTotal)],
    ["Niedrige Urin-Tage", low],
    ["Normale Urin-Tage", days.length - low],
    ["Urin-Einträge", fmtNumber(days.reduce((sum, day) => sum + day.urineCount, 0))],
    ["Wasser-Einträge", fmtNumber(days.reduce((sum, day) => sum + day.water.length, 0))],
  ];
  els.metrics.innerHTML = metrics.map(([label, value]) => `<div class="metric"><span>${label}</span><strong>${value}</strong></div>`).join("");
}

function renderTables(days) {
  const yearRows = aggregate(days, ["year"], (day) => ({ Jahr: day.year }));
  const monthRows = aggregate(days, ["year", "month"], (day) => ({ Jahr: day.year, Monat: day.month, "Monat Name": day.monthName }));
  const weekRows = aggregate(days, ["year", "week"], (day) => ({ "ISO Jahr": day.year, "ISO Woche": day.week }));

  renderTable(els.yearTable, ["Jahr", "Tage", "● Urin Gesamt ml", "● Urin Ø ml/Tag", "● Urin Anzahl", "💧 Wasser Gesamt ml"], yearRows.map(summaryRow));
  renderTable(els.monthTable, ["Jahr", "Monat", "Monat Name", "Tage", "● Urin Gesamt ml", "● Urin Ø ml/Tag", "● Urin Anzahl", "💧 Wasser Gesamt ml"], monthRows.map(summaryRow));
  renderTable(els.weekTable, ["ISO Jahr", "ISO Woche", "Tage", "● Urin Gesamt ml", "● Urin Ø ml/Tag", "● Urin Anzahl", "💧 Wasser Gesamt ml", "Auffälligkeit"], weekRows.map(summaryRow));
  renderTable(els.alertTable, ["Messtag", "Tag", "● Urin gesamt ml", "💧 Wasser gesamt ml", "Auffälligkeit"], days
    .filter((day) => day.urineTotal < 800)
    .map((day) => ({
      Messtag: fmtDate(day.messtag),
      Tag: day.dayName,
      "● Urin gesamt ml": day.urineTotal,
      "💧 Wasser gesamt ml": day.waterTotal,
      Auffälligkeit: "niedrig",
    })));
  renderTable(els.dayTable, ["Jahr", "Monat", "KW", "Messtag", "Tag", "● Urin Uhrzeit", "● Urin ml", "● Urin Anzahl", "● Urin gesamt ml", "💧 Wasser Uhrzeit", "💧 Wasser ml", "💧 Wasser gesamt ml", "Hinweise"], days.map(dayRow), true);
}

function summaryRow(row) {
  return {
    ...row,
    Tage: row.days,
    "● Urin Gesamt ml": row.urineTotal,
    "● Urin Ø ml/Tag": row.urineAverage,
    "● Urin Anzahl": row.urineCount,
    "💧 Wasser Gesamt ml": row.waterTotal,
    Auffälligkeit: row.alert,
  };
}

function dayRow(day) {
  return {
    Jahr: day.year,
    Monat: day.monthName,
    KW: day.week,
    Messtag: fmtDate(day.messtag),
    Tag: day.dayName,
    "● Urin Uhrzeit": day.urine.map((item) => item.time).join("\n"),
    "● Urin ml": day.urine.map((item) => `${item.ml} ml`).join("\n"),
    "● Urin Anzahl": day.urineCount,
    "● Urin gesamt ml": day.urineTotal,
    "💧 Wasser Uhrzeit": day.water.map((item) => item.time).join("\n"),
    "💧 Wasser ml": day.water.map((item) => `${item.ml} ml`).join("\n"),
    "💧 Wasser gesamt ml": day.waterTotal,
    Hinweise: day.notesText,
  };
}

function renderTable(table, headers, rows, separateDays = false) {
  table.innerHTML = `
    ${separateDays ? `<colgroup>${headers.map((header) => `<col class="${headerClass(header)}">`).join("")}</colgroup>` : ""}
    <thead><tr>${headers.map((header) => `<th class="${headerClass(header)}">${header}</th>`).join("")}</tr></thead>
    <tbody>
      ${rows
        .map((row, index) => {
          const classes = separateDays ? "day-separator" : "";
          return `<tr class="${classes}">${headers
            .map((header) => {
              const value = row[header] ?? "";
              const valueClass = alertClass(header, value);
              const stack = String(value).includes("\n") ? "stack" : "";
              const cell = formatCell(header, value);
              return `<td class="${headerClass(header)} ${valueClass} ${stack}">${cell}</td>`;
            })
            .join("")}</tr>`;
        })
        .join("")}
    </tbody>
  `;
  table.classList.toggle("day-detail-table", separateDays);
}

function headerClass(header) {
  if (header.includes("Urin")) return "urine";
  if (header.includes("Wasser")) return "water";
  if (header === "Hinweise") return "note-col";
  return "";
}

function alertClass(header, value) {
  if (!header.includes("Urin") || typeof value !== "number") return "";
  if (value < 800 && header.includes("gesamt")) return "low";
  return "";
}

function formatCell(header, value) {
  if (typeof value === "number" && !["Jahr", "Monat", "KW", "ISO Jahr", "ISO Woche", "Tage", "● Urin Anzahl"].includes(header)) {
    return fmtNumber(value);
  }
  return String(value).replaceAll("&", "&amp;").replaceAll("<", "&lt;").replaceAll(">", "&gt;");
}

function drawLineChart(canvas, days) {
  const ctx = canvas.getContext("2d");
  const dpr = window.devicePixelRatio || 1;
  canvas.width = canvas.clientWidth * dpr;
  canvas.height = 260 * dpr;
  ctx.scale(dpr, dpr);
  const theme = chartTheme();
  drawAxes(ctx, canvas.clientWidth, 260, theme);
  drawSeries(ctx, days.map((day) => day.urineTotal), theme.urine, canvas.clientWidth, 260);
  drawSeries(ctx, days.map((day) => day.waterTotal), theme.water, canvas.clientWidth, 260);
  drawLegend(ctx, [["Urin", theme.urine], ["Wasser", theme.water]], theme);
}

function drawMonthChart(canvas, rows) {
  const ctx = canvas.getContext("2d");
  const dpr = window.devicePixelRatio || 1;
  canvas.width = canvas.clientWidth * dpr;
  canvas.height = 260 * dpr;
  ctx.scale(dpr, dpr);
  const width = canvas.clientWidth;
  const height = 260;
  const theme = chartTheme();
  ctx.clearRect(0, 0, width, height);
  const pad = 34;
  const max = Math.max(...rows.flatMap((row) => [row.urineTotal, row.waterTotal]), 1);
  const barW = Math.max(5, (width - pad * 2) / rows.length / 3);
  rows.forEach((row, index) => {
    const x = pad + index * ((width - pad * 2) / rows.length);
    const uH = (row.urineTotal / max) * (height - pad * 2);
    const wH = (row.waterTotal / max) * (height - pad * 2);
    ctx.fillStyle = theme.urine;
    ctx.fillRect(x, height - pad - uH, barW, uH);
    ctx.fillStyle = theme.water;
    ctx.fillRect(x + barW + 2, height - pad - wH, barW, wH);
  });
  drawLegend(ctx, [["Urin", theme.urine], ["Wasser", theme.water]], theme);
}

function chartTheme() {
  const styles = getComputedStyle(document.body);
  return {
    text: styles.getPropertyValue("--ink").trim(),
    line: styles.getPropertyValue("--line").trim(),
    urine: styles.getPropertyValue("--chart-urine").trim(),
    water: styles.getPropertyValue("--chart-water").trim(),
  };
}

function drawAxes(ctx, width, height, theme) {
  ctx.clearRect(0, 0, width, height);
  ctx.strokeStyle = theme.line;
  ctx.lineWidth = 1;
  ctx.beginPath();
  ctx.moveTo(34, 14);
  ctx.lineTo(34, height - 30);
  ctx.lineTo(width - 12, height - 30);
  ctx.stroke();
}

function drawSeries(ctx, values, color, width, height) {
  const max = Math.max(...values, 1);
  const xStep = (width - 52) / Math.max(values.length - 1, 1);
  ctx.strokeStyle = color;
  ctx.lineWidth = 2;
  ctx.beginPath();
  values.forEach((value, index) => {
    const x = 34 + index * xStep;
    const y = height - 30 - (value / max) * (height - 52);
    if (index === 0) ctx.moveTo(x, y);
    else ctx.lineTo(x, y);
  });
  ctx.stroke();
}

function drawLegend(ctx, items, theme) {
  items.forEach(([label, color], index) => {
    const x = 42 + index * 90;
    ctx.fillStyle = color;
    ctx.fillRect(x, 16, 12, 12);
    ctx.fillStyle = theme.text;
    ctx.font = "12px -apple-system, BlinkMacSystemFont, Segoe UI, sans-serif";
    ctx.fillText(label, x + 18, 26);
  });
}

document.querySelectorAll(".tab").forEach((button) => {
  button.addEventListener("click", () => {
    document.querySelectorAll(".tab, .view").forEach((el) => el.classList.remove("active"));
    button.classList.add("active");
    document.querySelector(`#${button.dataset.view}`).classList.add("active");
    document.body.dataset.view = button.dataset.view;
  });
});

els.yearFilter.addEventListener("change", (event) => {
  state.year = event.target.value;
  render();
});

els.monthFilter.addEventListener("change", (event) => {
  state.month = event.target.value;
  render();
});

async function loadCsvFile(file) {
  if (!file) return;
  try {
    const text = await file.text();
    processRows(parseCsv(text), text);
    if (els.rememberData.checked) {
      localStorage.setItem("urinSavedCsv", text);
    }
  } catch (error) {
    state.rows = [];
    state.days = [];
    state.rawCsv = "";
    render();
    els.status.textContent = `CSV konnte nicht gelesen werden: ${error.message}`;
    console.error(error);
  }
}

async function mergeCsvFile(file) {
  if (!file) return;
  try {
    const text = await file.text();
    const parsed = parseCsv(text);
    if (parsed[0] && Object.prototype.hasOwnProperty.call(parsed[0], "Messtag")) {
      throw new Error("Ergänzen ist nur mit der originalen Urinote-CSV möglich, nicht mit der Tagesdaten-CSV.");
    }
    const incoming = parsed.map(entryFromRawRow).filter(Boolean);
    if (!incoming.length) {
      throw new Error("Keine gültigen neuen Einträge gefunden.");
    }
    const existingKeys = new Set(state.rows.map(entryKey));
    const additions = incoming.filter((entry) => !existingKeys.has(entryKey(entry)));
    rebuildFromEntries([...state.rows, ...additions].sort((a, b) => a.original - b.original));
    rememberCurrentData();
    els.status.textContent = `${state.days.length} Messtage · ${additions.length} neue Einträge ergänzt · ${incoming.length - additions.length} bereits vorhanden`;
  } catch (error) {
    els.status.textContent = `CSV konnte nicht ergänzt werden: ${error.message}`;
    console.error(error);
  } finally {
    els.mergeCsvInput.value = "";
  }
}

els.csvInput.addEventListener("change", async (event) => {
  const file = event.target.files[0];
  await loadCsvFile(file);
});

els.emptyCsvInput.addEventListener("change", async (event) => {
  const file = event.target.files[0];
  await loadCsvFile(file);
});

els.mergeCsvInput.addEventListener("change", async (event) => {
  const file = event.target.files[0];
  await mergeCsvFile(file);
});

els.addEntry.addEventListener("click", () => {
  const now = new Date();
  els.entryDate.value = `${now.getFullYear()}-${String(now.getMonth() + 1).padStart(2, "0")}-${String(now.getDate()).padStart(2, "0")}`;
  els.entryTime.value = `${String(now.getHours()).padStart(2, "0")}:${String(now.getMinutes()).padStart(2, "0")}`;
  els.entryMl.value = "";
  els.entryNote.value = "";
  els.entryDialog.showModal();
});

els.cancelEntry.addEventListener("click", () => {
  els.entryDialog.close();
});

els.entryForm.addEventListener("submit", (event) => {
  event.preventDefault();
  const [year, month, day] = els.entryDate.value.split("-").map(Number);
  const [hour, minute] = els.entryTime.value.split(":").map(Number);
  const entry = {
    original: new Date(year, month - 1, day, hour, minute),
    type: els.entryType.value,
    ml: Math.round(Number(els.entryMl.value || 0)),
    note: els.entryNote.value.trim(),
  };
  const existing = new Set(state.rows.map(entryKey));
  if (!existing.has(entryKey(entry))) {
    rebuildFromEntries([...state.rows, entry].sort((a, b) => a.original - b.original));
    rememberCurrentData();
    els.status.textContent = `${state.days.length} Messtage · Eintrag hinzugefügt`;
  } else {
    els.status.textContent = "Eintrag war bereits vorhanden.";
  }
  els.entryDialog.close();
});

els.themeSelect.addEventListener("change", (event) => {
  applyTheme(event.target.value);
});

window.addEventListener("resize", () => render());

const savedTheme = localStorage.getItem("urinTheme");
const systemTheme = window.matchMedia?.("(prefers-color-scheme: dark)").matches ? "classic-dark" : "classic-light";
applyTheme(savedTheme || systemTheme);

els.rememberData.addEventListener("change", () => {
  localStorage.setItem("urinRememberData", els.rememberData.checked ? "yes" : "no");
  if (els.rememberData.checked && state.rawCsv) {
    localStorage.setItem("urinSavedCsv", state.rawCsv);
  }
  if (!els.rememberData.checked) {
    localStorage.removeItem("urinSavedCsv");
  }
  render();
});

els.forgetData.addEventListener("click", () => {
  localStorage.removeItem("urinSavedCsv");
  localStorage.setItem("urinRememberData", "no");
  els.rememberData.checked = false;
  state.rows = [];
  state.days = [];
  state.rawCsv = "";
  render();
});

els.backupCsv.addEventListener("click", () => {
  if (!state.rawCsv) return;
  downloadText(`urinote-backup-${dateStamp()}.csv`, entriesToRawCsv(state.rows), "text/csv;charset=utf-8");
});

els.exportDays.addEventListener("click", () => {
  const rows = state.days.map((day) => ({
    Jahr: day.year,
    Monat: day.monthName,
    KW: day.week,
    Messtag: fmtDate(day.messtag),
    Tag: day.dayName,
    "Urin Uhrzeit": day.urine.map((item) => item.time).join(" | "),
    "Urin ml": day.urine.map((item) => item.ml).join(" | "),
    "Urin Anzahl": day.urineCount,
    "Urin gesamt ml": day.urineTotal,
    "Wasser Uhrzeit": day.water.map((item) => item.time).join(" | "),
    "Wasser ml": day.water.map((item) => item.ml).join(" | "),
    "Wasser gesamt ml": day.waterTotal,
    Hinweise: day.notesText,
  }));
  downloadText(`urobilanz-tagesdaten-${dateStamp()}.csv`, toCsv(rows), "text/csv;charset=utf-8");
});

function dateStamp() {
  const now = new Date();
  return `${now.getFullYear()}${String(now.getMonth() + 1).padStart(2, "0")}${String(now.getDate()).padStart(2, "0")}`;
}

function rememberCurrentData() {
  state.rawCsv = entriesToRawCsv(state.rows);
  if (els.rememberData.checked) {
    localStorage.setItem("urinSavedCsv", state.rawCsv);
  }
}

function downloadText(filename, text, type) {
  const blob = new Blob([text], { type });
  const url = URL.createObjectURL(blob);
  const link = document.createElement("a");
  link.href = url;
  link.download = filename;
  document.body.appendChild(link);
  link.click();
  link.remove();
  URL.revokeObjectURL(url);
}

function toCsv(rows) {
  if (!rows.length) return "";
  const headers = Object.keys(rows[0]);
  const escape = (value) => {
    const text = String(value ?? "");
    return /[",\n;]/.test(text) ? `"${text.replaceAll('"', '""')}"` : text;
  };
  return [headers.join(","), ...rows.map((row) => headers.map((header) => escape(row[header])).join(","))].join("\n");
}

async function loadInitialData() {
  const remember = localStorage.getItem("urinRememberData") === "yes";
  els.rememberData.checked = remember;
  const saved = remember ? localStorage.getItem("urinSavedCsv") : "";
  if (saved) {
    processRows(parseCsv(saved), saved);
    return;
  }
  render();
}

loadInitialData();
