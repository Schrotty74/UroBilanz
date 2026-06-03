(function (root) {
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

  function inputDateValue(date) {
    return `${date.getFullYear()}-${String(date.getMonth() + 1).padStart(2, "0")}-${String(date.getDate()).padStart(2, "0")}`;
  }

  function inputTimeValue(date) {
    return `${String(date.getHours()).padStart(2, "0")}:${String(date.getMinutes()).padStart(2, "0")}`;
  }

  function escapeHtml(value) {
    return String(value).replaceAll("&", "&amp;").replaceAll("<", "&lt;").replaceAll(">", "&gt;");
  }

  const api = {
    detectDelimiter,
    normalizeHeader,
    parseCsv,
    parseDate,
    parseDayDate,
    toMesstag,
    isoWeek,
    inputDateValue,
    inputTimeValue,
    escapeHtml,
  };

  root.UroCore = api;
  if (typeof module !== "undefined" && module.exports) module.exports = api;
})(typeof window !== "undefined" ? window : globalThis);
