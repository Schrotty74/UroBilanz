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
assert.throws(() => validateUroTheme({ ...validTheme, id: "classic-light" }, ["classic-light"]), /ueberschrieben/);
assert.throws(() => validateUroTheme({ ...validTheme, colors: { ...validTheme.colors, accent: "gold" } }), /accent/);
assert.throws(() => validateUroTheme({ ...validTheme, version: 2 }), /Version/);

console.log("Web core smoke test passed");
