/**
 * Génère les icônes PWA (PNG) à partir d'un rendu vectoriel simple :
 * assiette + couverts blancs sur fond vert de marque.
 *
 *   node scripts/generate-icons.mjs
 *
 * Aucune dépendance : l'encodeur PNG tient dans le fichier (zlib natif).
 */
import { deflateSync } from "node:zlib";
import { writeFileSync, mkdirSync } from "node:fs";
import { dirname, join } from "node:path";
import { fileURLToPath } from "node:url";

const OUT_DIR = join(dirname(fileURLToPath(import.meta.url)), "..", "public", "icons");

const BRAND = [13, 146, 104]; // #0d9268
const WHITE = [255, 255, 255];

// --- Encodeur PNG minimal -------------------------------------------------

const CRC_TABLE = Array.from({ length: 256 }, (_, n) => {
  let c = n;
  for (let k = 0; k < 8; k++) c = c & 1 ? 0xedb88320 ^ (c >>> 1) : c >>> 1;
  return c >>> 0;
});

function crc32(buffer) {
  let c = 0xffffffff;
  for (const byte of buffer) c = CRC_TABLE[(c ^ byte) & 0xff] ^ (c >>> 8);
  return (c ^ 0xffffffff) >>> 0;
}

function chunk(type, data) {
  const length = Buffer.alloc(4);
  length.writeUInt32BE(data.length);
  const body = Buffer.concat([Buffer.from(type, "ascii"), data]);
  const crc = Buffer.alloc(4);
  crc.writeUInt32BE(crc32(body));
  return Buffer.concat([length, body, crc]);
}

function encodePng(size, pixels) {
  const ihdr = Buffer.alloc(13);
  ihdr.writeUInt32BE(size, 0);
  ihdr.writeUInt32BE(size, 4);
  ihdr[8] = 8; // 8 bits par canal
  ihdr[9] = 6; // RGBA
  const raw = Buffer.alloc((size * 4 + 1) * size);
  for (let y = 0; y < size; y++) {
    const rowStart = y * (size * 4 + 1);
    raw[rowStart] = 0; // filtre "None"
    pixels.copy(raw, rowStart + 1, y * size * 4, (y + 1) * size * 4);
  }
  return Buffer.concat([
    Buffer.from([0x89, 0x50, 0x4e, 0x47, 0x0d, 0x0a, 0x1a, 0x0a]),
    chunk("IHDR", ihdr),
    chunk("IDAT", deflateSync(raw, { level: 9 })),
    chunk("IEND", Buffer.alloc(0)),
  ]);
}

// --- Géométrie ------------------------------------------------------------

const clamp01 = (v) => Math.min(1, Math.max(0, v));
/** Anti-aliasing : couverture d'un pixel selon sa distance signée au bord. */
const coverage = (distance, feather) => clamp01(0.5 - distance / feather);

function roundedRectDistance(x, y, half, radius) {
  const dx = Math.abs(x) - (half - radius);
  const dy = Math.abs(y) - (half - radius);
  const ox = Math.max(dx, 0);
  const oy = Math.max(dy, 0);
  return Math.hypot(ox, oy) + Math.min(Math.max(dx, dy), 0) - radius;
}

function capsuleDistance(px, py, ax, ay, bx, by, radius) {
  const abx = bx - ax;
  const aby = by - ay;
  const t = clamp01(((px - ax) * abx + (py - ay) * aby) / (abx * abx + aby * aby));
  return Math.hypot(px - ax - abx * t, py - ay - aby * t) - radius;
}

/** Dessine l'icône dans un buffer RGBA. `maskable` = fond plein bord à bord. */
function render(size, { maskable = false } = {}) {
  const pixels = Buffer.alloc(size * size * 4);
  const feather = 1.5 / size; // en coordonnées normalisées [-0.5, 0.5]
  // Une icône maskable doit tenir dans le cercle sûr (80% du canevas).
  const scale = maskable ? 0.78 : 1;

  for (let y = 0; y < size; y++) {
    for (let x = 0; x < size; x++) {
      // Coordonnées normalisées centrées.
      const nx = (x + 0.5) / size - 0.5;
      const ny = (y + 0.5) / size - 0.5;

      const bgDistance = maskable
        ? -1 // fond plein
        : roundedRectDistance(nx, ny, 0.5, 0.22);
      const bgAlpha = coverage(bgDistance, feather);

      const ux = nx / scale;
      const uy = ny / scale;

      // Assiette : anneau blanc épais.
      const plate = Math.abs(Math.hypot(ux, uy) - 0.235) - 0.028;

      // Fourchette (manche + 3 dents) à gauche.
      const forkHandle = capsuleDistance(ux, uy, -0.3, -0.02, -0.3, 0.29, 0.028);
      const forkNeck = capsuleDistance(ux, uy, -0.3, -0.12, -0.3, -0.02, 0.045);
      const tines = Math.min(
        capsuleDistance(ux, uy, -0.345, -0.3, -0.345, -0.12, 0.019),
        capsuleDistance(ux, uy, -0.3, -0.31, -0.3, -0.12, 0.019),
        capsuleDistance(ux, uy, -0.255, -0.3, -0.255, -0.12, 0.019),
      );

      // Couteau à droite : lame effilée + manche.
      const blade = capsuleDistance(ux, uy, 0.3, -0.3, 0.3, -0.04, 0.042);
      const knifeHandle = capsuleDistance(ux, uy, 0.3, -0.04, 0.3, 0.29, 0.028);

      const shape = Math.min(plate, forkHandle, forkNeck, tines, blade, knifeHandle);
      const shapeAlpha = coverage(shape, feather);

      const [br, bgc, bb] = BRAND;
      const [wr, wg, wb] = WHITE;
      const r = br + (wr - br) * shapeAlpha;
      const g = bgc + (wg - bgc) * shapeAlpha;
      const b = bb + (wb - bb) * shapeAlpha;

      const offset = (y * size + x) * 4;
      pixels[offset] = Math.round(r);
      pixels[offset + 1] = Math.round(g);
      pixels[offset + 2] = Math.round(b);
      pixels[offset + 3] = Math.round(bgAlpha * 255);
    }
  }

  return pixels;
}

// --- Sortie ---------------------------------------------------------------

mkdirSync(OUT_DIR, { recursive: true });

const targets = [
  { file: "icon-192.png", size: 192, maskable: false },
  { file: "icon-512.png", size: 512, maskable: false },
  { file: "icon-maskable-512.png", size: 512, maskable: true },
  { file: "apple-touch-icon.png", size: 180, maskable: true },
];

for (const { file, size, maskable } of targets) {
  writeFileSync(join(OUT_DIR, file), encodePng(size, render(size, { maskable })));
  console.log(`✓ ${file} (${size}×${size})`);
}
