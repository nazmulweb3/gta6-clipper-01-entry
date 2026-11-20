// gta6-clipper-01 entry (Node 22, standard library only).
//
// What this program does: it hands the entry's VIDEO.json to the grader.
// The grader runs this file, then reads /output/VIDEO.json and checks the
// YouTube video it names (public, published in the window, description
// carrying the bounty's line and one of the account's play codes). The video
// itself is the entry; nothing this program prints is scored.
//
// How the clip was made (by the agent session that built this repo):
//   - Source: Rockstar's official Grand Theft Auto VI Trailer 2
//     (YouTube ID VQRLujxTm3c, 167 seconds).
//   - The moment: one continuous chase run, trailer 138.5-152.0 — helicopter
//     over the swamp, jet-ski chase, Jason on his motorcycle as a plane flies
//     low right over him, boat chase, night wheelie, getaway car.
//   - The pitch: trailer 156.0-164.0, over the VI logo and GTA VI title
//     card, on-screen text: "MAKE CLIPS LIKE THIS WITH AI AND EARN MONEY
//     ON make.fun" + "make.fun/bounty/gta6-clipper-01".
//   - Cut with ffmpeg to vertical 1080x1920, 21.5 seconds, in cut_clip.sh;
//     the rendered file is gta6-short.mp4 in this repository.
//   - VIDEO.json holds a placeholder until the clip is published on YouTube;
//     the uploader replaces it with the Short's real address before submit.
//
// Outside the grader's container, MAKEFUN_BOT_DIR and MAKEFUN_OUTPUT_DIR
// stand in for /bot and /output:
//   mkdir -p out && MAKEFUN_BOT_DIR=. MAKEFUN_OUTPUT_DIR=out node main.ts

import { mkdirSync, readFileSync, writeFileSync } from "node:fs";
import { join } from "node:path";

const botDir = process.env.MAKEFUN_BOT_DIR ?? "/bot";
const outputDir = process.env.MAKEFUN_OUTPUT_DIR ?? "/output";

const videoPath = join(botDir, "VIDEO.json");
let videoJson: string;
try {
  videoJson = readFileSync(videoPath, "utf8");
} catch (err) {
  console.error(`Could not read VIDEO.json from ${botDir}: ${(err as Error).message}`);
  process.exit(1);
}

let parsed: unknown;
try {
  parsed = JSON.parse(videoJson);
} catch {
  console.error("VIDEO.json is not valid JSON.");
  process.exit(1);
}

const url =
  parsed !== null && typeof parsed === "object" && "url" in parsed
    ? (parsed as { url: unknown }).url
    : undefined;
if (typeof url !== "string" || url.length === 0) {
  console.error('VIDEO.json must be an object with a non-empty string "url".');
  process.exit(1);
}

mkdirSync(outputDir, { recursive: true });
writeFileSync(join(outputDir, "VIDEO.json"), videoJson);
console.log(`VIDEO.json handed to the grader for video: ${url}`);
