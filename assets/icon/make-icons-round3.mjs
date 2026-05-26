import { writeFileSync, mkdirSync } from "node:fs";
import { join } from "node:path";

const out = new URL(".", import.meta.url).pathname;
const svgDir = join(out, "svg-runde-3");
mkdirSync(svgDir, { recursive: true });

const concepts = [
  ["21", "Becher Plus Klar", "Weiterentwicklung von 20 mit klarerem Plus und Messbecher.", "cupPlusClear"],
  ["22", "24h Becher Duo", "Weiterentwicklung von 17 mit Becher, Ring und zwei Tropfen.", "cup24Duo"],
  ["23", "Bilanz Becher", "Weiterentwicklung von 12 mit zwei Messbereichen im Becher.", "balanceCup"],
  ["24", "Waage Tropfen Glas", "Weiterentwicklung von 15 mit deutlicherer Waage.", "glassScale"],
  ["25", "Becher Check", "Messbecher mit Checkmark fuer erledigte Protokollierung.", "cupCheck"],
  ["26", "Plus Ring", "Plus und 24h-Ring kombiniert mit Urin/Wasser-Farben.", "plusRing"],
  ["27", "Duo Becher Minimal", "Sehr reduzierter Messbecher mit zwei Tropfen.", "minimalCupDuo"],
  ["28", "Bilanz Fenster", "Zwei farbige Kammern wie eine kleine Auswertung im Glas.", "splitWindow"],
  ["29", "Messskala Tropfen", "Fokus auf ml-Messung, Skala und zwei Tropfen.", "scaleMarks"],
  ["30", "Uro Plus Glas", "App-artiges U/Plus Symbol mit Messcharakter.", "uroPlus"],
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

function drop(x, y, s, fill, rotate = 0, opacity = 1) {
  return `<path transform="translate(${x} ${y}) rotate(${rotate} ${s / 2} ${s / 2}) scale(${s / 100})" d="M50 6 C70 32 86 50 86 68 C86 87 70 98 50 98 C30 98 14 87 14 68 C14 50 30 32 50 6 Z" fill="${fill}" opacity="${opacity}"/>`;
}

function cupPath(x, y, w, h) {
  return `M${x} ${y} H${x + w} L${x + w * .86} ${y + h} H${x + w * .14} Z`;
}

function cup(x, y, w, h, p, fill = "none", opacity = ".72") {
  return `<path d="${cupPath(x, y, w, h)}" fill="${fill}" stroke="${p.ink}" stroke-width="${Math.max(20, w * .075)}" opacity="${opacity}" stroke-linejoin="round"/>`;
}

function marks(x, y, h, p) {
  return [0, 1, 2, 3].map(i => `<path d="M${x} ${y + i * h / 3} H${x + 56}" stroke="${p.ink}" stroke-width="18" stroke-linecap="round" opacity=".38"/>`).join("");
}

function icon(kind, mode, number) {
  const p = palette(mode);
  const id = `${number}-${mode}`;
  const u = `url(#u-${id})`;
  const w = `url(#w-${id})`;
  const ink = p.ink;
  const faint = mode === "dark" ? "rgba(255,255,255,.34)" : "rgba(16,54,59,.30)";
  const parts = {
    cupPlusClear: `${cup(300, 225, 430, 545, p, p.glass2)}<path d="M355 575 C460 510 545 625 670 548 L642 740 H385 Z" fill="${u}" opacity=".86"/><path d="M512 318 V504 M419 411 H605" stroke="${w}" stroke-width="60" stroke-linecap="round"/>${marks(332, 318, 300, p)}`,
    cup24Duo: `${cup(295, 235, 435, 535, p, p.glass2)}<circle cx="512" cy="508" r="250" fill="none" stroke="${faint}" stroke-width="34"/><path d="M512 258 A250 250 0 0 1 762 508" fill="none" stroke="${w}" stroke-width="36" stroke-linecap="round"/><path d="M512 758 A250 250 0 0 1 262 508" fill="none" stroke="${u}" stroke-width="36" stroke-linecap="round"/>${drop(382, 378, 145, u)}${drop(520, 390, 130, w)}`,
    balanceCup: `${cup(278, 220, 470, 555, p, p.glass2)}<path d="M340 450 C438 392 542 500 680 430 L665 565 C540 630 438 520 340 585 Z" fill="${w}" opacity=".80"/><path d="M340 585 C438 520 540 630 665 565 L635 742 H384 Z" fill="${u}" opacity=".86"/><path d="M322 508 H700" stroke="${ink}" stroke-width="20" stroke-linecap="round" opacity=".36"/>`,
    glassScale: `<path d="M250 665 H775" stroke="${ink}" stroke-width="44" stroke-linecap="round" opacity=".43"/><path d="M512 245 V665" stroke="${faint}" stroke-width="28" stroke-linecap="round"/><ellipse cx="378" cy="612" rx="150" ry="54" fill="${p.glass2}" stroke="${p.stroke}" stroke-width="14"/><ellipse cx="647" cy="612" rx="150" ry="54" fill="${p.glass2}" stroke="${p.stroke}" stroke-width="14"/>${drop(282, 315, 250, u, -8)}${drop(545, 320, 242, w, 8)}`,
    cupCheck: `${cup(285, 235, 455, 535, p, p.glass2)}<path d="M348 565 C455 505 546 618 668 548 L640 740 H386 Z" fill="${u}" opacity=".84"/><path d="M375 440 L475 535 L650 350" fill="none" stroke="${w}" stroke-width="58" stroke-linecap="round" stroke-linejoin="round"/>`,
    plusRing: `<circle cx="512" cy="512" r="300" fill="${p.glass2}" stroke="${p.stroke}" stroke-width="18"/><path d="M512 242 A270 270 0 0 1 782 512" fill="none" stroke="${w}" stroke-width="42" stroke-linecap="round"/><path d="M512 782 A270 270 0 0 1 242 512" fill="none" stroke="${u}" stroke-width="42" stroke-linecap="round"/><path d="M512 348 V676 M348 512 H676" stroke="${ink}" stroke-width="66" stroke-linecap="round" opacity=".55"/>`,
    minimalCupDuo: `${cup(322, 238, 382, 520, p, p.glass2)}${drop(370, 350, 230, u, -6)}${drop(535, 390, 170, w, 7)}<path d="M372 705 H654" stroke="${ink}" stroke-width="28" stroke-linecap="round" opacity=".36"/>`,
    splitWindow: `<rect x="278" y="240" width="468" height="520" rx="98" fill="${p.glass2}" stroke="${ink}" stroke-width="30" opacity=".68"/><path d="M512 260 V740" stroke="${ink}" stroke-width="24" opacity=".30"/><path d="M310 560 C410 500 455 615 512 570 V735 H332 Z" fill="${u}" opacity=".86"/><path d="M512 485 C585 420 642 540 716 462 V735 H512 Z" fill="${w}" opacity=".82"/>`,
    scaleMarks: `${cup(315, 230, 395, 545, p, p.glass2)}${marks(350, 320, 330, p)}${drop(432, 335, 210, u, -5)}${drop(540, 395, 150, w, 7)}<text x="512" y="730" text-anchor="middle" font-family="-apple-system,BlinkMacSystemFont,Segoe UI,sans-serif" font-size="78" font-weight="800" fill="${ink}" opacity=".46">ml</text>`,
    uroPlus: `<path d="M302 290 V555 C302 695 397 773 512 773 C627 773 722 695 722 555 V290" fill="none" stroke="${ink}" stroke-width="76" stroke-linecap="round" opacity=".28"/><path d="M512 360 V612 M386 486 H638" stroke="${w}" stroke-width="58" stroke-linecap="round"/><path d="M335 610 C435 725 600 720 700 610" fill="none" stroke="${u}" stroke-width="46" stroke-linecap="round"/>`,
  };
  return base(p, id, parts[kind]);
}

let cards = [];
for (const [number, name, note, kind] of concepts) {
  for (const mode of ["light", "dark"]) {
    writeFileSync(join(svgDir, `${number}-${mode}.svg`), icon(kind, mode, number));
  }
  cards.push(`<article class="card"><div class="icons"><img src="svg-runde-3/${number}-light.svg" alt="${name} Light"><img src="svg-runde-3/${number}-dark.svg" alt="${name} Dark"></div><h2>${number}. ${name}</h2><p>${note}</p></article>`);
}

const html = `<!doctype html><html lang="de"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width, initial-scale=1"><title>UroBilanz Icon-Entwürfe Runde 3</title><style>
:root{color-scheme:light dark;font-family:-apple-system,BlinkMacSystemFont,"Segoe UI",sans-serif;background:#eef4f5;color:#112b2f}body{margin:0;padding:34px}header{max-width:1180px;margin:0 auto 24px}h1{margin:0 0 8px;font-size:36px}p{color:color-mix(in srgb,currentColor 72%,transparent);line-height:1.45}.grid{max-width:1180px;margin:0 auto;display:grid;grid-template-columns:repeat(auto-fit,minmax(260px,1fr));gap:18px}.card{border:1px solid color-mix(in srgb,currentColor 18%,transparent);border-radius:22px;padding:18px;background:color-mix(in srgb,Canvas 70%,transparent);box-shadow:0 18px 48px rgba(0,0,0,.10)}.icons{display:grid;grid-template-columns:1fr 1fr;gap:14px}img{width:100%;aspect-ratio:1;display:block;border-radius:22%;box-shadow:0 12px 34px rgba(0,0,0,.18)}h2{font-size:18px;margin:14px 0 4px}@media(prefers-color-scheme:dark){:root{background:#101313;color:#edf6f7}.card{box-shadow:0 18px 48px rgba(0,0,0,.32)}}
</style></head><body><header><h1>UroBilanz Icon-Entwürfe · Runde 3</h1><p>Diese Runde verfeinert deine Favoriten 20, 17, 12 und 15: Messbecher, 24h, Plus und Bilanz/Waage.</p></header><main class="grid">${cards.join("")}</main></body></html>`;

writeFileSync(join(out, "index-runde-3.html"), html);
