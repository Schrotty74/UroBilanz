const assert = require("node:assert/strict");
const { buildMedicalReportHTML, summary } = require("../assets/js/medical-report.js");

const days = [
  {
    dateLabel: "01.05.2026",
    complete: true,
    urineTotal: 820,
    waterTotal: 1200,
    assessment: "normal",
    entries: [
      { time: "07:00", type: "Urin", ml: 220, note: "Demo-Hinweis" },
      { time: "08:00", type: "Wasser", ml: 300, note: "" },
    ],
    generalNotes: ["Allgemeiner Demo-Hinweis"],
  },
  {
    dateLabel: "02.05.2026",
    complete: false,
    urineTotal: 300,
    waterTotal: 500,
    assessment: "unvollständig",
    entries: [{ time: "08:00", type: "Urin", ml: 300, note: "" }],
    generalNotes: [],
  },
];

assert.deepEqual(summary(days), {
  days: 2,
  evaluated: 1,
  incomplete: 1,
  low: 0,
  normal: 1,
  urineTotal: 820,
  urineAverage: 820,
  waterTotal: 1200,
});

const html = buildMedicalReportHTML({
  language: "de",
  days,
  includeDetails: true,
  includeNotes: true,
  logoUrl: "assets/urobilanz-app-icon.png",
  periodLabel: "01.05.2026 bis 02.05.2026",
  createdLabel: "13.06.2026",
});

assert.match(html, /Arztbericht/);
assert.match(html, /UroBilanz/);
assert.match(html, /Demo-Hinweis/);
assert.match(html, /Allgemeiner Demo-Hinweis/);
assert.match(html, /@page \{ size: A4/);
assert.match(html, /Dieser Bericht enthält keine medizinische Empfehlung/);
assert.doesNotMatch(html, /--accent|data-theme|localStorage/);

const withoutDetails = buildMedicalReportHTML({
  language: "en",
  days,
  includeDetails: false,
  includeNotes: false,
  logoUrl: "assets/urobilanz-app-icon.png",
  periodLabel: "05/01/2026 to 05/02/2026",
  createdLabel: "06/13/2026",
});
assert.match(withoutDetails, /Medical appointment report/);
assert.doesNotMatch(withoutDetails, /Demo-Hinweis/);
assert.doesNotMatch(withoutDetails, /Daily details/);

console.log("Web medical report smoke test passed");
