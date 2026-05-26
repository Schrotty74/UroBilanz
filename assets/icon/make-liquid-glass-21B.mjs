import { mkdirSync, writeFileSync } from "node:fs";
import { join } from "node:path";

const outDir = new URL("./liquid-glass-21B/", import.meta.url).pathname;

const modes = {
  light: {
    bgA: "#e7fbfc",
    bgB: "#ffffff",
    panel: "rgba(255,255,255,.66)",
    panelStroke: "rgba(10,64,70,.24)",
    cupStroke: "#10363b",
    markStroke: "#10363b",
    urineA: "#ffe394",
    urineB: "#f6b910",
    urineC: "#fff4b8",
    waterA: "#91d9ff",
    waterB: "#168ee8",
    waterC: "#c9f0ff",
    shadow: ".22",
    shine: ".36",
  },
  dark: {
    bgA: "#08191c",
    bgB: "#10363a",
    panel: "rgba(255,255,255,.15)",
    panelStroke: "rgba(190,245,255,.30)",
    cupStroke: "#d6fbff",
    markStroke: "#d6fbff",
    urineA: "#ffe9a7",
    urineB: "#ffc21a",
    urineC: "#fff2b2",
    waterA: "#8edbff",
    waterB: "#1599ff",
    waterC: "#c7f3ff",
    shadow: ".42",
    shine: ".42",
  },
};

function svg(body, defs = "") {
  return `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1024 1024">
  <defs>${defs}</defs>
  ${body}
</svg>
`;
}

function defs(mode, key) {
  return `
    <linearGradient id="bg-${key}" x1="0" y1="0" x2="1" y2="1">
      <stop offset="0" stop-color="${mode.bgA}"/>
      <stop offset="1" stop-color="${mode.bgB}"/>
    </linearGradient>
    <linearGradient id="urine-${key}" x1="0" y1="0" x2="1" y2="1">
      <stop offset="0" stop-color="${mode.urineA}"/>
      <stop offset=".58" stop-color="${mode.urineB}"/>
      <stop offset="1" stop-color="${mode.urineC}"/>
    </linearGradient>
    <linearGradient id="water-${key}" x1="0" y1="0" x2="1" y2="1">
      <stop offset="0" stop-color="${mode.waterA}"/>
      <stop offset=".55" stop-color="${mode.waterB}"/>
      <stop offset="1" stop-color="${mode.waterC}"/>
    </linearGradient>
    <radialGradient id="glassGlow-${key}" cx=".28" cy=".20" r=".78">
      <stop offset="0" stop-color="#ffffff" stop-opacity=".58"/>
      <stop offset=".46" stop-color="#ffffff" stop-opacity=".10"/>
      <stop offset="1" stop-color="#ffffff" stop-opacity="0"/>
    </radialGradient>
    <filter id="softShadow-${key}" x="-30%" y="-30%" width="160%" height="160%">
      <feDropShadow dx="0" dy="18" stdDeviation="18" flood-color="#000" flood-opacity="${mode.shadow}"/>
    </filter>
    <filter id="blur-${key}" x="-30%" y="-30%" width="160%" height="160%">
      <feGaussianBlur stdDeviation="12"/>
    </filter>
  `;
}

const pieces = {
  background: (m, key) => svg(`
    <rect x="58" y="58" width="908" height="908" rx="220" fill="url(#bg-${key})"/>
    <circle cx="280" cy="235" r="205" fill="#fff" opacity=".15" filter="url(#blur-${key})"/>
    <circle cx="744" cy="752" r="230" fill="#fff" opacity=".08" filter="url(#blur-${key})"/>
  `, defs(m, key)),
  glassPanel: (m, key) => svg(`
    <rect x="94" y="94" width="836" height="836" rx="198" fill="${m.panel}" stroke="${m.panelStroke}" stroke-width="10" filter="url(#softShadow-${key})"/>
    <rect x="112" y="112" width="800" height="800" rx="180" fill="url(#glassGlow-${key})"/>
  `, defs(m, key)),
  liquid: (m, key) => svg(`
    <path d="M350 510 C462 432 555 570 680 490 L642 740 H385 Z" fill="url(#urine-${key})" opacity=".90"/>
    <path d="M350 398 C462 322 560 458 692 384 L680 490 C555 570 462 432 350 510 Z" fill="url(#water-${key})" opacity=".82"/>
    <path d="M366 395 C472 338 553 458 674 396" fill="none" stroke="#ffffff" stroke-width="9" stroke-linecap="round" opacity=".22"/>
  `, defs(m, key)),
  cup: (m) => svg(`
    <path d="M300 225 H730 L668 770 H362 Z" fill="rgba(255,255,255,.24)" stroke="${m.cupStroke}" stroke-width="31" opacity=".82" stroke-linejoin="round"/>
    <path d="M336 325 H392" stroke="${m.markStroke}" stroke-width="17" stroke-linecap="round" opacity=".36"/>
    <path d="M336 418 H392" stroke="${m.markStroke}" stroke-width="17" stroke-linecap="round" opacity=".36"/>
    <path d="M336 511 H392" stroke="${m.markStroke}" stroke-width="17" stroke-linecap="round" opacity=".36"/>
    <path d="M336 604 H392" stroke="${m.markStroke}" stroke-width="17" stroke-linecap="round" opacity=".36"/>
  `),
  plus: (m) => svg(`
    <path d="M512 300 V500 M412 400 H612" stroke="${m.cupStroke}" stroke-width="56" stroke-linecap="round" opacity=".72"/>
  `),
  highlights: (m) => svg(`
    <path d="M170 178 C340 94 660 88 850 220" fill="none" stroke="#fff" stroke-width="18" stroke-linecap="round" opacity="${m.shine}"/>
    <path d="M380 280 C466 238 570 250 652 304" fill="none" stroke="#fff" stroke-width="16" stroke-linecap="round" opacity="${m.shine}"/>
    <path d="M245 800 C380 884 626 890 784 786" fill="none" stroke="#fff" stroke-width="12" stroke-linecap="round" opacity=".13"/>
  `),
};

function composite(mode, key) {
  return svg(`
    <rect x="58" y="58" width="908" height="908" rx="220" fill="url(#bg-${key})"/>
    <circle cx="280" cy="235" r="205" fill="#fff" opacity=".15" filter="url(#blur-${key})"/>
    <circle cx="744" cy="752" r="230" fill="#fff" opacity=".08" filter="url(#blur-${key})"/>
    <rect x="94" y="94" width="836" height="836" rx="198" fill="${mode.panel}" stroke="${mode.panelStroke}" stroke-width="10" filter="url(#softShadow-${key})"/>
    <rect x="112" y="112" width="800" height="800" rx="180" fill="url(#glassGlow-${key})"/>
    <path d="M300 225 H730 L668 770 H362 Z" fill="rgba(255,255,255,.24)" stroke="${mode.cupStroke}" stroke-width="31" opacity=".82" stroke-linejoin="round"/>
    <path d="M350 510 C462 432 555 570 680 490 L642 740 H385 Z" fill="url(#urine-${key})" opacity=".90"/>
    <path d="M350 398 C462 322 560 458 692 384 L680 490 C555 570 462 432 350 510 Z" fill="url(#water-${key})" opacity=".82"/>
    <path d="M366 395 C472 338 553 458 674 396" fill="none" stroke="#ffffff" stroke-width="9" stroke-linecap="round" opacity=".22"/>
    <path d="M336 325 H392" stroke="${mode.markStroke}" stroke-width="17" stroke-linecap="round" opacity=".36"/>
    <path d="M336 418 H392" stroke="${mode.markStroke}" stroke-width="17" stroke-linecap="round" opacity=".36"/>
    <path d="M336 511 H392" stroke="${mode.markStroke}" stroke-width="17" stroke-linecap="round" opacity=".36"/>
    <path d="M336 604 H392" stroke="${mode.markStroke}" stroke-width="17" stroke-linecap="round" opacity=".36"/>
    <path d="M512 300 V500 M412 400 H612" stroke="${mode.cupStroke}" stroke-width="56" stroke-linecap="round" opacity=".72"/>
    <path d="M170 178 C340 94 660 88 850 220" fill="none" stroke="#fff" stroke-width="18" stroke-linecap="round" opacity="${mode.shine}"/>
    <path d="M380 280 C466 238 570 250 652 304" fill="none" stroke="#fff" stroke-width="16" stroke-linecap="round" opacity="${mode.shine}"/>
    <path d="M245 800 C380 884 626 890 784 786" fill="none" stroke="#fff" stroke-width="12" stroke-linecap="round" opacity=".13"/>
  `, defs(mode, key));
}

mkdirSync(outDir, { recursive: true });

for (const [name, mode] of Object.entries(modes)) {
  const dir = join(outDir, name);
  mkdirSync(dir, { recursive: true });
  const key = `21B-${name}`;
  writeFileSync(join(dir, "01-background.svg"), pieces.background(mode, key));
  writeFileSync(join(dir, "02-glass-panel.svg"), pieces.glassPanel(mode, key));
  writeFileSync(join(dir, "03-liquid-fill.svg"), pieces.liquid(mode, key));
  writeFileSync(join(dir, "04-measuring-cup.svg"), pieces.cup(mode));
  writeFileSync(join(dir, "05-plus.svg"), pieces.plus(mode));
  writeFileSync(join(dir, "06-highlights.svg"), pieces.highlights(mode));
  writeFileSync(join(dir, "composite.svg"), composite(mode, key));
}

writeFileSync(join(outDir, "preview.html"), `<!doctype html>
<html lang="de">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>UroBilanz Liquid Glass Icon 21B</title>
  <style>
    body { margin: 0; font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif; background: #101517; color: #ecf5f6; }
    main { max-width: 1100px; margin: 0 auto; padding: 42px 24px; }
    h1 { margin: 0 0 8px; font-size: 34px; }
    p { color: #a9bdc0; margin: 0 0 26px; }
    .grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(240px, 1fr)); gap: 22px; }
    .card { border: 1px solid rgba(180, 230, 240, .22); background: rgba(255,255,255,.05); border-radius: 26px; padding: 18px; }
    .icon { width: min(100%, 320px); aspect-ratio: 1; display: block; margin: 0 auto 14px; filter: drop-shadow(0 22px 34px rgba(0,0,0,.30)); }
    .layers { display: grid; grid-template-columns: repeat(3, 1fr); gap: 10px; }
    .layers img { width: 100%; aspect-ratio: 1; background: repeating-conic-gradient(#1b2426 0 25%, #202b2d 0 50%) 50% / 20px 20px; border-radius: 14px; }
    h2 { font-size: 18px; margin: 0 0 14px; }
    .label { font-weight: 700; margin-top: 8px; }
  </style>
</head>
<body>
  <main>
    <h1>UroBilanz Icon 21B</h1>
    <p>Layer-Quelle fuer Liquid Glass: Light/Dark, transparente Ebenen und normale SVG-Vorschau.</p>
    <div class="grid">
      <section class="card">
        <h2>Light</h2>
        <img class="icon" src="light/composite.svg" alt="UroBilanz Light Icon">
      </section>
      <section class="card">
        <h2>Dark</h2>
        <img class="icon" src="dark/composite.svg" alt="UroBilanz Dark Icon">
      </section>
    </div>
    <div class="grid" style="margin-top:22px">
      <section class="card">
        <h2>Light Ebenen</h2>
        <div class="layers">
          <img src="light/01-background.svg"><img src="light/02-glass-panel.svg"><img src="light/03-liquid-fill.svg">
          <img src="light/04-measuring-cup.svg"><img src="light/05-plus.svg"><img src="light/06-highlights.svg">
        </div>
      </section>
      <section class="card">
        <h2>Dark Ebenen</h2>
        <div class="layers">
          <img src="dark/01-background.svg"><img src="dark/02-glass-panel.svg"><img src="dark/03-liquid-fill.svg">
          <img src="dark/04-measuring-cup.svg"><img src="dark/05-plus.svg"><img src="dark/06-highlights.svg">
        </div>
      </section>
    </div>
  </main>
</body>
</html>
`);

writeFileSync(join(outDir, "README.md"), `# UroBilanz Liquid Glass Icon 21B

Diese Mappe ist die saubere Quelle fuer das finale UroBilanz-App-Icon.

## Inhalt

- \`light/composite.svg\` und \`dark/composite.svg\`: fertige Vorschau fuer Light/Dark.
- \`light/01-...\` bis \`light/06-...\`: getrennte Light-Ebenen.
- \`dark/01-...\` bis \`dark/06-...\`: getrennte Dark-Ebenen.
- \`preview.html\`: schnelle Ansicht im Browser.

## Warum Ebenen?

macOS 26 / Liquid Glass lebt von getrennten Motiv-, Glas-, Licht- und Hintergrundebenen. Diese Dateien sind deshalb nicht nur ein flaches Bild, sondern als Import-Vorlage fuer Icon Composer vorbereitet.

## Aktueller App-Stand

Auf diesem Mac ist kein Icon Composer/Xcode-Werkzeug installiert. Deshalb bleibt in der gebauten App vorerst die normale \`.icns\`-Datei als kompatibler Fallback aktiv. Sobald Icon Composer verfuegbar ist, koennen diese SVG-Ebenen importiert und als echtes Liquid-Glass-App-Icon exportiert werden.
`);

console.log(`Liquid Glass icon source written to ${outDir}`);
