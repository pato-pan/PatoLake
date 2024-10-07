#!/bin/bash
echo "where there is a will, there is a bread. Always remember to share"
echo "Hey. Please remember to manually make a backup of the descriptions of the playlists" # I had a false scare before only to find out it's a browser issue, but I still don't trust google regardless.
idlists="~/Documents/idlists" # where all the lists of all downloaded ids are located.
nameformat="%(title)s - %(uploader)s [%(id)s].%(ext)s"
Music="~/Music"
Videos="~/Videos"
ytlist="https://www.youtube.com/playlist?list="
ytchannel="https://www.youtube.com/channel/"
default='--cookies cookies.txt --embed-metadata --embed-thumbnail --embed-chapters -c  --write-thumbnail'
besta='-x -f ba --audio-format best --audio-quality 0'
bestmp3='-x -f ba --audio-format mp3 --audio-quality 0'
audiolite='-x --audio-format mp3 --audio-quality 64k'
bestv='--sub-langs all,-live_chat,-rechat'
v1080p='--sub-langs all,-live_chat,-rechat -f bv*[height<=1080]+ba/b[height<=1080]'
v720p='--sub-langs all,-live_chat,-rechat -f bv*[height<=720]+ba/b[height<=720]'
v480p='--sub-langs all,-live_chat,-rechat -f bv*[height<=480]+ba/b[height<=480]' # I prefer 360p as lowest, but some videos may not offer 360p, so I go for 480p to play it safe
frugal='--cookies cookies.txt --embed-metadata --embed-thumbnail --embed-chapters --sub-langs all,-live_chat,-rechat -S +size,+br,+res,+fps --audio-format aac --audio-quality 32k -c' #note to self: don't use -f "wv*[height<=240]+wa*"
bestanometa=(--embed-thumbnail --embed-chapters -x -c -f ba --audio-format best --audio-quality 0)
#prevents your account from getting unavailable on all videos, even when watching, when using cookies.txt. This is not foolproof, and it's not necessary in many cases. Recommended when making giant downloads (2k requests in my experience)
#antiban='--sleep-requests 1.5 --min-sleep-interval 60 --max-sleep-interval 90' # Depending on many videos you have to download, this is safer but it can take hours. In my case, 5 hours.
antiban='--sleep-requests 1.5 --min-sleep-interval 3 --max-sleep-interval 30' # My version, much faster, higher risk, untested. Based on my usual timeouts
#antiban=''
probeset=(-v error -select_streams a:0 -of csv=p=0 -show_entries stream=codec_name)
mpegset=(-n -c:v copy -c:a aac)
# mpegset=(-n -c:v copy -c:a flac --compression-level 12) # better quality, significantly higher filesize

# This command will run after you finish downloading all the files in a parent directory.
function compateac3() {
	local parent="$1"
	if [ isparent != "yes" ]; then # runs the conversion on the parent folder.
		cd "$parent"
		conveac3
		isparent="yes"
	fi
	for folder in "${parent}"/*; do # recursively runs the conversion in every subfolder
		if [ -d "${folder}" ]; then
			echo "$folder"
			cd "$folder"
			conveac3
			compateac3 "$folder"
		fi
	done
}
function conveac3() {
    for f in *.m4a; do
		if [[ $(ffprobe "${probeset[@]}" "$f" | awk -F, '{print $1}') == "eac3" ]]; then
			mkdir compat
			id=$f
			count="${f//[^[]}"
			for c in $(seq ${#count}); do id=${id#*[}; done; # removes everything before the last [
			count="${f//[^\]]}"
			for c in $(seq ${#count}); do id=${id%]*}; done;  # removes everything after the last ]. unnecessary. only helps if I change the name format. usually and preferably, just id=${f%]*} instead and do it above the removal of [
			yt-dlp $antiban --force-overwrites "${bestanometa[@]}" $id -o "$nameformat"
#			ffmpeg -i "$f" "${mpegset[@]}" compat/"${f%.m4a}".flac
			ffmpeg -i "$f" "${mpegset[@]}" compat/"${f%.m4a}".m4a #I know adding m4a here is redundant. It should only be just $f instead. This is only here for consistency.
			rm "${f%%.*}.temp.m4a"
			rm "${f%%.*}.webp"
		fi
	done
}

cd $idlists
#yt-dlp -U
# --no-check-certificate
#read -n 1 -t 30 -s
echo downloading MyMusic Playlist
read -n 1 -t 3 -s
yt-dlp $antiban --download-archive mymusic.txt --yes-playlist $besta $ytlist"PLmxPrb5Gys4cSHD1c9XtiAHO3FCqsr1OP" -o "$Music/YT/$nameformat"
echo downloading Gaming Music
read -n 1 -t 3 -s
yt-dlp $antiban --download-archive gamingmusic.txt --yes-playlist $besta $ytlist"PL00nN9ot3iD8DbeEIvGNml5A9aAOkXaIt" -o "$Music/YTGaming/$nameformat"
echo "finished the music!"
read -n 1 -t 3 -s
echo "Creating compatibility for eac3"
parent="$Music"
isparent=""
compateac3 "$parent"

# ////////////////////////////////////////////////

## add songs that you got outside of youtube after --reject-title. No commas, just space and ""

echo downloading some collections
read -n 1 -t 3 -s
echo funny videos from reddit
read -n 1 -t 3 -s
yt-dlp $antiban --download-archive funnyreddit.txt --yes-playlist $bestv $ytlist"PL3hSzXlZKYpM8XhxS0v7v4SB2aWLeCcUj" -o "$Videos/funnyreddit/$nameformat"
echo Dance practice
read -n 1 -t 3 -s
yt-dlp $antiban --download-archive willit.txt --yes-playlist $bestv $ytlist"PL1F2E2EF37B160E82" -o "$Videos/Dance Practice/$nameformat"
echo Soundux Soundboard
read -n 1 -t 3 -s
yt-dlp $antiban --download-archive soundboard.txt --yes-playlist $bestmp3 $ytlist"PLVOrGcOh_6kXwPvLDl-Jke3iq3j9JQDPB" -o "$Music/soundboard/$nameformat"
echo Videos to send as a message
read -n 1 -t 3 -s
yt-dlp $antiban --download-archive fweapons.txt $bestv --recode-video mp4 $ytlist"PLE3oUPGlbxnK516pl4i256e4Nx4j2qL2c" -o "$Videos/forumweapons/$nameformat" #alternatively -S ext:mp4:m4a or -f "bv*[ext=mp4]+ba[ext=m4a]/b[ext=mp4] / bv*+ba/b"
echo Podcast Episodes
read -n 1 -t 3 -s
yt-dlp $antiban --download-archive QChat_R.txt $audiolite $ytlist"PLJkXhqcWoCzL-p07DJh_f7JHQBFTVIg-o" -o "$Music/Podcasts/$nameformat"

echo "archiving playlists"
cd ~/Documents/idlists/YTArchive/
echo "liked videos, requires cookies.txt"
yt-dlp $antiban --download-archive likes.txt --yes-playlist $frugal $ytlist"LL" -o "$Videos/Archives/Liked Videos/$nameformat"
echo "Will it? by Good Mythical Morning"
yt-dlp $antiban --download-archive willit.txt --yes-playlist $videolite $ytlist"PLJ49NV73ttrucP6jJ1gjSqHmhlmvkdZuf" -o "$Videos/Archives/Will it - Good Mythical Morning/$nameformat"

echo "archiving channels"
echo "HealthyGamerGG"
yt-dlp $antiban --download-archive HealthyGamerGG.txt --match-filter '!is_live & !was_live & is_live != true & was_live != true & live_status != was_live & live_status != is_live & live_status != post_live & live_status != is_upcoming & original_url!*=/shorts/' --dateafter 20200221 $frugal $ytchannel"UClHVl2N3jPEbkNJVx-ItQIQ/videos" -o "$Videos/Archives/HealthyGamerGG/$nameformat"
echo "Daniel Hentschel"
yt-dlp $antiban --download-archive DanHentschel.txt --match-filter '!is_live & !was_live & is_live != true & was_live != true & live_status != was_live & live_status != is_live & live_status != post_live & live_status != is_upcoming & view_count >=? 60000' $frugal $ytchannel"UCYMKvKclvVtQZbLrV2v-_5g" -o "$Videos/Archives/Daniel Hentschel/$nameformat"
echo "JCS"
yt-dlp $antiban --download-archive JCS.txt --match-filter '!is_live & !was_live & is_live != true & was_live != true & live_status != was_live & live_status != is_live & live_status != post_live & live_status != is_upcoming' $videolite $ytchannel"UCYwVxWpjeKFWwu8TML-Te9A" -o "$Videos/Archives/JCS/$nameformat"
echo "Creating compatibility for eac3"parent="$Show/Videos/Archives"
isparent=""
compateac3 "$parent"

echo "it's done!"
read -n 1 -t 30 -s
exit

# (not used, untested) --match-filter "duration < 3600" exclude videos that are over one hour
# (not used, untested) --match-filter "duration > 120" exclude videos that are under 2 minutes
