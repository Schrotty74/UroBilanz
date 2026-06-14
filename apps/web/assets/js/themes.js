(function (root) {
  const builtInThemeIds = [
    "classic-light",
    "classic-dark",
    "violet-night",
    "liquid-dark",
    "medical-light",
    "high-contrast",
    "summer",
    "cream-sage",
  ];
  const builtInThemeSet = new Set(builtInThemeIds);
  const darkThemeSet = new Set(["classic-dark", "violet-night", "liquid-dark", "high-contrast"]);
  const customThemeStorageKey = "uroCustomThemes";
  const customProperties = [
    "--ink", "--muted", "--line", "--teal", "--teal-dark", "--accent", "--accent-ink",
    "--urine", "--urine-strong", "--water", "--water-strong", "--soft", "--paper",
    "--panel", "--panel-soft", "--glass-bg", "--glass-line", "--glass-shadow",
    "--chart-urine", "--chart-water", "--low", "--body-bg", "--row-odd", "--row-even",
  ];

  function loadCustomThemes(storage, validateTheme) {
    try {
      const parsed = JSON.parse(storage.getItem(customThemeStorageKey) || "[]");
      if (!Array.isArray(parsed)) return [];
      return parsed.map((theme) => validateTheme(theme, builtInThemeIds));
    } catch {
      storage.removeItem(customThemeStorageKey);
      return [];
    }
  }

  function saveCustomThemes(storage, themes) {
    storage.setItem(customThemeStorageKey, JSON.stringify(themes));
  }

  function customThemeTitle(theme, language) {
    return theme.name?.[language] || theme.name?.de || theme.name?.en || theme.id;
  }

  function customThemeById(themes, id) {
    return themes.find((theme) => theme.id === id);
  }

  function sortedThemes(themes, language) {
    return [...themes].sort((a, b) => customThemeTitle(a, language).localeCompare(customThemeTitle(b, language)));
  }

  function uniqueCustomThemeId(baseId, existingIds) {
    const used = new Set(existingIds);
    let id = baseId;
    let index = 2;
    while (builtInThemeSet.has(id) || used.has(id)) {
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

  function builtInThemeCopy(options) {
    const { id, existingIds, styles, translations, validateTheme } = options;
    const isDark = darkThemeSet.has(id);
    const titleDe = translations?.de?.themes?.[id] ?? id;
    const titleEn = translations?.en?.themes?.[id] ?? titleDe;
    return validateTheme({
      format: "urobilanz-theme",
      version: 1,
      id: uniqueCustomThemeId(`${id}-custom`, existingIds),
      name: {
        de: `${titleDe} Kopie`,
        en: `${titleEn} Copy`,
      },
      mode: isDark ? "dark" : "light",
      colors: {
        text: themeColor(styles, "--ink", isDark ? "#FFFFFF" : "#172024"),
        mutedText: themeColor(styles, "--muted", isDark ? "#C9D4D2" : "#64706E"),
        background: themeColor(styles, "--body-bg", isDark ? "#0E171A" : "#F6FBFA"),
        backgroundAlt: themeColor(styles, "--soft", isDark ? "#172326" : "#E8F3F1"),
        panel: themeColor(styles, "--paper", isDark ? "#142024" : "#FFFFFF"),
        panelSoft: themeColor(styles, "--panel-soft", isDark ? "#1B292C" : "#F2F8F6"),
        border: themeColor(styles, "--line", isDark ? "#4E6B66" : "#C8D8D5"),
        accent: themeColor(styles, "--accent", "#A8C957"),
        accentText: themeColor(styles, "--accent-ink", isDark ? "#101614" : "#FFFFFF"),
        urine: themeColor(styles, "--urine-strong", "#F6C84F"),
        urineSoft: themeColor(styles, "--urine", "#F7E3A4"),
        water: themeColor(styles, "--water-strong", "#2D91E8"),
        waterSoft: themeColor(styles, "--water", "#B9DBF8"),
        low: themeColor(styles, "--low", isDark ? "#5C252B" : "#F8D7DA"),
        rowOdd: themeColor(styles, "--row-odd", isDark ? "#192529" : "#F4FAF8"),
        rowEven: themeColor(styles, "--row-even", isDark ? "#101A1D" : "#FFFFFF"),
        chartUrine: themeColor(styles, "--chart-urine", "#F6C84F"),
        chartWater: themeColor(styles, "--chart-water", "#2D91E8"),
      },
      effects: {
        glassOpacity: 0.86,
        glassBorderOpacity: 0.3,
        shadowOpacity: isDark ? 0.28 : 0.16,
      },
    }, builtInThemeIds);
  }

  function hexToRgb(hex) {
    const value = hex.replace("#", "");
    return [0, 2, 4].map((start) => parseInt(value.slice(start, start + 2), 16));
  }

  function rgba(hex, opacity) {
    const [r, g, b] = hexToRgb(hex);
    return `rgba(${r}, ${g}, ${b}, ${opacity})`;
  }

  function clearCustomThemeVariables(element) {
    customProperties.forEach((name) => element.style.removeProperty(name));
  }

  function applyCustomThemeVariables(element, theme) {
    const c = theme.colors;
    const e = theme.effects || {};
    const set = (name, value) => element.style.setProperty(name, value);
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

  const api = {
    applyCustomThemeVariables,
    builtInThemeCopy,
    builtInThemeIds,
    builtInThemeSet,
    clearCustomThemeVariables,
    customThemeById,
    customThemeTitle,
    darkThemeSet,
    loadCustomThemes,
    saveCustomThemes,
    sortedThemes,
    themeFileName: (theme) => `urobilanz-theme-${theme.id}.json`,
  };
  root.UroThemes = api;
  if (typeof module !== "undefined" && module.exports) module.exports = api;
})(typeof window !== "undefined" ? window : globalThis);
