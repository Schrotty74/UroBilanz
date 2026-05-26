import { writeFileSync, mkdirSync } from "node:fs";
import { join } from "node:path";

const out = new URL(".", import.meta.url).pathname;
const svgDir = join(out, "svg");
mkdirSync(svgDir, { recursive: true });

const concepts = [
  ["01", "Duo Tropfen", "Gelber Urin-Tropfen und blauer Wasser-Tropfen im Glasrahmen.", "duo"],
  ["02", "Bilanz Skala", "Zwei Tropfen als ausgewogene Bilanz mit feiner Messlinie.", "scale"],
  ["03", "Tageskurve", "Tropfen mit Verlaufslinie fuer Auswertung und Dashboard.", "curve"],
  ["04", "Glas Becher", "Messbecher als Symbol fuer Menge und Protokoll.", "cup"],
  ["05", "Uro Blatt", "Protokollblatt mit zwei Fluessigkeitsmarken.", "sheet"],
  ["06", "B Kreis", "Abstraktes Bilanz-B mit Urin- und Wasserfarbe.", "bmark"],
  ["07", "24h Ring", "Messzeitraum 06:00 bis 05:59 als Ring mit Tropfen.", "ring"],
  ["08", "Plus Tropfen", "Fokus auf neue Eintraege und Ergaenzen.", "plus"],
  ["09", "Wellen Bilanz", "Zwei ruhige Fluessigkeitswellen im Glas.", "waves"],
  ["10", "Uro Kompass", "Kompakte medizinisch-sachliche Auswertung mit Zielpunkt.", "compass"],
];

function palette(mode) {
  return mode === "dark"
    ? {
        bg1: "#09262a",
        bg2: "#111315",
        glass: "rgba(255,255,255,.18)",
        stroke: "rgba(255,255,255,.30)",
        ink: "#f7fbff",
        muted: "#c6d4d7",
        urine: "#ffc928",
        urine2: "#a97800",
        water: "#22a4ff",
        water2: "#065b9f",
      }
    : {
        bg1: "#dff9fb",
        bg2: "#f9fbfd",
        glass: "rgba(255,255,255,.58)",
        stroke: "rgba(8,64,70,.22)",
        ink: "#0c3438",
        muted: "#45656b",
        urine: "#f8bb11",
        urine2: "#ffdf72",
        water: "#1689df",
        water2: "#77caff",
      };
}

function defs(p, id) {
  return `
  <defs>
    <linearGradient id="bg-${id}" x1="0" y1="0" x2="1" y2="1">
      <stop offset="0" stop-color="${p.bg1}"/>
      <stop offset="1" stop-color="${p.bg2}"/>
    </linearGradient>
    <linearGradient id="u-${id}" x1="0" y1="0" x2="1" y2="1">
      <stop offset="0" stop-color="${p.urine2}"/>
      <stop offset=".52" stop-color="${p.urine}"/>
      <stop offset="1" stop-color="#fff2a8"/>
    </linearGradient>
    <linearGradient id="w-${id}" x1="0" y1="0" x2="1" y2="1">
      <stop offset="0" stop-color="${p.water2}"/>
      <stop offset=".55" stop-color="${p.water}"/>
      <stop offset="1" stop-color="#bfe9ff"/>
    </linearGradient>
    <filter id="shadow-${id}" x="-30%" y="-30%" width="160%" height="160%">
      <feDropShadow dx="0" dy="14" stdDeviation="14" flood-color="#000" flood-opacity=".24"/>
    </filter>
    <filter id="soft-${id}" x="-30%" y="-30%" width="160%" height="160%">
      <feGaussianBlur stdDeviation="7"/>
    </filter>
  </defs>`;
}

function drop(x, y, s, fill, rotate = 0) {
  return `<path transform="translate(${x} ${y}) rotate(${rotate} ${s / 2} ${s / 2}) scale(${s / 100})" d="M50 6 C70 32 86 50 86 68 C86 87 70 98 50 98 C30 98 14 87 14 68 C14 50 30 32 50 6 Z" fill="${fill}"/>`;
}

function base(p, id, inner) {
  return `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1024 1024">
    ${defs(p, id)}
    <rect x="62" y="62" width="900" height="900" rx="220" fill="url(#bg-${id})"/>
    <circle cx="280" cy="260" r="180" fill="#fff" opacity=".12" filter="url(#soft-${id})"/>
    <circle cx="760" cy="730" r="210" fill="#fff" opacity=".08" filter="url(#soft-${id})"/>
    <rect x="94" y="94" width="836" height="836" rx="198" fill="${p.glass}" stroke="${p.stroke}" stroke-width="10" filter="url(#shadow-${id})"/>
    <path d="M160 180 C340 95 655 92 850 210" fill="none" stroke="#fff" stroke-width="18" stroke-linecap="round" opacity=".30"/>
    ${inner}
  </svg>`;
}

function icon(kind, mode, number) {
  const p = palette(mode);
  const id = `${number}-${mode}`;
  const u = `url(#u-${id})`;
  const w = `url(#w-${id})`;
  const white = mode === "dark" ? "#f7fbff" : "#0c3438";
  const faint = mode === "dark" ? "rgba(255,255,255,.30)" : "rgba(12,52,56,.26)";
  const parts = {
    duo: `${drop(250, 240, 390, u, -8)}${drop(520, 300, 270, w, 7)}<path d="M320 690 C430 760 575 752 700 662" fill="none" stroke="${white}" stroke-width="34" stroke-linecap="round" opacity=".42"/>`,
    scale: `<path d="M245 655 H780" stroke="${white}" stroke-width="42" stroke-linecap="round" opacity=".48"/><path d="M512 230 V665" stroke="${faint}" stroke-width="24" stroke-linecap="round"/>${drop(255, 300, 260, u, -10)}${drop(535, 300, 260, w, 10)}<circle cx="512" cy="682" r="42" fill="${white}" opacity=".65"/>`,
    curve: `${drop(202, 265, 250, u, -12)}${drop(615, 300, 210, w, 10)}<path d="M235 705 L340 520 L438 610 L560 395 L676 535 L790 355" fill="none" stroke="${white}" stroke-width="42" stroke-linecap="round" stroke-linejoin="round" opacity=".64"/>`,
    cup: `<path d="M285 230 H710 L650 760 H345 Z" fill="${p.glass}" stroke="${white}" stroke-width="34" opacity=".72"/><path d="M335 540 C445 500 530 620 650 560 L628 740 H368 Z" fill="${u}" opacity=".86"/><path d="M334 430 C438 370 540 482 666 412 L650 560 C530 620 445 500 335 540 Z" fill="${w}" opacity=".78"/>`,
    sheet: `<rect x="270" y="180" width="485" height="640" rx="72" fill="${p.glass}" stroke="${white}" stroke-width="28" opacity=".82"/><path d="M365 330 H650 M365 455 H650 M365 580 H590" stroke="${white}" stroke-width="30" stroke-linecap="round" opacity=".55"/>${drop(390, 604, 150, u)}${drop(555, 618, 120, w)}`,
    bmark: `<text x="512" y="650" text-anchor="middle" font-family="-apple-system,BlinkMacSystemFont,Segoe UI,sans-serif" font-size="520" font-weight="800" fill="${white}" opacity=".24">B</text>${drop(286, 270, 300, u, -5)}${drop(500, 315, 250, w, 8)}<path d="M355 735 C465 790 625 780 736 690" fill="none" stroke="${white}" stroke-width="38" stroke-linecap="round" opacity=".58"/>`,
    ring: `<circle cx="512" cy="512" r="300" fill="none" stroke="${white}" stroke-width="42" opacity=".28"/><path d="M512 212 A300 300 0 0 1 812 512" fill="none" stroke="${w}" stroke-width="46" stroke-linecap="round"/><path d="M512 812 A300 300 0 0 1 212 512" fill="none" stroke="${u}" stroke-width="46" stroke-linecap="round"/>${drop(382, 300, 250, u)}${drop(545, 365, 190, w)}`,
    plus: `<path d="M512 240 V760 M252 500 H772" stroke="${white}" stroke-width="74" stroke-linecap="round" opacity=".34"/>${drop(292, 292, 285, u, -9)}${drop(530, 350, 230, w, 8)}`,
    waves: `<path d="M220 430 C330 350 430 500 540 420 C625 360 690 390 800 330" fill="none" stroke="${w}" stroke-width="54" stroke-linecap="round" opacity=".82"/><path d="M220 610 C330 530 430 680 540 600 C625 540 690 570 800 510" fill="none" stroke="${u}" stroke-width="54" stroke-linecap="round" opacity=".86"/><circle cx="512" cy="512" r="238" fill="none" stroke="${white}" stroke-width="28" opacity=".24"/>`,
    compass: `<circle cx="512" cy="512" r="300" fill="${p.glass}" stroke="${white}" stroke-width="28" opacity=".70"/><path d="M512 235 L584 512 L512 790 L440 512 Z" fill="${u}" opacity=".90"/><path d="M235 512 L512 440 L790 512 L512 584 Z" fill="${w}" opacity=".76"/><circle cx="512" cy="512" r="52" fill="${white}" opacity=".72"/>`,
  };
  return base(p, id, parts[kind]);
}

let cards = [];
for (const [number, name, note, kind] of concepts) {
  for (const mode of ["light", "dark"]) {
    writeFileSync(join(svgDir, `${number}-${mode}.svg`), icon(kind, mode, number));
  }
  cards.push(`
    <article class="card">
      <div class="icons">
        <img src="svg/${number}-light.svg" alt="${name} Light">
        <img src="svg/${number}-dark.svg" alt="${name} Dark">
      </div>
      <h2>${number}. ${name}</h2>
      <p>${note}</p>
    </article>`);
}

const html = `<!doctype html>
<html lang="de">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>UroBilanz Icon-Entwürfe</title>
  <style>
    :root { color-scheme: light dark; font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif; background: #eef4f5; color: #112b2f; }
    body { margin: 0; padding: 34px; }
    header { max-width: 1180px; margin: 0 auto 24px; }
    h1 { margin: 0 0 8px; font-size: 36px; }
    p { color: color-mix(in srgb, currentColor 72%, transparent); line-height: 1.45; }
    .grid { max-width: 1180px; margin: 0 auto; display: grid; grid-template-columns: repeat(auto-fit, minmax(260px, 1fr)); gap: 18px; }
    .card { border: 1px solid color-mix(in srgb, currentColor 18%, transparent); border-radius: 22px; padding: 18px; background: color-mix(in srgb, Canvas 70%, transparent); box-shadow: 0 18px 48px rgba(0,0,0,.10); }
    .icons { display: grid; grid-template-columns: 1fr 1fr; gap: 14px; }
    img { width: 100%; aspect-ratio: 1; display: block; border-radius: 22%; box-shadow: 0 12px 34px rgba(0,0,0,.18); }
    h2 { font-size: 18px; margin: 14px 0 4px; }
    @media (prefers-color-scheme: dark) { :root { background: #101313; color: #edf6f7; } .card { box-shadow: 0 18px 48px rgba(0,0,0,.32); } }
  </style>
</head>
<body>
  <header>
    <h1>UroBilanz Icon-Entwürfe</h1>
    <p>Je Entwurf links die Light-Version, rechts die Dark-Version. Alle Varianten sind als SVG angelegt und können als App-Icon-Basis oder als In-App-Symbol weiterverarbeitet werden.</p>
  </header>
  <main class="grid">${cards.join("")}</main>
</body>
</html>`;

writeFileSync(join(out, "index.html"), html);

const readme = `# UroBilanz Icon-Entwürfe

Diese Mappe enthält 10 Icon-Richtungen für UroBilanz.

- Vorschau: index.html
- Einzelne SVGs: svg/
- Je Entwurf gibt es eine Light- und Dark-Version.

Die Dateien sind Entwürfe. Für ein finales macOS-26-Liquid-Glass-App-Icon sollte danach ein sauberer Asset-Catalog/Icon-Composer-Schritt folgen.
`;
writeFileSync(join(out, "README.md"), readme);
