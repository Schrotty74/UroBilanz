(function (root) {
  const APP_VERSION = "1.6.0-rc.2";

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

  const requiredThemeColors = ["text", "background", "panel", "accent", "urine", "water"];
  const optionalThemeColors = [
    "mutedText",
    "backgroundAlt",
    "panelSoft",
    "border",
    "accentText",
    "urineSoft",
    "waterSoft",
    "low",
    "rowOdd",
    "rowEven",
    "chartUrine",
    "chartWater",
  ];
  const themeEffects = ["glassOpacity", "glassBorderOpacity", "shadowOpacity"];

  function normalizeThemeName(name) {
    if (typeof name === "string" && name.trim()) {
      return { de: name.trim(), en: name.trim() };
    }
    if (name && typeof name === "object") {
      const de = String(name.de || name.en || "").trim();
      const en = String(name.en || name.de || "").trim();
      if (de || en) return { de: de || en, en: en || de };
    }
    return null;
  }

  function validateUroTheme(theme, builtInIds = []) {
    if (!theme || typeof theme !== "object" || Array.isArray(theme)) {
      throw new Error("Theme-Datei ist kein gueltiges Objekt.");
    }
    if (theme.format !== "urobilanz-theme") {
      throw new Error("Theme-Format wird nicht erkannt.");
    }
    if (theme.version !== 1) {
      throw new Error("Theme-Version wird nicht unterstuetzt.");
    }
    const id = String(theme.id || "").trim();
    if (!/^[a-z0-9][a-z0-9-]*$/.test(id)) {
      throw new Error("Theme-ID darf nur Kleinbuchstaben, Zahlen und Bindestriche enthalten.");
    }
    if (builtInIds.includes(id)) {
      throw new Error("Eingebaute Themes duerfen nicht ueberschrieben werden.");
    }
    const name = normalizeThemeName(theme.name);
    if (!name) {
      throw new Error("Theme-Name fehlt.");
    }
    if (!["light", "dark"].includes(theme.mode)) {
      throw new Error("Theme-Modus muss light oder dark sein.");
    }
    const colors = {};
    const sourceColors = theme.colors || {};
    for (const key of requiredThemeColors) {
      if (!/^#[0-9a-fA-F]{6}$/.test(String(sourceColors[key] || ""))) {
        throw new Error(`Theme-Farbe ${key} fehlt oder ist ungueltig.`);
      }
      colors[key] = String(sourceColors[key]).toUpperCase();
    }
    for (const key of optionalThemeColors) {
      if (sourceColors[key] == null || sourceColors[key] === "") continue;
      if (!/^#[0-9a-fA-F]{6}$/.test(String(sourceColors[key]))) {
        throw new Error(`Theme-Farbe ${key} ist ungueltig.`);
      }
      colors[key] = String(sourceColors[key]).toUpperCase();
    }
    const effects = {};
    for (const key of themeEffects) {
      if (theme.effects?.[key] == null || theme.effects[key] === "") continue;
      const value = Number(theme.effects[key]);
      if (!Number.isFinite(value) || value < 0 || value > 1) {
        throw new Error(`Theme-Effekt ${key} muss zwischen 0 und 1 liegen.`);
      }
      effects[key] = value;
    }
    return { format: "urobilanz-theme", version: 1, id, name, mode: theme.mode, colors, effects };
  }

  const api = {
    APP_VERSION,
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
    validateUroTheme,
  };

  root.UroCore = api;
  if (typeof module !== "undefined" && module.exports) module.exports = api;
})(typeof window !== "undefined" ? window : globalThis);
