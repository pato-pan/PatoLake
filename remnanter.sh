#!/bin/bash
echo "where there is a will, there is a bread. Always remember to share"
# Create extremely small versions of video files for storage and archival reasons. YThe videos are barely watchable, in both video and audio.
# Sometimes you want to archive 100GBs worth of footage but you lack the storage, so instead of deleting it and losing it all, you can at least keep a piece that is SIGNIFICANTLY small. 600% reduction or 3876%! That is turning 1TB to only 30GBs in one folder.
# media quality ratings:
# 160x90 is good. You can tell what's happening, but sometimes it looks like nothing but smudges or you have no idea especially on a white page with text. The next ones are improvements but it's the same situation
# 192x108 you can tell there's text, and it's less glitchy=less smudges or random graphical glitches.
# 224x126 somehow looks worse and gives me a headache
# 256x144 is the sweet spot. YT knows. You can always clearly tell there is text. I am able to understand what is happening in the video, even if I can't read among other things. I know a browser window is open, or that there is a dog in the video.
# aq 0.8 = 64k
# aq 0.5 = 32k
# aq 0.4 = 24k you can barely hear background noise and voice is clear
# aq 0.3 = 16k You can't hear background noise, voice is a bit clear
# aq 0.2 = 12k You can't hear some things clearly. It's hard to make out what I am saying sometimes
# aq 0.1 = lowest
default=(-r 10.0 -c:v libx265 -crf 51 -preset slow -vf scale="256:144" -ac 1 -c:a aac -ar 32k -aq 0.3)
videobetter=(-r 10.0 -c:v libx265 -crf 51 -preset slow -vf scale="640:360" -ac 1 -c:a aac -ar 32k -aq 0.3)
variedres=(-r 10.0 -c:v libx265 -crf 51 -preset slow -vf scale="-2:360" -ac 1 -c:a aac -ar 32k -aq 0.3)
function remnanter() {
	local soy=("$@")
	for f in *.*; do
		ffmpeg -hwaccel cuda -n -i "$f" "${soy[@]}" "remnants/$f";
	done
}

cd "~/Videos/Camera/"
remnanter "${default[@]}"
cd "~/Videos/MyGameplay/"
remnanter "${videobetter[@]}"
cd "~/Videos/Youtube/"
remnanter "${variedres[@]}"
