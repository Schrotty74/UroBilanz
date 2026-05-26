import { writeFileSync, mkdirSync } from "node:fs";
import { join } from "node:path";

const out = new URL(".", import.meta.url).pathname;
const svgDir = join(out, "svg-finalisten");
mkdirSync(svgDir, { recursive: true });

const concepts = [
  ["21A", "Becher Plus Klar · mehr Füllstand", "21 als Basis, aber mit hoeherem zweifarbigem Füllstand wie bei 23.", "full"],
  ["21B", "Becher Plus Klar · ruhiger", "Mehr Füllstand, aber weniger dominantem Plus.", "softPlus"],
  ["21C", "Becher Plus Klar · Skala", "Mehr Füllstand mit deutlicher ml-Skala.", "scale"],
  ["21D", "Becher Plus Klar · Wasser oben", "Mehr Füllstand mit sichtbarer Wasser- und Urinschicht.", "layered"],
  ["21E", "Becher Plus Klar · kräftig", "Mehr Kontrast und kräftigeres Plus fuer Dock-Erkennbarkeit.", "bold"],
];

function palette(mode) {
  return mode === "dark"
    ? { bg1: "#08282d", bg2: "#111314", glass: "rgba(255,255,255,.17)", glass2: "rgba(255,255,255,.10)", stroke: "rgba(255,255,255,.34)", ink: "#f6fbff", urine: "#ffcb31", urine2: "#9a6e00", water: "#1ba2ff", water2: "#075b9e" }
    : { bg1: "#e7fbfc", bg2: "#ffffff", glass: "rgba(255,255,255,.64)", glass2: "rgba(255,255,255,.42)", stroke: "rgba(10,64,70,.24)", ink: "#10363b", urine: "#f6b910", urine2: "#ffe394", water: "#168ee8", water2: "#91d9ff" };
}

function defs(p, id) {
  return `
  <defs>
    <linearGradient id="bg-${id}" x1="0" y1="0" x2="1" y2="1"><stop offset="0" stop-color="${p.bg1}"/><stop offset="1" stop-color="${p.bg2}"/></linearGradient>
    <linearGradient id="u-${id}" x1="0" y1="0" x2="1" y2="1"><stop offset="0" stop-color="${p.urine2}"/><stop offset=".58" stop-color="${p.urine}"/><stop offset="1" stop-color="#fff4b8"/></linearGradient>
    <linearGradient id="w-${id}" x1="0" y1="0" x2="1" y2="1"><stop offset="0" stop-color="${p.water2}"/><stop offset=".55" stop-color="${p.water}"/><stop offset="1" stop-color="#c9f0ff"/></linearGradient>
    <filter id="shadow-${id}" x="-30%" y="-30%" width="160%" height="160%"><feDropShadow dx="0" dy="16" stdDeviation="15" flood-color="#000" flood-opacity=".25"/></filter>
    <filter id="blur-${id}" x="-30%" y="-30%" width="160%" height="160%"><feGaussianBlur stdDeviation="9"/></filter>
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

function cup(p, fill = "none") {
  return `<path d="M300 225 H730 L668 770 H362 Z" fill="${fill}" stroke="${p.ink}" stroke-width="31" opacity=".74" stroke-linejoin="round"/>`;
}

function marks(p, opacity = ".38") {
  return [0, 1, 2, 3].map(i => `<path d="M336 ${325 + i * 93} H392" stroke="${p.ink}" stroke-width="17" stroke-linecap="round" opacity="${opacity}"/>`).join("");
}

function icon(kind, mode, number) {
  const p = palette(mode);
  const id = `${number}-${mode}`;
  const u = `url(#u-${id})`;
  const w = `url(#w-${id})`;
  const plusOpacity = kind === "softPlus" ? ".70" : ".92";
  const plusWidth = kind === "bold" ? 66 : 56;
  const mark = kind === "scale" ? marks(p, ".52") : marks(p, ".28");
  const fill = {
    full: `<path d="M350 505 C462 430 555 565 680 488 L642 740 H385 Z" fill="${u}" opacity=".88"/><path d="M350 405 C462 330 560 465 692 390 L680 488 C555 565 462 430 350 505 Z" fill="${w}" opacity=".80"/>`,
    softPlus: `<path d="M350 505 C462 430 555 565 680 488 L642 740 H385 Z" fill="${u}" opacity=".88"/><path d="M350 405 C462 330 560 465 692 390 L680 488 C555 565 462 430 350 505 Z" fill="${w}" opacity=".80"/>`,
    scale: `<path d="M350 505 C462 430 555 565 680 488 L642 740 H385 Z" fill="${u}" opacity=".88"/><path d="M350 405 C462 330 560 465 692 390 L680 488 C555 565 462 430 350 505 Z" fill="${w}" opacity=".80"/>`,
    layered: `<path d="M355 555 C462 490 560 600 672 532 L642 740 H385 Z" fill="${u}" opacity=".90"/><path d="M350 380 C458 310 560 430 694 360 L672 532 C560 600 462 490 355 555 Z" fill="${w}" opacity=".84"/>`,
    bold: `<path d="M348 500 C462 425 555 560 680 484 L642 740 H385 Z" fill="${u}" opacity=".92"/><path d="M348 400 C462 325 560 458 692 385 L680 484 C555 560 462 425 348 500 Z" fill="${w}" opacity=".86"/>`,
  }[kind];

  const plus = `<path d="M512 300 V500 M412 400 H612" stroke="${kind === "bold" ? w : p.ink}" stroke-width="${plusWidth}" stroke-linecap="round" opacity="${plusOpacity}"/>`;
  const shine = `<path d="M380 280 C466 238 570 250 652 304" fill="none" stroke="#fff" stroke-width="16" stroke-linecap="round" opacity=".28"/>`;
  return base(p, id, `${cup(p, p.glass2)}${fill}${mark}${plus}${shine}`);
}

let cards = [];
for (const [number, name, note, kind] of concepts) {
  for (const mode of ["light", "dark"]) {
    writeFileSync(join(svgDir, `${number}-${mode}.svg`), icon(kind, mode, number));
  }
  cards.push(`<article class="card"><div class="icons"><img src="svg-finalisten/${number}-light.svg" alt="${name} Light"><img src="svg-finalisten/${number}-dark.svg" alt="${name} Dark"></div><h2>${number}. ${name}</h2><p>${note}</p></article>`);
}

const html = `<!doctype html><html lang="de"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width, initial-scale=1"><title>UroBilanz Icon-Finalisten</title><style>
:root{color-scheme:light dark;font-family:-apple-system,BlinkMacSystemFont,"Segoe UI",sans-serif;background:#eef4f5;color:#112b2f}body{margin:0;padding:34px}header{max-width:1180px;margin:0 auto 24px}h1{margin:0 0 8px;font-size:36px}p{color:color-mix(in srgb,currentColor 72%,transparent);line-height:1.45}.grid{max-width:1180px;margin:0 auto;display:grid;grid-template-columns:repeat(auto-fit,minmax(260px,1fr));gap:18px}.card{border:1px solid color-mix(in srgb,currentColor 18%,transparent);border-radius:22px;padding:18px;background:color-mix(in srgb,Canvas 70%,transparent);box-shadow:0 18px 48px rgba(0,0,0,.10)}.icons{display:grid;grid-template-columns:1fr 1fr;gap:14px}img{width:100%;aspect-ratio:1;display:block;border-radius:22%;box-shadow:0 12px 34px rgba(0,0,0,.18)}h2{font-size:18px;margin:14px 0 4px}@media(prefers-color-scheme:dark){:root{background:#101313;color:#edf6f7}.card{box-shadow:0 18px 48px rgba(0,0,0,.32)}}
</style></head><body><header><h1>UroBilanz Icon-Finalisten</h1><p>Varianten von 21 mit mehr Füllstand wie bei 23. Links Light, rechts Dark.</p></header><main class="grid">${cards.join("")}</main></body></html>`;

writeFileSync(join(out, "index-finalisten.html"), html);
