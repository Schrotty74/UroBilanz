const csvMonthNames = [
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
const {
  escapeHtml,
  inputDateValue,
  inputTimeValue,
  isoWeek,
  parseCsv,
  parseDate,
  parseDayDate,
  toMesstag,
  validateUroTheme,
} = window.UroCore;
const { drawLineChart, drawMonthChart } = window.UroCharts;
const supportedLanguages = new Set(["de", "en"]);
const builtInThemeIds = ["classic-light", "classic-dark", "violet-night", "liquid-dark", "medical-light", "high-contrast", "summer", "cream-sage"];
const builtInThemeSet = new Set(builtInThemeIds);
const darkThemeSet = new Set(["classic-dark", "violet-night", "liquid-dark", "high-contrast"]);
let customThemes = loadCustomThemes();
let language = supportedLanguages.has(localStorage.getItem("uroLanguage"))
  ? localStorage.getItem("uroLanguage")
  : ((navigator.language || "de").toLowerCase().startsWith("de") ? "de" : "en");

function t(key, replacements = {}) {
  const value = window.URO_I18N?.[language]?.[key] ?? window.URO_I18N?.de?.[key] ?? key;
  return Object.entries(replacements).reduce((text, [name, replacement]) => text.replaceAll(`{${name}}`, replacement), value);
}

function monthNames() {
  return window.URO_I18N?.[language]?.months ?? csvMonthNames;
}

function weekdayNames() {
  return window.URO_I18N?.[language]?.weekdays ?? dayNames;
}

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
  themeInput: document.querySelector("#themeInput"),
  exportTheme: document.querySelector("#exportTheme"),
  deleteTheme: document.querySelector("#deleteTheme"),
  themeMenu: document.querySelector("#themeMenu"),
  themeMenuButton: document.querySelector("#themeMenuButton"),
  themeMenuPanel: document.querySelector("#themeMenuPanel"),
  themeMenuOptions: document.querySelector("#themeMenuOptions"),
  selectedThemeLabel: document.querySelector("#selectedThemeLabel"),
  themeSelect: document.querySelector("#themeSelect"),
  languageSelect: document.querySelector("#languageSelect"),
  appMark: document.querySelector("#appMark"),
  addEntry: document.querySelector("#addEntry"),
  entryDialog: document.querySelector("#entryDialog"),
  entryForm: document.querySelector("#entryForm"),
  cancelEntry: document.querySelector("#cancelEntry"),
  resetEntry: document.querySelector("#resetEntry"),
  addEntryAndClose: document.querySelector("#addEntryAndClose"),
  entryDialogTitle: document.querySelector("#entryDialogTitle"),
  entryEditIndex: document.querySelector("#entryEditIndex"),
  entryDate: document.querySelector("#entryDate"),
  entryUrineTime: document.querySelector("#entryUrineTime"),
  entryUrineMl: document.querySelector("#entryUrineMl"),
  entryWaterTime: document.querySelector("#entryWaterTime"),
  entryWaterMl: document.querySelector("#entryWaterMl"),
  entryNote: document.querySelector("#entryNote"),
  entryList: document.querySelector("#entryList"),
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

function fmtDate(date) {
  return date.toLocaleDateString(language === "de" ? "de-AT" : "en-US", { day: "2-digit", month: "2-digit", year: "numeric" });
}

function fmtNumber(value) {
  return Number(value).toLocaleString(language === "de" ? "de-DE" : "en-US");
}

function fmtTime(date) {
  return date.toLocaleTimeString(language === "de" ? "de-AT" : "en-US", { hour: "2-digit", minute: "2-digit", hour12: false });
}

function loadCustomThemes() {
  try {
    const parsed = JSON.parse(localStorage.getItem("uroCustomThemes") || "[]");
    if (!Array.isArray(parsed)) return [];
    return parsed.map((theme) => validateUroTheme(theme, builtInThemeIds));
  } catch {
    localStorage.removeItem("uroCustomThemes");
    return [];
  }
}

function saveCustomThemes() {
  localStorage.setItem("uroCustomThemes", JSON.stringify(customThemes));
}

function themeFileName(theme) {
  return `urobilanz-theme-${theme.id}.json`;
}

function customThemeTitle(theme) {
  return theme.name?.[language] || theme.name?.de || theme.name?.en || theme.id;
}

function uniqueCustomThemeId(baseId) {
  let id = baseId;
  let index = 2;
  while (builtInThemeSet.has(id) || customThemeById(id)) {
    id = `${baseId}-${index}`;
    index += 1;
  }
  return id;
}

function cssColorToHex(value) {
  const text = String(value || "").trim();
  const hex = text.match(/^#([0-9a-f]{6})$/i);
  if (hex) return `#${hex[1].toUpperCase()}`;
  const shortHex = text.match(/^#([0-9a-f]{3})$/i);
  if (shortHex) return `#${shortHex[1].split("").map((part) => `${part}${part}`).join("").toUpperCase()}`;
  const rgb = text.match(/^rgba?\(\s*([0-9.]+)[,\s]+([0-9.]+)[,\s]+([0-9.]+)/i);
  if (!rgb) return null;
  return `#${rgb.slice(1, 4).map((part) => Math.max(0, Math.min(255, Math.round(Number(part)))).toString(16).padStart(2, "0")).join("").toUpperCase()}`;
}

function themeColor(styles, property, fallback) {
  return cssColorToHex(styles.getPropertyValue(property)) || fallback;
}

function builtInThemeCopy(id) {
  const styles = getComputedStyle(document.body);
  const titleDe = window.URO_I18N?.de?.themes?.[id] ?? id;
  const titleEn = window.URO_I18N?.en?.themes?.[id] ?? titleDe;
  const theme = {
    format: "urobilanz-theme",
    version: 1,
    id: uniqueCustomThemeId(`${id}-custom`),
    name: {
      de: `${titleDe} Kopie`,
      en: `${titleEn} Copy`,
    },
    mode: darkThemeSet.has(id) ? "dark" : "light",
    colors: {
      text: themeColor(styles, "--ink", darkThemeSet.has(id) ? "#FFFFFF" : "#172024"),
      mutedText: themeColor(styles, "--muted", darkThemeSet.has(id) ? "#C9D4D2" : "#64706E"),
      background: themeColor(styles, "--body-bg", darkThemeSet.has(id) ? "#0E171A" : "#F6FBFA"),
      backgroundAlt: themeColor(styles, "--soft", darkThemeSet.has(id) ? "#172326" : "#E8F3F1"),
      panel: themeColor(styles, "--paper", darkThemeSet.has(id) ? "#142024" : "#FFFFFF"),
      panelSoft: themeColor(styles, "--panel-soft", darkThemeSet.has(id) ? "#1B292C" : "#F2F8F6"),
      border: themeColor(styles, "--line", darkThemeSet.has(id) ? "#4E6B66" : "#C8D8D5"),
      accent: themeColor(styles, "--accent", "#A8C957"),
      accentText: themeColor(styles, "--accent-ink", darkThemeSet.has(id) ? "#101614" : "#FFFFFF"),
      urine: themeColor(styles, "--urine-strong", "#F6C84F"),
      urineSoft: themeColor(styles, "--urine", "#F7E3A4"),
      water: themeColor(styles, "--water-strong", "#2D91E8"),
      waterSoft: themeColor(styles, "--water", "#B9DBF8"),
      low: themeColor(styles, "--low", darkThemeSet.has(id) ? "#5C252B" : "#F8D7DA"),
      rowOdd: themeColor(styles, "--row-odd", darkThemeSet.has(id) ? "#192529" : "#F4FAF8"),
      rowEven: themeColor(styles, "--row-even", darkThemeSet.has(id) ? "#101A1D" : "#FFFFFF"),
      chartUrine: themeColor(styles, "--chart-urine", "#F6C84F"),
      chartWater: themeColor(styles, "--chart-water", "#2D91E8"),
    },
    effects: {
      glassOpacity: 0.86,
      glassBorderOpacity: 0.3,
      shadowOpacity: darkThemeSet.has(id) ? 0.28 : 0.16,
    },
  };
  return validateUroTheme(theme, builtInThemeIds);
}

function rebuildThemeOptions(activeTheme = els.themeSelect.value || localStorage.getItem("urinTheme") || "classic-light") {
  els.themeSelect.innerHTML = "";
  els.themeMenuOptions.innerHTML = "";
  const addThemeOption = (id, title) => {
    const option = document.createElement("option");
    option.value = id;
    option.textContent = title;
    els.themeSelect.append(option);

    const button = document.createElement("button");
    button.type = "button";
    button.className = `theme-menu-option${id === activeTheme ? " active" : ""}`;
    button.dataset.theme = id;
    button.textContent = title;
    if (id === activeTheme) {
      const check = document.createElement("span");
      check.textContent = "✓";
      button.append(check);
      els.selectedThemeLabel.textContent = title;
    }
    els.themeMenuOptions.append(button);
  };
  for (const id of builtInThemeIds) addThemeOption(id, window.URO_I18N?.[language]?.themes?.[id] ?? id);
  for (const theme of customThemes) addThemeOption(theme.id, customThemeTitle(theme));
}

function customThemeById(id) {
  return customThemes.find((theme) => theme.id === id);
}

function clearCustomThemeVariables() {
  [
    "--ink", "--muted", "--line", "--teal", "--teal-dark", "--accent", "--accent-ink",
    "--urine", "--urine-strong", "--water", "--water-strong", "--soft", "--paper",
    "--panel", "--panel-soft", "--glass-bg", "--glass-line", "--glass-shadow",
    "--chart-urine", "--chart-water", "--low", "--body-bg", "--row-odd", "--row-even",
  ].forEach((name) => document.body.style.removeProperty(name));
}

function hexToRgb(hex) {
  const value = hex.replace("#", "");
  return [0, 2, 4].map((start) => parseInt(value.slice(start, start + 2), 16));
}

function rgba(hex, opacity) {
  const [r, g, b] = hexToRgb(hex);
  return `rgba(${r}, ${g}, ${b}, ${opacity})`;
}

function applyCustomThemeVariables(theme) {
  const c = theme.colors;
  const e = theme.effects || {};
  const set = (name, value) => document.body.style.setProperty(name, value);
  const panelOpacity = e.glassOpacity ?? 0.86;
  const borderOpacity = e.glassBorderOpacity ?? 0.30;
  const shadowOpacity = e.shadowOpacity ?? 0.24;
  set("--ink", c.text);
  set("--muted", c.mutedText || c.text);
  set("--line", c.border || rgba(c.accent, borderOpacity));
  set("--teal", c.backgroundAlt || c.panel);
  set("--teal-dark", c.accent);
  set("--accent", c.accent);
  set("--accent-ink", c.accentText || c.background);
  set("--urine", c.urineSoft || rgba(c.urine, theme.mode === "dark" ? 0.22 : 0.30));
  set("--urine-strong", c.urine);
  set("--water", c.waterSoft || rgba(c.water, theme.mode === "dark" ? 0.22 : 0.30));
  set("--water-strong", c.water);
  set("--soft", c.panelSoft || c.backgroundAlt || c.panel);
  set("--paper", c.panel);
  set("--panel", rgba(c.panel, panelOpacity));
  set("--panel-soft", rgba(c.panelSoft || c.panel, Math.max(0.35, panelOpacity - 0.08)));
  set("--glass-bg", rgba(c.panel, Math.max(0.10, panelOpacity - 0.50)));
  set("--glass-line", rgba(c.accent, borderOpacity));
  set("--glass-shadow", rgba("#000000", shadowOpacity));
  set("--chart-urine", c.chartUrine || c.urine);
  set("--chart-water", c.chartWater || c.water);
  set("--low", c.low || (theme.mode === "dark" ? "#5C252B" : "#F8D7DA"));
  set("--body-bg", c.background);
  set("--row-odd", c.rowOdd || c.panelSoft || c.panel);
  set("--row-even", c.rowEven || c.panel);
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
    row.messtagKey = localDayKey(messtag);
    row.isoYear = iso.year;
    row.week = iso.week;
    if (!byDay.has(row.messtagKey)) {
      byDay.set(row.messtagKey, {
        messtag: row.messtag,
        key: row.messtagKey,
        year: row.messtag.getFullYear(),
        month: row.messtag.getMonth() + 1,
        monthName: monthNames()[row.messtag.getMonth()],
        dayName: weekdayNames()[row.messtag.getDay()],
        week: row.week,
        urine: [],
        water: [],
        notes: [],
        noteRows: [],
        generalNotes: [],
      });
    }
    const day = byDay.get(row.messtagKey);
    if (row.type === "Wasser") {
      day.water.push({ time: fmtTime(row.original), ml: row.ml });
    }
    if (row.type === "Urin") {
      day.urine.push({ time: fmtTime(row.original), ml: row.ml });
    }
    if (row.note) {
      day.notes.push(row.note);
      if (row.type === "Urin") {
        day.noteRows.push({ time: fmtTime(row.original), note: row.note });
      }
      if (row.type === "Hinweis") {
        day.generalNotes.push(row.note);
      }
    }
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
    throw new Error(t("invalid_entries"));
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
      const generalNotes = splitList(entry["Allgemeine Hinweise"] || "");
      const urineNoteSlots = splitListKeepingEmpty(entry["Urin Hinweis"] || "");
      const importedNoteRows = urine
        .map((item, index) => ({ time: item.time, note: urineNoteSlots[index] || "" }))
        .filter((item) => item.note);
      const legacyNotes = notesText ? [notesText] : [];
      const notes = [...importedNoteRows.map((item) => item.note), ...generalNotes];
      return {
        messtag,
        key: localDayKey(messtag),
        year: messtag.getFullYear(),
        month: messtag.getMonth() + 1,
        monthName: monthNames()[messtag.getMonth()],
        dayName: weekdayNames()[messtag.getDay()],
        week: Number(entry.KW || iso.week),
        urine,
        water,
        notes: notes.length ? notes : legacyNotes,
        noteRows: importedNoteRows,
        generalNotes,
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
    throw new Error(t("invalid_daily_data"));
  }
  buildFilters();
  render();
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

function entriesFromDay(day) {
  const note = day.notesText || "";
  const make = (item, type, entryNote = "") => {
    const original = dateFromMesstagTime(day.messtag, item.time);
    return { original, type, ml: item.ml, note: entryNote };
  };
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

function splitListKeepingEmpty(value) {
  return String(value || "")
    .split("|")
    .map((item) => item.trim());
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

function measurementMinute(time) {
  const [hour, minute] = String(time || "").split(":").map(Number);
  if (!Number.isFinite(hour) || !Number.isFinite(minute)) return null;
  return (hour < 6 ? hour + 24 : hour) * 60 + minute;
}

function isCompleteMeasurementDay(day) {
  const minutes = [...day.urine, ...day.water]
    .map((entry) => measurementMinute(entry.time))
    .filter((minute) => minute !== null);
  if (minutes.length < 2) return false;
  return Math.max(...minutes) - Math.min(...minutes) >= 8 * 60;
}

function evaluationDays(days) {
  return days.filter(isCompleteMeasurementDay);
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
        incompleteDays: 0,
      });
    }
    const row = grouped.get(key);
    if (!isCompleteMeasurementDay(day)) {
      row.incompleteDays += 1;
      continue;
    }
    row.days += 1;
    row.urineTotal += day.urineTotal;
    row.waterTotal += day.waterTotal;
    row.urineCount += day.urineCount;
    if (day.urineTotal < 700) row.lowDays += 1;
  }
  return Array.from(grouped.values()).map((row) => ({
    ...row,
    urineAverage: row.days ? Math.round(row.urineTotal / row.days) : 0,
    alert: row.incompleteDays
      ? row.days
        ? t(row.lowDays ? "low_with_incomplete" : "normal_with_incomplete", { count: row.incompleteDays })
        : t("incomplete")
      : t(row.lowDays ? "low" : "normal"),
  }));
}

function buildFilters() {
  const years = [...new Set(state.days.map((day) => day.year))];
  els.yearFilter.innerHTML = `<option value="all">${t("all_years")}</option>${years
    .map((year) => `<option value="${year}">${year}</option>`)
    .join("")}`;
  els.monthFilter.innerHTML = `<option value="all">${t("all_months")}</option>${monthNames()
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
      ? t("saved_data_available")
      : t("no_data");
    return;
  }

  const activeView = document.querySelector(".tab.active")?.dataset.view || "dashboard";
  document.body.dataset.view = activeView;
  document.querySelector(`#${activeView}`).classList.add("active");
  const days = filteredDays();
  const dashboardDays = evaluationDays(days);
  const first = state.days[0]?.messtag;
  const last = state.days.at(-1)?.messtag;
  els.status.textContent = `${state.days.length} ${t("measurement_days")} · ${first ? fmtDate(first) : "-"} ${t("to")} ${last ? fmtDate(last) : "-"}`;

  renderMetrics(dashboardDays);
  renderTables(days, dashboardDays);
  drawLineChart(els.dailyChart, dashboardDays.slice(-120), { urine: t("urine"), water: t("water") });
  drawMonthChart(els.monthChart, aggregate(evaluationDays(state.days), ["year", "month"], (day) => ({
    label: `${day.year}-${String(day.month).padStart(2, "0")}`,
  })), { urine: t("urine"), water: t("water") });
}

function applyTheme(theme) {
  const themeAliases = { light: "classic-light", dark: "classic-dark" };
  const requestedTheme = themeAliases[theme] || theme;
  const selectedTheme = builtInThemeSet.has(requestedTheme) || customThemeById(requestedTheme) ? requestedTheme : "classic-light";
  const customTheme = customThemeById(selectedTheme);
  const isDark = customTheme ? customTheme.mode === "dark" : darkThemeSet.has(selectedTheme);
  clearCustomThemeVariables();
  document.body.dataset.theme = selectedTheme;
  document.body.classList.toggle("dark", isDark);
  if (customTheme) applyCustomThemeVariables(customTheme);
  rebuildThemeOptions(selectedTheme);
  els.themeSelect.value = selectedTheme;
  els.selectedThemeLabel.textContent = els.themeSelect.selectedOptions[0]?.textContent || selectedTheme;
  els.exportTheme.disabled = false;
  els.deleteTheme.disabled = !customTheme;
  els.appMark.src = isDark ? "./assets/urobilanz-icon-dark.svg" : "./assets/urobilanz-icon-light.svg";
  localStorage.setItem("urinTheme", selectedTheme);
  if (state.days.length) render();
}

function applyLanguage(nextLanguage) {
  language = supportedLanguages.has(nextLanguage) ? nextLanguage : "de";
  localStorage.setItem("uroLanguage", language);
  document.documentElement.lang = language;
  els.languageSelect.value = language;
  document.querySelectorAll("[data-i18n]").forEach((element) => {
    element.textContent = t(element.dataset.i18n);
  });
  const activeTheme = els.themeSelect.value;
  rebuildThemeOptions(activeTheme);
  els.themeSelect.value = activeTheme;
  els.selectedThemeLabel.textContent = els.themeSelect.selectedOptions[0]?.textContent || activeTheme;
  els.themeSelect.setAttribute("aria-label", t("theme"));
  els.languageSelect.setAttribute("aria-label", t("language"));
  els.yearFilter.setAttribute("aria-label", t("year"));
  els.monthFilter.setAttribute("aria-label", t("month"));
  buildFilters();
  render();
}

async function importThemeFile(file) {
  if (!file) return;
  try {
    const text = await file.text();
    const theme = validateUroTheme(JSON.parse(text), builtInThemeIds);
    customThemes = [...customThemes.filter((item) => item.id !== theme.id), theme].sort((a, b) => customThemeTitle(a).localeCompare(customThemeTitle(b)));
    saveCustomThemes();
    applyTheme(theme.id);
    els.status.textContent = t("theme_imported", { name: customThemeTitle(theme) });
  } catch (error) {
    window.alert(t("theme_import_error", { message: error.message || String(error) }));
  } finally {
    els.themeInput.value = "";
  }
}

function exportSelectedTheme() {
  const selectedId = els.themeSelect.value;
  const theme = customThemeById(selectedId) || builtInThemeCopy(selectedId);
  downloadText(themeFileName(theme), `${JSON.stringify(theme, null, 2)}\n`, "application/json;charset=utf-8");
  closeThemeMenu();
}

function deleteSelectedTheme() {
  const theme = customThemeById(els.themeSelect.value);
  if (!theme) {
    window.alert(t("theme_delete_builtin"));
    return;
  }
  const name = customThemeTitle(theme);
  if (!window.confirm(t("theme_delete_confirm", { name }))) return;
  customThemes = customThemes.filter((item) => item.id !== theme.id);
  saveCustomThemes();
  applyTheme("classic-light");
  els.status.textContent = t("theme_deleted", { name });
  closeThemeMenu();
}

function setThemeMenuOpen(open) {
  els.themeMenuPanel.hidden = !open;
  els.themeMenuButton.setAttribute("aria-expanded", String(open));
}

function closeThemeMenu() {
  setThemeMenuOpen(false);
}

function renderMetrics(days) {
  const urineTotal = days.reduce((sum, day) => sum + day.urineTotal, 0);
  const waterTotal = days.reduce((sum, day) => sum + day.waterTotal, 0);
  const low = days.filter((day) => day.urineTotal < 700).length;
  const metrics = [
    [t("measurement_days"), days.length],
    [t("urine_total"), fmtNumber(urineTotal)],
    [t("urine_average"), fmtNumber(Math.round(urineTotal / Math.max(days.length, 1)))],
    [t("water_total"), fmtNumber(waterTotal)],
    [t("low_days"), low],
    [t("normal_days"), days.length - low],
    [t("urine_entries"), fmtNumber(days.reduce((sum, day) => sum + day.urineCount, 0))],
    [t("water_entries"), fmtNumber(days.reduce((sum, day) => sum + day.water.length, 0))],
  ];
  els.metrics.innerHTML = metrics.map(([label, value]) => `<div class="metric"><span>${label}</span><strong>${value}</strong></div>`).join("");
}

function renderTables(days, dashboardDays = evaluationDays(days)) {
  const yearRows = aggregate(days, ["year"], (day) => ({ Jahr: day.year }));
  const monthRows = aggregate(days, ["year", "month"], (day) => ({ Jahr: day.year, Monat: day.month, "Monat Name": monthNames()[day.month - 1] }));
  const weekRows = aggregate(days, ["year", "week"], (day) => ({ "ISO Jahr": day.year, "ISO Woche": day.week }));

  renderTable(els.yearTable, ["Jahr", "Tage", "Unvollständige Tage", "● Urin Gesamt ml", "● Urin Ø ml/Tag", "● Urin Anzahl", "💧 Wasser Gesamt ml"], yearRows.map(summaryRow));
  renderTable(els.monthTable, ["Jahr", "Monat", "Monat Name", "Tage", "Unvollständige Tage", "● Urin Gesamt ml", "● Urin Ø ml/Tag", "● Urin Anzahl", "💧 Wasser Gesamt ml"], monthRows.map(summaryRow));
  renderTable(els.weekTable, ["ISO Jahr", "ISO Woche", "Tage", "Unvollständige Tage", "● Urin Gesamt ml", "● Urin Ø ml/Tag", "● Urin Anzahl", "💧 Wasser Gesamt ml", "Auffälligkeit"], weekRows.map(summaryRow));
  renderTable(els.alertTable, ["Messtag", "Tag", "● Urin gesamt ml", "💧 Wasser gesamt ml", "Auffälligkeit"], days
    .filter((day) => !isCompleteMeasurementDay(day) || day.urineTotal < 700)
    .map((day) => ({
      Messtag: fmtDate(day.messtag),
      Tag: weekdayNames()[day.messtag.getDay()],
      "● Urin gesamt ml": day.urineTotal,
      "💧 Wasser gesamt ml": day.waterTotal,
      Auffälligkeit: t(isCompleteMeasurementDay(day) ? "low" : "incomplete"),
    })));
  renderTable(els.dayTable, ["Jahr", "Monat", "KW", "Messtag", "Tag", "● Urin Uhrzeit", "● Urin ml", "● Urin Anzahl", "● Urin gesamt ml", "💧 Wasser Uhrzeit", "💧 Wasser ml", "💧 Wasser gesamt ml", "Auffälligkeit", "Hinweise", "Aktion"], days.map(dayRow), true);
}

function summaryRow(row) {
  return {
    ...row,
    Tage: row.days,
    "Unvollständige Tage": row.incompleteDays,
    "● Urin Gesamt ml": row.urineTotal,
    "● Urin Ø ml/Tag": row.urineAverage,
    "● Urin Anzahl": row.urineCount,
    "💧 Wasser Gesamt ml": row.waterTotal,
    Auffälligkeit: row.alert,
  };
}

function dayRow(day) {
  const noteRows = alignedNoteRows(noteRowsForDay(day), day.urine.map((item) => item.time));
  noteRows.push(...generalNotesForDay(day));
  return {
    Jahr: day.year,
    Monat: monthNames()[day.month - 1],
    KW: day.week,
    Messtag: fmtDate(day.messtag),
    Tag: weekdayNames()[day.messtag.getDay()],
    "● Urin Uhrzeit": day.urine.map((item) => item.time).join("\n"),
    "● Urin ml": day.urine.map((item) => `${item.ml} ml`).join("\n"),
    "● Urin Anzahl": day.urineCount,
    "● Urin gesamt ml": day.urineTotal,
    "💧 Wasser Uhrzeit": day.water.map((item) => item.time).join("\n"),
    "💧 Wasser ml": day.water.map((item) => `${item.ml} ml`).join("\n"),
    "💧 Wasser gesamt ml": day.waterTotal,
    Auffälligkeit: t(!isCompleteMeasurementDay(day) ? "incomplete" : day.urineTotal < 700 ? "low" : "normal"),
    Hinweise: noteRows,
    Aktion: day.key,
  };
}

function noteRowsForDay(day) {
  const rows = state.rows
    .filter((entry) => entryDayKey(entry) === day.key && entry.type === "Urin" && entry.note)
    .map((entry) => ({ time: fmtTime(entry.original), note: entry.note }));
  return rows.length ? rows : (day.noteRows || []);
}

function generalNotesForDay(day) {
  const rows = state.rows
    .filter((entry) => entryDayKey(entry) === day.key && entry.type === "Hinweis" && entry.note)
    .map((entry) => entry.note);
  return rows.length ? rows : (day.generalNotes || []);
}

function entryDayKey(entry) {
  return entry.messtagKey || localDayKey(toMesstag(entry.original));
}

function localDayKey(date) {
  return inputDateValue(date);
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

function renderTable(table, headers, rows, separateDays = false) {
  table.innerHTML = `
    ${separateDays ? `<colgroup>${headers.map((header) => `<col class="${headerClass(header)}">`).join("")}</colgroup>` : ""}
    <thead><tr>${headers.map((header) => `<th class="${headerClass(header)}">${displayHeader(header)}</th>`).join("")}</tr></thead>
    <tbody>
      ${rows
        .map((row, index) => {
          const classes = separateDays ? "day-separator" : "";
          return `<tr class="${classes}">${headers
            .map((header) => {
              const value = row[header] ?? "";
              const valueClass = alertClass(header, value, row);
              const stack = String(value).includes("\n") || Array.isArray(value) ? "stack" : "";
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

function displayHeader(header) {
  const keys = {
    Jahr: "year",
    Monat: "month",
    "Monat Name": "month",
    Tage: "days",
    "Unvollständige Tage": "incomplete_days",
    Tag: "day",
    Messtag: "date",
    "ISO Jahr": "year",
    "ISO Woche": "week",
    KW: "week",
    "● Urin Gesamt ml": "urine_total",
    "● Urin gesamt ml": "urine_total",
    "● Urin Ø ml/Tag": "urine_average",
    "● Urin Anzahl": "urine_count",
    "● Urin Uhrzeit": "urine_time",
    "● Urin ml": "urine_ml",
    "💧 Wasser Gesamt ml": "water_total",
    "💧 Wasser gesamt ml": "water_total",
    "💧 Wasser Uhrzeit": "water_time",
    "💧 Wasser ml": "water_ml",
    Hinweise: "hints",
    Auffälligkeit: "flag",
    Aktion: "action",
  };
  return escapeHtml(t(keys[header] || header));
}

function headerClass(header) {
  if (header.includes("Urin")) return "urine";
  if (header.includes("Wasser")) return "water";
  if (header === "Hinweise") return "note-col";
  if (header === "Aktion") return "action-col";
  return "";
}

function alertClass(header, value, row) {
  if (!header.includes("Urin") || typeof value !== "number") return "";
  if (row.Auffälligkeit === t("low") && header.includes("gesamt")) return "low";
  return "";
}

function formatCell(header, value) {
  if (header === "Aktion") {
    return `<button class="utility-button quiet delete-day" type="button" data-delete-day="${escapeHtml(value)}">${escapeHtml(t("delete_day"))}</button>`;
  }
  if (header === "Hinweise" && Array.isArray(value)) {
    if (!value.length) return "";
    return `<div class="note-lines">${value.map((note) => `<div class="note-line"><span class="note-text">${escapeHtml(note || " ")}</span></div>`).join("")}</div>`;
  }
  if (typeof value === "number" && !["Jahr", "Monat", "KW", "ISO Jahr", "ISO Woche", "Tage", "● Urin Anzahl"].includes(header)) {
    return fmtNumber(value);
  }
  return escapeHtml(value);
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
    els.status.textContent = t("csv_read_error", { message: error.message });
    console.error(error);
  }
}

async function mergeCsvFile(file) {
  if (!file) return;
  try {
    const text = await file.text();
    const parsed = parseCsv(text);
    if (parsed[0] && Object.prototype.hasOwnProperty.call(parsed[0], "Messtag")) {
      throw new Error(t("merge_original_only"));
    }
    const incoming = parsed.map(entryFromRawRow).filter(Boolean);
    if (!incoming.length) {
      throw new Error(t("no_new_entries"));
    }
    const existingKeys = new Set(state.rows.map(entryKey));
    const additions = incoming.filter((entry) => !existingKeys.has(entryKey(entry)));
    rebuildFromEntries([...state.rows, ...additions].sort((a, b) => a.original - b.original));
    rememberCurrentData();
    els.status.textContent = t("merge_result", { days: state.days.length, added: additions.length, existing: incoming.length - additions.length });
  } catch (error) {
    els.status.textContent = t("csv_merge_error", { message: error.message });
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
  els.entryEditIndex.value = "";
  els.entryDate.value = inputDateValue(toMesstag(now));
  const time = inputTimeValue(now);
  els.entryUrineTime.value = time;
  els.entryWaterTime.value = time;
  els.entryUrineMl.value = "";
  els.entryWaterMl.value = "";
  els.entryNote.value = "";
  els.entryDialogTitle.textContent = t("entry_add");
  renderEntryList();
  els.entryDialog.showModal();
});

els.cancelEntry.addEventListener("click", () => {
  els.entryDialog.close();
});

els.resetEntry.addEventListener("click", () => {
  resetEntryForm();
});

els.entryDate.addEventListener("change", renderEntryList);

els.entryList.addEventListener("click", (event) => {
  const button = event.target.closest("button[data-action]");
  if (!button) return;
  const index = Number(button.dataset.index);
  if (button.dataset.action === "edit") {
    fillEntryForm(index);
  }
  if (button.dataset.action === "delete") {
    confirmDeleteEntry(index);
  }
});

els.dayTable.addEventListener("click", (event) => {
  const button = event.target.closest("button[data-delete-day]");
  if (!button) return;
  confirmDeleteDay(button.dataset.deleteDay);
});

els.entryForm.addEventListener("submit", (event) => {
  event.preventDefault();
  const [year, month, day] = els.entryDate.value.split("-").map(Number);
  const note = els.entryNote.value.trim();
  const entryFor = (timeValue, type, ml, entryNote = "") => {
    const [hour = 12, minute = 0] = String(timeValue || "12:00").split(":").map(Number);
    return {
      original: new Date(year, month - 1, day, hour, minute),
      type,
      ml: Math.round(Number(ml || 0)),
      note: entryNote,
    };
  };
  const entries = [];
  if (els.entryUrineMl.value !== "") entries.push(entryFor(els.entryUrineTime.value, "Urin", els.entryUrineMl.value));
  if (els.entryWaterMl.value !== "") entries.push(entryFor(els.entryWaterTime.value, "Wasser", els.entryWaterMl.value));
  if (note) {
    const noteTime = entries[0] ? fmtTime(entries[0].original) : (els.entryUrineTime.value || els.entryWaterTime.value || "12:00");
    entries.push(entryFor(noteTime, "Hinweis", 0, note));
  }

  if (!entries.length) {
    els.status.textContent = t("no_entry_created");
    return;
  }

  const editIndex = els.entryEditIndex.value === "" ? -1 : Number(els.entryEditIndex.value);
  const nextRows = state.rows.slice();
  if (editIndex >= 0) nextRows.splice(editIndex, 1);
  rebuildFromEntries([...nextRows, ...entries].sort((a, b) => a.original - b.original));
  rememberCurrentData();
  els.status.textContent = t("entry_result", { days: state.days.length, count: entries.length, action: t(editIndex >= 0 ? "updated" : "added") });
  if (event.submitter === els.addEntryAndClose) {
    els.entryDialog.close();
  } else {
    resetEntryForm({ keepTime: true });
  }
});

function resetEntryForm(options = {}) {
  const selectedDay = parseInputDay(els.entryDate.value) || toMesstag(new Date());
  const now = new Date();
  const previousUrineTime = els.entryUrineTime.value;
  const previousWaterTime = els.entryWaterTime.value;
  els.entryEditIndex.value = "";
  els.entryDialogTitle.textContent = t("entry_add");
  els.entryDate.value = inputDateValue(selectedDay);
  els.entryUrineTime.value = options.keepTime && previousUrineTime ? previousUrineTime : inputTimeValue(now);
  els.entryWaterTime.value = options.keepTime && previousWaterTime ? previousWaterTime : inputTimeValue(now);
  els.entryUrineMl.value = "";
  els.entryWaterMl.value = "";
  els.entryNote.value = "";
  renderEntryList();
}

function parseInputDay(value) {
  const [year, month, day] = String(value || "").split("-").map(Number);
  if (!year || !month || !day) return null;
  return new Date(year, month - 1, day);
}

function entryListRows() {
  const selectedDay = parseInputDay(els.entryDate.value);
  if (!selectedDay) return [];
  const key = localDayKey(selectedDay);
  return state.rows
    .map((entry, index) => ({ entry, index }))
    .filter(({ entry }) => localDayKey(toMesstag(entry.original)) === key)
    .sort((a, b) => a.entry.original - b.entry.original);
}

function renderEntryList() {
  const rows = entryListRows();
  if (!rows.length) {
    els.entryList.innerHTML = `<p>${escapeHtml(t("no_entries_day"))}</p>`;
    return;
  }
  els.entryList.innerHTML = rows
    .map(({ entry, index }) => {
      const label = entry.type === "Hinweis" ? t("note") : `${entry.ml} ml`;
      const note = entry.note ? `<span class="entry-note">${escapeHtml(entry.note)}</span>` : "";
      return `<div class="entry-list-row">
        <span>${fmtDate(toMesstag(entry.original))}</span>
        <span>${fmtTime(entry.original)}</span>
        <strong>${escapeHtml(t(entry.type === "Wasser" ? "water" : entry.type === "Hinweis" ? "note" : "urine"))}</strong>
        <span>${escapeHtml(label)}</span>
        ${note}
        <button class="utility-button quiet" type="button" data-action="edit" data-index="${index}">${escapeHtml(t("edit"))}</button>
        <button class="utility-button quiet" type="button" data-action="delete" data-index="${index}">${escapeHtml(t("delete"))}</button>
      </div>`;
    })
    .join("");
}

function fillEntryForm(index) {
  const entry = state.rows[index];
  if (!entry) return;
  els.entryEditIndex.value = String(index);
  els.entryDialogTitle.textContent = t("entry_edit");
  els.entryDate.value = inputDateValue(toMesstag(entry.original));
  els.entryUrineTime.value = inputTimeValue(entry.original);
  els.entryWaterTime.value = inputTimeValue(entry.original);
  els.entryUrineMl.value = entry.type === "Urin" ? String(entry.ml) : "";
  els.entryWaterMl.value = entry.type === "Wasser" ? String(entry.ml) : "";
  els.entryNote.value = entry.note || "";
  if (entry.type === "Hinweis") {
    els.entryUrineTime.value = inputTimeValue(entry.original);
    els.entryWaterTime.value = inputTimeValue(entry.original);
  }
}

function deleteEntry(index) {
  if (!state.rows[index]) return;
  const nextRows = state.rows.slice();
  nextRows.splice(index, 1);
  if (nextRows.length) {
    rebuildFromEntries(nextRows.sort((a, b) => a.original - b.original));
  } else {
    state.rows = [];
    state.days = [];
    state.rawCsv = "";
    render();
  }
  rememberCurrentData();
  resetEntryForm();
  els.status.textContent = `${state.days.length} ${t("measurement_days")} · ${t("entry_deleted")}`;
}

function confirmDeleteEntry(index) {
  const entry = state.rows[index];
  if (!entry) return;
  const label = entry.type === "Hinweis" ? t("note") : `${t(entry.type === "Wasser" ? "water" : "urine")} ${entry.ml} ml`;
  const message = t("entry_delete_confirm", { date: fmtDate(toMesstag(entry.original)), time: fmtTime(entry.original), label });
  if (window.confirm(message)) {
    deleteEntry(index);
  }
}

function confirmDeleteDay(dayKey) {
  const day = state.days.find((item) => item.key === dayKey);
  if (!day) return;
  if (!window.confirm(t("day_delete_confirm", { date: fmtDate(day.messtag) }))) return;

  const nextRows = state.rows.filter((entry) => localDayKey(toMesstag(entry.original)) !== dayKey);
  if (nextRows.length) {
    rebuildFromEntries(nextRows.sort((a, b) => a.original - b.original));
  } else {
    state.rows = [];
    state.days = [];
    state.rawCsv = "";
    render();
  }
  rememberCurrentData();
  els.status.textContent = `${state.days.length} ${t("measurement_days")} · ${t("day_deleted")}`;
}

els.themeSelect.addEventListener("change", (event) => {
  applyTheme(event.target.value);
});

els.themeMenuButton.addEventListener("click", (event) => {
  event.stopPropagation();
  setThemeMenuOpen(els.themeMenuPanel.hidden);
});

els.themeMenuOptions.addEventListener("click", (event) => {
  const button = event.target.closest("button[data-theme]");
  if (!button) return;
  applyTheme(button.dataset.theme);
  closeThemeMenu();
});

els.themeInput.addEventListener("change", (event) => {
  importThemeFile(event.target.files?.[0]);
  closeThemeMenu();
});

els.exportTheme.addEventListener("click", exportSelectedTheme);
els.deleteTheme.addEventListener("click", deleteSelectedTheme);

document.addEventListener("pointerdown", (event) => {
  if (els.themeMenu.contains(event.target)) return;
  closeThemeMenu();
});

document.addEventListener("keydown", (event) => {
  if (event.key === "Escape") closeThemeMenu();
});

els.languageSelect.addEventListener("change", (event) => {
  applyLanguage(event.target.value);
});

window.addEventListener("resize", () => render());

const savedTheme = localStorage.getItem("urinTheme");
const systemTheme = window.matchMedia?.("(prefers-color-scheme: dark)").matches ? "classic-dark" : "classic-light";
applyTheme(savedTheme || systemTheme);
applyLanguage(language);

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
    Monat: csvMonthNames[day.month - 1],
    KW: day.week,
    Messtag: `${String(day.messtag.getDate()).padStart(2, "0")}.${String(day.messtag.getMonth() + 1).padStart(2, "0")}.${day.messtag.getFullYear()}`,
    Tag: dayNames[day.messtag.getDay()],
    "Urin Uhrzeit": day.urine.map((item) => item.time).join(" | "),
    "Urin ml": day.urine.map((item) => item.ml).join(" | "),
    "Urin Hinweis": day.urine.map((item) => (day.noteRows || []).filter((note) => note.time === item.time).map((note) => note.note).join(" / ")).join(" | "),
    "Urin Anzahl": day.urineCount,
    "Urin gesamt ml": day.urineTotal,
    "Wasser Uhrzeit": day.water.map((item) => item.time).join(" | "),
    "Wasser ml": day.water.map((item) => item.ml).join(" | "),
    "Wasser gesamt ml": day.waterTotal,
    Hinweise: day.notesText,
    "Allgemeine Hinweise": (day.generalNotes || []).join(" | "),
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
