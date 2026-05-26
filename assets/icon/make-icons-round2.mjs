import { writeFileSync, mkdirSync } from "node:fs";
import { join } from "node:path";

const out = new URL(".", import.meta.url).pathname;
const svgDir = join(out, "svg-runde-2");
mkdirSync(svgDir, { recursive: true });

const concepts = [
  ["11", "Duo Tropfen Glas", "Die Favoriten-Idee als klareres Liquid-Glass-Duo.", "duoGlass"],
  ["12", "Messbecher Duo", "Messbecher mit Urin- und Wasser-Tropfen als Bilanz.", "cupDuo"],
  ["13", "Becher Verlauf", "Messbecher plus kleine Verlaufslinie im Hintergrund.", "cupCurve"],
  ["14", "Doppel-Becher", "Zwei kleine Messbecher fuer Urin und Wasser getrennt.", "doubleCup"],
  ["15", "Tropfen Waage", "Zwei Tropfen mit ruhiger Bilanz-Waage.", "dropScale"],
  ["16", "UroBilanz U", "Ein U aus Glas mit gelbem und blauem Tropfen.", "uMark"],
  ["17", "Messglas 24h", "Messglas mit 24h-Ring fuer den Messtag.", "cupRing"],
  ["18", "Duo Tropfen Minimal", "Sehr klares Symbol mit wenig Details.", "duoMinimal"],
  ["19", "Bilanz Säulen", "Zwei Messsaeulen im Glasicon fuer Mengenvergleich.", "bars"],
  ["20", "Becher Plus", "Messbecher mit Plus fuer neue Eintraege.", "cupPlus"],
];

function palette(mode) {
  return mode === "dark"
    ? {
        bg1: "#08272b",
        bg2: "#111314",
        glass: "rgba(255,255,255,.17)",
        glass2: "rgba(255,255,255,.09)",
        stroke: "rgba(255,255,255,.32)",
        ink: "#f5fbff",
        urine: "#ffca2e",
        urine2: "#9f7100",
        water: "#1fa2ff",
        water2: "#075c9e",
      }
    : {
        bg1: "#e6fbfc",
        bg2: "#ffffff",
        glass: "rgba(255,255,255,.62)",
        glass2: "rgba(255,255,255,.38)",
        stroke: "rgba(10,64,70,.24)",
        ink: "#10353a",
        urine: "#f7b912",
        urine2: "#ffe18a",
        water: "#168de5",
        water2: "#8ed7ff",
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
      <stop offset=".58" stop-color="${p.urine}"/>
      <stop offset="1" stop-color="#fff4b8"/>
    </linearGradient>
    <linearGradient id="w-${id}" x1="0" y1="0" x2="1" y2="1">
      <stop offset="0" stop-color="${p.water2}"/>
      <stop offset=".55" stop-color="${p.water}"/>
      <stop offset="1" stop-color="#c9f0ff"/>
    </linearGradient>
    <filter id="shadow-${id}" x="-30%" y="-30%" width="160%" height="160%">
      <feDropShadow dx="0" dy="16" stdDeviation="15" flood-color="#000" flood-opacity=".25"/>
    </filter>
    <filter id="blur-${id}" x="-30%" y="-30%" width="160%" height="160%">
      <feGaussianBlur stdDeviation="9"/>
    </filter>
  </defs>`;
}

function base(p, id, inner) {
  return `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1024 1024">
    ${defs(p, id)}
    <rect x="58" y="58" width="908" height="908" rx="220" fill="url(#bg-${id})"/>
    <circle cx="280" cy="235" r="205" fill="#fff" opacity=".13" filter="url(#blur-${id})"/>
    <circle cx="744" cy="752" r="230" fill="#fff" opacity=".08" filter="url(#blur-${id})"/>
    <rect x="94" y="94" width="836" height="836" rx="198" fill="${p.glass}" stroke="${p.stroke}" stroke-width="10" filter="url(#shadow-${id})"/>
    <path d="M170 178 C340 94 660 88 850 220" fill="none" stroke="#fff" stroke-width="18" stroke-linecap="round" opacity=".30"/>
    ${inner}
  </svg>`;
}

function drop(x, y, s, fill, rotate = 0, opacity = 1) {
  return `<path transform="translate(${x} ${y}) rotate(${rotate} ${s / 2} ${s / 2}) scale(${s / 100})" d="M50 6 C70 32 86 50 86 68 C86 87 70 98 50 98 C30 98 14 87 14 68 C14 50 30 32 50 6 Z" fill="${fill}" opacity="${opacity}"/>`;
}

function cup(x, y, w, h, p, id, fill = "none") {
  return `<path d="M${x} ${y} H${x + w} L${x + w * .86} ${y + h} H${x + w * .14} Z" fill="${fill}" stroke="${p.ink}" stroke-width="${Math.max(20, w * .075)}" opacity=".72" stroke-linejoin="round"/>`;
}

function icon(kind, mode, number) {
  const p = palette(mode);
  const id = `${number}-${mode}`;
  const u = `url(#u-${id})`;
  const w = `url(#w-${id})`;
  const ink = p.ink;
  const faint = mode === "dark" ? "rgba(255,255,255,.34)" : "rgba(16,53,58,.30)";
  const parts = {
    duoGlass: `<ellipse cx="390" cy="558" rx="160" ry="215" fill="${p.glass2}" stroke="${p.stroke}" stroke-width="18"/>${drop(235, 250, 360, u, -8)}${drop(508, 306, 285, w, 7)}<path d="M324 724 C430 780 596 770 706 682" fill="none" stroke="${ink}" stroke-width="34" stroke-linecap="round" opacity=".45"/>`,
    cupDuo: `${cup(280, 220, 470, 560, p, id, p.glass2)}${drop(338, 360, 250, u, -7)}${drop(540, 405, 195, w, 8)}<path d="M340 700 H675" stroke="${ink}" stroke-width="32" stroke-linecap="round" opacity=".42"/>`,
    cupCurve: `${cup(270, 210, 485, 580, p, id, p.glass2)}<path d="M330 610 C440 540 535 670 670 575 L645 750 H365 Z" fill="${u}" opacity=".85"/><path d="M330 470 C445 390 540 520 678 435 L665 575 C535 670 440 540 330 610 Z" fill="${w}" opacity=".78"/><path d="M318 330 L410 290 L485 350 L570 265 L685 315" fill="none" stroke="${ink}" stroke-width="28" stroke-linecap="round" stroke-linejoin="round" opacity=".42"/>`,
    doubleCup: `${cup(225, 278, 250, 440, p, id, p.glass2)}${cup(555, 278, 250, 440, p, id, p.glass2)}<path d="M270 500 H430 L405 690 H298 Z" fill="${u}" opacity=".85"/><path d="M600 430 H760 L735 690 H628 Z" fill="${w}" opacity=".82"/>`,
    dropScale: `<path d="M250 666 H782" stroke="${ink}" stroke-width="42" stroke-linecap="round" opacity=".42"/><path d="M512 252 V666" stroke="${faint}" stroke-width="26" stroke-linecap="round"/>${drop(260, 320, 245, u, -7)}${drop(535, 320, 245, w, 7)}<path d="M292 606 C350 650 428 650 486 606 M538 606 C596 650 674 650 732 606" fill="none" stroke="${ink}" stroke-width="24" stroke-linecap="round" opacity=".45"/>`,
    uMark: `<path d="M300 290 V560 C300 700 395 778 512 778 C629 778 724 700 724 560 V290" fill="none" stroke="${ink}" stroke-width="82" stroke-linecap="round" opacity=".30"/>${drop(330, 285, 270, u, -7)}${drop(535, 340, 220, w, 8)}`,
    cupRing: `${cup(300, 245, 425, 520, p, id, p.glass2)}<circle cx="512" cy="510" r="245" fill="none" stroke="${faint}" stroke-width="32"/><path d="M512 265 A245 245 0 0 1 742 510" fill="none" stroke="${w}" stroke-width="34" stroke-linecap="round"/><path d="M512 755 A245 245 0 0 1 270 510" fill="none" stroke="${u}" stroke-width="34" stroke-linecap="round"/>`,
    duoMinimal: `${drop(300, 260, 340, u, -6)}${drop(500, 330, 245, w, 7)}<circle cx="512" cy="512" r="318" fill="none" stroke="${ink}" stroke-width="30" opacity=".22"/>`,
    bars: `<rect x="305" y="315" width="150" height="430" rx="72" fill="${u}" opacity=".88"/><rect x="555" y="245" width="150" height="500" rx="72" fill="${w}" opacity=".82"/><path d="M262 760 H762" stroke="${ink}" stroke-width="38" stroke-linecap="round" opacity=".40"/><path d="M335 270 C430 210 550 275 660 205" fill="none" stroke="#fff" stroke-width="18" stroke-linecap="round" opacity=".30"/>`,
    cupPlus: `${cup(292, 230, 440, 540, p, id, p.glass2)}<path d="M350 560 C450 500 540 610 665 538 L642 738 H380 Z" fill="${u}" opacity=".84"/><path d="M512 310 V500 M417 405 H607" stroke="${w}" stroke-width="52" stroke-linecap="round" opacity=".88"/>`,
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
        <img src="svg-runde-2/${number}-light.svg" alt="${name} Light">
        <img src="svg-runde-2/${number}-dark.svg" alt="${name} Dark">
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
  <title>UroBilanz Icon-Entwürfe Runde 2</title>
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
    <h1>UroBilanz Icon-Entwürfe · Runde 2</h1>
    <p>Diese Runde baut auf deinen Favoriten auf: Duo Tropfen und Glas Becher. Links Light, rechts Dark.</p>
  </header>
  <main class="grid">${cards.join("")}</main>
</body>
</html>`;

writeFileSync(join(out, "index-runde-2.html"), html);
