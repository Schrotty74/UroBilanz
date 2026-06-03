const assert = require("node:assert/strict");
const {
  detectDelimiter,
  escapeHtml,
  isoWeek,
  parseCsv,
  parseDate,
  parseDayDate,
  toMesstag,
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

console.log("Web core smoke test passed");
