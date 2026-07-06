const assert = require("node:assert/strict");
const {
  detectDelimiter,
  escapeHtml,
  isoWeek,
  parseCsv,
  parseDate,
  parseDayDate,
  toMesstag,
  validateUroTheme,
} = require("../assets/js/core.js");
const {
  applyCustomThemeVariables,
  builtInThemeCopy,
  builtInThemeIds,
  customThemeTitle,
  loadCustomThemes,
  saveCustomThemes,
} = require("../assets/js/themes.js");

assert.equal(detectDelimiter("Datum;Typ;ml\n"), ";");
assert.equal(detectDelimiter("Datum,Typ,ml\n"), ",");

const csvRows = parseCsv('Datum,Typ,ml,Hinweis\n"2.6.2026 05:30",Urin,250,"Text, mit Komma"\n');
assert.deepEqual(csvRows, [{ Datum: "2.6.2026 05:30", Typ: "Urin", ml: "250", Hinweis: "Text, mit Komma" }]);

const earlyEntry = parseDate("2.6.2026 05:30");
assert.ok(earlyEntry);
assert.equal(toMesstag(earlyEntry).getDate(), 1);
assert.equal(toMesstag(earlyEntry).getMonth(), 5);

const daytimeEntry = parseDate("2.6.2026 06:00");
assert.ok(daytimeEntry);
assert.equal(toMesstag(daytimeEntry).getDate(), 2);

const day = parseDayDate("02.06.2026");
assert.ok(day);
assert.deepEqual(isoWeek(day), { year: 2026, week: 23 });
assert.equal(escapeHtml("<Hinweis & Wert>"), "&lt;Hinweis &amp; Wert&gt;");

const validTheme = validateUroTheme({
  format: "urobilanz-theme",
  version: 1,
  id: "harbor-night",
  name: { de: "Hafen Nacht", en: "Harbor Night" },
  mode: "dark",
  colors: {
    text: "#F4F7F8",
    background: "#0D1518",
    panel: "#17242A",
    accent: "#E9B949",
    urine: "#F6C85F",
    water: "#47B8E8",
  },
  effects: { glassOpacity: 0.74 },
}, ["classic-light"]);
assert.equal(validTheme.id, "harbor-night");
assert.equal(validTheme.name.en, "Harbor Night");
assert.deepEqual(validateUroTheme(JSON.parse(JSON.stringify(validTheme))).colors, validTheme.colors);
assert.throws(() => validateUroTheme({ ...validTheme, id: "classic-light" }, ["classic-light"]), /ueberschrieben/);
assert.throws(() => validateUroTheme({ ...validTheme, colors: { ...validTheme.colors, accent: "gold" } }), /accent/);
assert.throws(() => validateUroTheme({ ...validTheme, version: 2 }), /Version/);

const storedValues = new Map();
const storage = {
  getItem: (key) => storedValues.get(key) ?? null,
  setItem: (key, value) => storedValues.set(key, value),
  removeItem: (key) => storedValues.delete(key),
};
saveCustomThemes(storage, [validTheme]);
assert.equal(loadCustomThemes(storage, validateUroTheme)[0].id, "harbor-night");
assert.equal(customThemeTitle(validTheme, "de"), "Hafen Nacht");
assert.equal(customThemeTitle({ ...validTheme, name: { en: "Only English" } }, "de"), "Only English");

const properties = new Map();
const styleTarget = {
  style: {
    setProperty: (name, value) => properties.set(name, value),
    removeProperty: (name) => properties.delete(name),
  },
};
applyCustomThemeVariables(styleTarget, validTheme);
assert.equal(properties.get("--accent"), "#E9B949");
assert.equal(properties.get("--body-bg"), "#0D1518");

const cssValues = new Map([
  ["--ink", "#FFFFFF"],
  ["--body-bg", "#0E171A"],
  ["--paper", "#142024"],
  ["--accent", "#A8C957"],
  ["--urine-strong", "#F6C84F"],
  ["--water-strong", "#4AA3FF"],
]);
const copiedTheme = builtInThemeCopy({
  id: "classic-dark",
  existingIds: ["classic-dark-custom"],
  styles: { getPropertyValue: (name) => cssValues.get(name) || "" },
  translations: {
    de: { themes: { "classic-dark": "Classic Dunkel" } },
    en: { themes: { "classic-dark": "Classic Dark" } },
  },
  validateTheme: validateUroTheme,
});
assert.equal(copiedTheme.id, "classic-dark-custom-2");
assert.equal(copiedTheme.mode, "dark");
assert.ok(builtInThemeIds.includes("classic-dark"));

storage.setItem("uroCustomThemes", JSON.stringify([{ ...validTheme, colors: { ...validTheme.colors, water: "blue" } }]));
assert.deepEqual(loadCustomThemes(storage, validateUroTheme), []);
assert.equal(storage.getItem("uroCustomThemes"), null);

console.log("Web core smoke test passed");
