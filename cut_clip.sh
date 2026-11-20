#!/bin/bash
# Cut the GTA 6 clipper Short from Rockstar's official GTA VI Trailer 2.
# Moment chosen (one continuous chase run, trailer 138.5-152.0): helicopter over
# the swamp, jet-ski chase, Jason on his motorcycle as a plane flies low over
# him, boat chase, night wheelie, getaway car. Then the pitch over the VI logo
# and GTA VI title card (trailer 156.0-164.0). Vertical 1080x1920, 21.5s total.
# Source: trailer2_18.mp4 (official Trailer 2, YouTube ID VQRLujxTm3c, 640x360).
set -euo pipefail
cd "$(dirname "$0")"
FONT=/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf
SRC=trailer2_18.mp4
OUT=gta6-short.mp4
# Source is 640x360 but the picture is letterboxed 640x288 (rows 36-323):
# crop the picture's vertical centre (162x288 = exact 9:16) so the Short
# fills the frame with no black bars.
cat > /tmp/gta6_filter.txt <<'EOF'
[0:v]trim=138.5:152.0,setpts=PTS-STARTPTS,crop=162:288:239:36,scale=1080:1920:flags=lanczos,unsharp=5:5:0.5,eq=saturation=1.15,drawtext=fontfile=/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf:text='GTA 6 IS INSANE':fontsize=96:fontcolor=white:borderw=5:bordercolor=black:x=(w-text_w)/2:y=260:enable='between(t,0,4)'[v1];
[0:v]trim=156.0:164.0,setpts=PTS-STARTPTS,crop=162:288:239:36,scale=1080:1920:flags=lanczos,unsharp=5:5:0.5,drawtext=fontfile=/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf:text='MAKE CLIPS LIKE THIS':fontsize=64:fontcolor=white:borderw=5:bordercolor=black:x=(w-text_w)/2:y=280,drawtext=fontfile=/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf:text='WITH AI AND EARN MONEY':fontsize=64:fontcolor=white:borderw=5:bordercolor=black:x=(w-text_w)/2:y=390,drawtext=fontfile=/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf:text='ON make.fun':fontsize=110:fontcolor=#FFD60A:borderw=6:bordercolor=black:x=(w-text_w)/2:y=510,drawtext=fontfile=/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf:text='make.fun/bounty/gta6-clipper-01':fontsize=40:fontcolor=white:borderw=4:bordercolor=black:x=(w-text_w)/2:y=1560[v2];
[0:a]atrim=138.5:152.0,asetpts=PTS-STARTPTS[a1];
[0:a]atrim=156.0:164.0,asetpts=PTS-STARTPTS[a2];
[v1][v2]concat=n=2:v=1:a=0[vout];
[a1][a2]concat=n=2:v=0:a=1[aout]
EOF
ffmpeg -y -v error -i "$SRC" -filter_complex_script /tmp/gta6_filter.txt \
  -map "[vout]" -map "[aout]" \
  -c:v libx264 -crf 20 -preset medium -pix_fmt yuv420p -r 30 \
  -c:a aac -b:a 128k -movflags +faststart "$OUT"
echo "rendered $OUT"
ffprobe -v error -show_entries format=duration,size -show_entries stream=codec_type,codec_name,width,height,r_frame_rate -of default=noprint_wrappers=1 "$OUT"
ls -la "$OUT"
