#!/bin/bash
echo "where there is a will, there is a bread. Always remember to share"
#untested
#160x90 is good. You can tell what's happening, but sometimes it looks like nothing but smudges or you have no idea especially on a white page with text. The next ones are improvements but it's the same situation
# 192x108 you can tell there's text, and it's less buggy.
# 224x126 somehow looks worse and gives me a headache
# 256x144 is the sweet spot. YT knows
# aq 0.8 = 64k
# aq 0.5 = 32k
# aq 0.4 = 24k you can barely hear background noise and voice is clear
# aq 0.3 = 16k You can't hear background noise, voice is a bit clear
# aq 0.2 = 12k You can't hear some things clearly. It's hard to make out what I am saying sometimes
# aq 0.1 = lowest
#default="-r 10.0 -c:v libx265 -crf 51 -preset slow -vf scale="256:144" -ac 1 -c:a aac -ar 32k -aq 0.3"
#videobetter="-r 10.0 -c:v libx265 -crf 51 -preset slow -vf scale="640:360" -ac 1 -c:a aac -ar 32k -aq 0.3"
#inconsistentres="-r 10.0 -c:v libx265 -crf 51 -preset slow -vf scale="-2:360" -ac 1 -c:a aac -ar 32k -aq 0.3"
# Note: I considered turning this into variables, but through yt-dlp-archiver.sh I learned that variables have unpredictable behavior when used either in for or if statements. So, this is postponed.

This script will go through a major rewrite so it's in progress and unfinished, the actual commands aren't even here
