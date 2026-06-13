(function (root) {
  function escapeHtml(value) {
    return String(value ?? "")
      .replaceAll("&", "&amp;")
      .replaceAll("<", "&lt;")
      .replaceAll(">", "&gt;")
      .replaceAll('"', "&quot;");
  }

  function number(value, locale) {
    return Number(value || 0).toLocaleString(locale);
  }

  function reportStrings(language) {
    if (language === "en") {
      return {
        title: "Medical appointment report",
        period: "Selected period",
        created: "Created",
        print: "Print / Save PDF",
        close: "Close",
        summary: "Summary",
        days: "Measurement days",
        evaluated: "Evaluated days",
        incomplete: "Incomplete days",
        low: "Low days",
        normal: "Normal days",
        urineTotal: "Urine total",
        urineAverage: "Urine average per evaluated day",
        waterTotal: "Water total",
        course: "Daily totals",
        overview: "Daily overview",
        details: "Daily details",
        rules: "Evaluation rules",
        date: "Date",
        urine: "Urine",
        water: "Water",
        evaluation: "Evaluation",
        time: "Time",
        type: "Type",
        amount: "Amount",
        note: "Note",
        generalNotes: "General notes",
        noNotes: "No notes",
        ruleText: "A measurement day runs from 06:00 to 05:59. Only complete days with at least eight hours between the first and last urine or water entry are included in totals, averages and low/normal evaluation. Complete days below 700 ml urine are marked low; all other complete days are marked normal. This organizational evaluation is not a medical diagnosis.",
        privacy: "Created locally with UroBilanz. This report does not provide medical advice.",
      };
    }
    return {
      title: "Arztbericht",
      period: "Gewählter Zeitraum",
      created: "Erstellt",
      print: "Drucken / Als PDF sichern",
      close: "Schließen",
      summary: "Zusammenfassung",
      days: "Messtage",
      evaluated: "Ausgewertete Tage",
      incomplete: "Unvollständige Tage",
      low: "Niedrige Tage",
      normal: "Normale Tage",
      urineTotal: "Urin gesamt",
      urineAverage: "Urin-Durchschnitt je ausgewertetem Tag",
      waterTotal: "Wasser gesamt",
      course: "Tagesverlauf",
      overview: "Tagesübersicht",
      details: "Tagesdetails",
      rules: "Bewertungsregeln",
      date: "Datum",
      urine: "Urin",
      water: "Wasser",
      evaluation: "Bewertung",
      time: "Uhrzeit",
      type: "Typ",
      amount: "Menge",
      note: "Hinweis",
      generalNotes: "Allgemeine Hinweise",
      noNotes: "Keine Hinweise",
      ruleText: "Ein Messtag läuft von 06:00 bis 05:59. Nur vollständige Tage mit mindestens acht Stunden zwischen erstem und letztem Urin- oder Wasserwert werden in Summen, Durchschnitt und niedrig/normal-Bewertung einbezogen. Vollständige Tage unter 700 ml Urin gelten als niedrig, alle anderen vollständigen Tage als normal. Diese organisatorische Bewertung ist keine medizinische Diagnose.",
      privacy: "Lokal mit UroBilanz erstellt. Dieser Bericht enthält keine medizinische Empfehlung.",
    };
  }

  function summary(days) {
    const evaluated = days.filter((day) => day.complete);
    const low = evaluated.filter((day) => day.urineTotal < 700);
    return {
      days: days.length,
      evaluated: evaluated.length,
      incomplete: days.length - evaluated.length,
      low: low.length,
      normal: evaluated.length - low.length,
      urineTotal: evaluated.reduce((sum, day) => sum + day.urineTotal, 0),
      urineAverage: evaluated.length
        ? Math.round(evaluated.reduce((sum, day) => sum + day.urineTotal, 0) / evaluated.length)
        : 0,
      waterTotal: evaluated.reduce((sum, day) => sum + day.waterTotal, 0),
    };
  }

  function statusClass(day) {
    if (!day.complete) return "incomplete";
    return day.urineTotal < 700 ? "low" : "normal";
  }

  function chartRows(days, strings, locale) {
    const max = Math.max(1, ...days.flatMap((day) => [day.urineTotal, day.waterTotal]));
    return days.map((day) => `
      <div class="chart-row">
        <div class="chart-date">${escapeHtml(day.dateLabel)}</div>
        <div class="chart-bars">
          <div class="bar-line"><span>${escapeHtml(strings.urine)}</span><i class="urine-bar" style="width:${Math.max(1, day.urineTotal / max * 100)}%"></i><b>${number(day.urineTotal, locale)} ml</b></div>
          <div class="bar-line"><span>${escapeHtml(strings.water)}</span><i class="water-bar" style="width:${Math.max(1, day.waterTotal / max * 100)}%"></i><b>${number(day.waterTotal, locale)} ml</b></div>
        </div>
      </div>
    `).join("");
  }

  function overviewRows(days, locale) {
    return days.map((day) => `
      <tr class="${statusClass(day)}">
        <td>${escapeHtml(day.dateLabel)}</td>
        <td>${number(day.urineTotal, locale)} ml</td>
        <td>${number(day.waterTotal, locale)} ml</td>
        <td>${escapeHtml(day.assessment)}</td>
      </tr>
    `).join("");
  }

  function detailSections(days, strings, locale, includeNotes) {
    return days.map((day) => {
      const entries = day.entries.map((entry) => `
        <tr>
          <td>${escapeHtml(entry.time)}</td>
          <td>${escapeHtml(entry.type)}</td>
          <td>${entry.ml ? `${number(entry.ml, locale)} ml` : ""}</td>
          ${includeNotes ? `<td>${escapeHtml(entry.note || "")}</td>` : ""}
        </tr>
      `).join("");
      const notes = includeNotes && day.generalNotes.length
        ? `<div class="general-notes"><strong>${escapeHtml(strings.generalNotes)}:</strong> ${day.generalNotes.map(escapeHtml).join(" · ")}</div>`
        : "";
      return `
        <section class="day-detail">
          <h3>${escapeHtml(day.dateLabel)} <span class="status ${statusClass(day)}">${escapeHtml(day.assessment)}</span></h3>
          <table>
            <thead><tr><th>${escapeHtml(strings.time)}</th><th>${escapeHtml(strings.type)}</th><th>${escapeHtml(strings.amount)}</th>${includeNotes ? `<th>${escapeHtml(strings.note)}</th>` : ""}</tr></thead>
            <tbody>${entries}</tbody>
          </table>
          ${notes}
        </section>
      `;
    }).join("");
  }

  function buildMedicalReportHTML(options) {
    const language = options.language === "en" ? "en" : "de";
    const strings = reportStrings(language);
    const locale = language === "en" ? "en-US" : "de-DE";
    const days = options.days || [];
    const totals = summary(days);
    const metric = (label, value) => `<div class="metric"><span>${escapeHtml(label)}</span><strong>${escapeHtml(value)}</strong></div>`;
    const details = options.includeDetails
      ? `<section><h2>${escapeHtml(strings.details)}</h2>${detailSections(days, strings, locale, options.includeNotes)}</section>`
      : "";

    return `<!doctype html>
<html lang="${language}">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>UroBilanz - ${escapeHtml(strings.title)}</title>
<style>
  @page { size: A4; margin: 16mm 14mm 17mm; }
  * { box-sizing: border-box; }
  body { margin: 0; color: #172024; background: #fff; font-family: -apple-system, BlinkMacSystemFont, "Helvetica Neue", Arial, sans-serif; font-size: 10.5pt; line-height: 1.38; }
  .actions { position: sticky; top: 0; display: flex; justify-content: flex-end; gap: 8px; padding: 10px 14px; background: #edf2f4; border-bottom: 1px solid #ccd6da; }
  button { border: 1px solid #91a0a7; border-radius: 6px; background: #fff; color: #172024; padding: 8px 12px; font: inherit; font-weight: 700; cursor: pointer; }
  main { max-width: 190mm; margin: 0 auto; padding: 14mm 10mm 18mm; }
  .cover { display: flex; align-items: center; gap: 14px; padding-bottom: 15px; border-bottom: 2px solid #51758b; }
  .cover img { width: 58px; height: 58px; border-radius: 13px; }
  .brand { margin: 0; color: #173c51; font-size: 13pt; font-weight: 800; }
  h1 { margin: 2px 0 5px; font-size: 22pt; }
  .meta { margin: 0; color: #52636c; }
  section { margin-top: 20px; break-inside: auto; }
  h2 { margin: 0 0 9px; padding-bottom: 5px; border-bottom: 1px solid #aebcc2; color: #173c51; font-size: 14pt; }
  h3 { margin: 0 0 7px; font-size: 11.5pt; }
  .metrics { display: grid; grid-template-columns: repeat(4, 1fr); gap: 7px; }
  .metric { padding: 8px; border: 1px solid #c7d1d5; background: #f5f7f8; }
  .metric span { display: block; min-height: 28px; color: #52636c; font-size: 8.5pt; }
  .metric strong { font-size: 12pt; }
  .chart { display: grid; gap: 5px; }
  .chart-row { display: grid; grid-template-columns: 26mm 1fr; gap: 8px; break-inside: avoid; }
  .chart-date { padding-top: 2px; font-weight: 700; }
  .chart-bars { display: grid; gap: 2px; }
  .bar-line { display: grid; grid-template-columns: 14mm minmax(10mm, 1fr) 22mm; align-items: center; gap: 5px; font-size: 8pt; }
  .bar-line i { display: block; height: 5px; min-width: 1px; }
  .bar-line b { text-align: right; font-weight: 650; }
  .urine-bar { background: #d79a22; }
  .water-bar { background: #558ca9; }
  table { width: 100%; border-collapse: collapse; font-size: 9pt; }
  th { background: #e8eef1; color: #273c47; text-align: left; }
  th, td { padding: 5px 6px; border: 1px solid #bdc9ce; vertical-align: top; }
  tr.low td { background: #fff3d8; }
  tr.incomplete td { color: #58666d; background: #f0f1f1; }
  .day-detail { margin-top: 13px; break-inside: avoid; }
  .status { display: inline-block; margin-left: 6px; padding: 2px 6px; border-radius: 3px; color: #35464e; background: #e8eef1; font-size: 8pt; font-weight: 700; }
  .status.low { background: #ffe5ad; }
  .status.incomplete { background: #e2e4e5; }
  .general-notes { margin-top: 5px; padding: 6px 7px; border-left: 3px solid #8ba2ad; background: #f5f7f8; }
  .rules { padding: 9px 10px; border: 1px solid #c7d1d5; background: #f7f8f8; }
  footer { margin-top: 22px; padding-top: 7px; border-top: 1px solid #c7d1d5; color: #65757d; font-size: 8pt; }
  @media print {
    .actions { display: none; }
    main { max-width: none; padding: 0; }
  }
</style>
</head>
<body>
<div class="actions"><button onclick="window.close()">${escapeHtml(strings.close)}</button><button onclick="window.print()">${escapeHtml(strings.print)}</button></div>
<main>
  <header class="cover">
    <img src="${escapeHtml(options.logoUrl)}" alt="">
    <div>
      <p class="brand">UroBilanz</p>
      <h1>${escapeHtml(strings.title)}</h1>
      <p class="meta">${escapeHtml(strings.period)}: ${escapeHtml(options.periodLabel)}<br>${escapeHtml(strings.created)}: ${escapeHtml(options.createdLabel)}</p>
    </div>
  </header>
  <section>
    <h2>${escapeHtml(strings.summary)}</h2>
    <div class="metrics">
      ${metric(strings.days, number(totals.days, locale))}
      ${metric(strings.evaluated, number(totals.evaluated, locale))}
      ${metric(strings.incomplete, number(totals.incomplete, locale))}
      ${metric(strings.low, number(totals.low, locale))}
      ${metric(strings.normal, number(totals.normal, locale))}
      ${metric(strings.urineTotal, `${number(totals.urineTotal, locale)} ml`)}
      ${metric(strings.urineAverage, `${number(totals.urineAverage, locale)} ml`)}
      ${metric(strings.waterTotal, `${number(totals.waterTotal, locale)} ml`)}
    </div>
  </section>
  <section>
    <h2>${escapeHtml(strings.course)}</h2>
    <div class="chart">${chartRows(days, strings, locale)}</div>
  </section>
  <section>
    <h2>${escapeHtml(strings.overview)}</h2>
    <table><thead><tr><th>${escapeHtml(strings.date)}</th><th>${escapeHtml(strings.urine)}</th><th>${escapeHtml(strings.water)}</th><th>${escapeHtml(strings.evaluation)}</th></tr></thead><tbody>${overviewRows(days, locale)}</tbody></table>
  </section>
  ${details}
  <section>
    <h2>${escapeHtml(strings.rules)}</h2>
    <div class="rules">${escapeHtml(strings.ruleText)}</div>
  </section>
  <footer>${escapeHtml(strings.privacy)}</footer>
</main>
</body>
</html>`;
  }

  const api = { buildMedicalReportHTML, reportStrings, summary };
  root.UroMedicalReport = api;
  if (typeof module !== "undefined" && module.exports) module.exports = api;
})(typeof window !== "undefined" ? window : globalThis);
