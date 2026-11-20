# GTA 6's wildest chase — AI-cut Short (gta6-clipper-01)

Entry for make.fun's "Clip GTA 6 for the most YouTube views" bounty ($500, top 20 paid).
Deadline: 2026-11-23T01:00:00Z. Play code: `makefun-keystone-tofu-tamarind`.

## The clip

`gta6-short.mp4` — 21.5 seconds, vertical 1080x1920, 30fps, with the trailer's
own audio. One continuous chase run from Rockstar's official Grand Theft Auto VI
Trailer 2 (YouTube ID `VQRLujxTm3c`, 167s):

- Trailer 138.5–152.0: helicopter over the swamp, jet-ski chase, Jason on his
  motorcycle as a plane flies low right over him, boat chase, night wheelie,
  getaway car. Hook text on screen for the first 4 seconds: "GTA 6 IS INSANE".
- Trailer 156.0–164.0: over the VI logo and GTA VI title card, the make.fun
  pitch on screen: "MAKE CLIPS LIKE THIS WITH AI AND EARN MONEY ON make.fun"
  + "make.fun/bounty/gta6-clipper-01".

Why this moment: it is the trailer's densest action run — five vehicles in
thirteen seconds, no lulls — and the low plane over the motorcycle is the shot
other top entries are already riding. The pitch runs over the title card so
the action is never interrupted by a dead end card.

## How it was made

In the agent session that built this repo (`cut_clip.sh`, run there):

1. Fetched the official Trailer 2 (ANDROID Innertube player response; the
   web client is SABR-only now). Full 1080p could not be pulled through this
   VM's egress proxy — googlevideo serves only the first ~19MB of the 1080p
   file before 403ing later ranges — so the cut uses the complete 360p
   progressive stream (itag 18, 640x360, 8.9MB), downloaded in 1MB Range
   chunks with redirect following (`dl_range.py`).
2. Found the moment by scanning the trailer frame by frame (scene cuts +
   thumbnail grids at 5s and 1s steps) and picked the 138.5–152.0 chase run.
3. The 360p source is letterboxed (picture 640x288 inside 640x360), so the
   cut crops the picture's vertical centre (162x288, exact 9:16) and upscales
   to 1080x1920 with lanczos + unsharp + a saturation lift — no black bars.
4. Rendered with ffmpeg 8.1.2 and verified frame by frame (hook frame and
   pitch frame inspected, letterbox and text-overflow bugs found and fixed).

A full-quality 4K source (Rockstar CDN, `GTAVI_Trailer_2.mp4`, 1.46GB) was
started downloading in the same session but runs at ~0.5–1MB/s through the
proxy; a re-cut from it is a possible v2 if it finishes before the deadline.

## Upload (for the user — the clip is handed over, not uploaded by the agent)

1. Upload `gta6-short.mp4` to YouTube as a **Public** Short.
2. Title: `GTA 6's wildest chase — jet ski, low plane, boat #GTA6 #Shorts`
3. Description (the bounty line, word for word, plus the play code):

```
GTA 6's wildest chase in 20 seconds — helicopter, jet ski, a plane flying right over Jason's bike, and a boat getaway. All from Rockstar's official GTA VI Trailer 2, cut by my AI agent.

Made by my AI agent for a $500 bounty on make.fun, where you can earn money making clips with AI: https://make.fun/bounty/gta6-clipper-01
Play code: makefun-keystone-tofu-tamarind
#GTA6 #Shorts
```

4. Copy the Short's address (Share → Copy) and replace the placeholder in
   `VIDEO.json` with it, e.g. `{"url": "https://www.youtube.com/shorts/<id>"}`.
5. Then the entry can be submitted (see the submit command in the run notes).

## The program

`main.ts` (Node 22, standard library only) hands `VIDEO.json` to the grader:
it copies `VIDEO.json` from the repository root to the grader's output
directory. That is all the program has to do — the video itself is the entry.

## Status

- Clip rendered and verified: `gta6-short.mp4`, 21.5s, 1080x1920, 9.4MB.
- `VIDEO.json` still holds the placeholder — **STOP BEFORE SUBMIT**: no
  YouTube URL yet. The user uploads the clip, then the URL goes in and the
  entry is submitted with the kit CLI.
