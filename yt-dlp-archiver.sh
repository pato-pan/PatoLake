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
frugal='--sub-langs all,-live_chat,-rechat -S +size,+br,+res,+fps --audio-format aac --audio-quality 32k' #note to self: don't use -f "wv*[height<=240]+wa*"
bestanometa=(--embed-thumbnail --embed-chapters -x -c -f ba --audio-format best --audio-quality 0)
#prevents your account from getting unavailable on all videos, even when watching, when using cookies.txt. This is not foolproof, and it's not necessary in many cases. Recommended when making giant downloads (2k requests in my experience)
#antiban='--sleep-requests 1.5 --min-sleep-interval 60 --max-sleep-interval 90' # Depending on many videos you have to download, this is safer but it can take hours. In my case, 5 hours.
antiban='--sleep-requests 0.5 --min-sleep-interval 3 --max-sleep-interval 30' # My version, much faster, higher risk. Based on my usual timeouts
#antiban=''

probeset=(-v error -select_streams a:0 -of csv=p=0 -show_entries stream=codec_name)
mpegset=(-n -c:v copy -c:a aac)
# mpegset=(-n -c:v copy -c:a flac --compression-level 12) # better quality, significantly higher filesize

# This command will run after you finish downloading all the files in a parent directory.
function conveac3() {
	local parent="$1"
 	for f in "$parent/"*.m4a; do
  		if [[ $(ffprobe "${probeset[@]}" "$f" | awk -F, '{print $1}') == "eac3" ]]; then # checks if video is eac3
			mkdir compat
			id=${f%]*} # removes everything after the last ]
   			id=${id##*[} # removes everything before the last [
      			if grep -Fxq "$f" "$idlists/conveac3.txt"; then # checks if the file has already been converted
				:
    			else
   				yt-dlp $antiban --force-overwrites "${bestanometa[@]}" $id -o "$dori/$nameformat"
       				#ffmpeg -i "$f" "${mpegset[@]}" compat/"${f%.m4a}".flac
				ffmpeg -i "$f" "${mpegset[@]}" compat/"${f%.m4a}".m4a #I know adding m4a here is redundant. It should only be just $f instead. This is only here for consistency.
    				# left overs from yt-dlp errors. Always the case when --embed-metadata is used on a eac3 file.
				rm "${f%%.*}.temp.m4a"
				rm "${f%%.*}.webp"
    				echo "$f" >> "$idlists/conveac3.txt" # adds file to the conversion archive. Equivalent to yt-dlp's download archive. Necessary because in yt-dlp you can't specify the directory of the download archive without cd'ing into it, and I don't want to redownload the files every time the script is run.
    			fi
		fi
	done
	if [ parentdone != "yes" ]; then parentdone="yes"; # Prevents an infinite loop, this part only runs once. Necessary when the function will call itself, but this time it will run in a different folder.
		for folder in "${parent}"/*; do # recursively runs the conversion in every subfolder
			if [ -d "${folder}" ]; then conveac3 "$folder"; fi
		done
	fi
}
function frugalizer() { # provides a video of much lower filesize than remnant.
	local parent="$1"
	echo "compressing videos even further"
 	for f in "$parent/"*.*; do
  		filename=${f##*\/} # removes everything before the last / to get the filename.
		if grep -Fxq "$f" "$idlists/frugal.txt"; then # checks if the file has already been converted
			:
		else
			mkdir "$parent/temp"
			ffmpeg -hwaccel cuda -i "$f" -y -c:v libx265 -r 10.0 -b:v 2k -maxrate 5k -minrate 0 -preset slow -c:a aac -b:a 32k -ar 32k "$parent/temp/$filename"
		fi
		echo "$f" >> "$idlists/frugal.txt"
 	done
 	mv -f "$parent/temp/"* "$parent/"
	rm -r "$parent/temp/"
}

cd $idlists
#yt-dlp -U
# --no-check-certificate
#read -n 1 -t 30 -s
echo downloading MyMusic Playlist
read -n 1 -t 3 -s
yt-dlp $antiban --download-archive mymusic.txt --yes-playlist $besta $ytlist"PLmxPrb5Gys4cSHD1c9XtiAHO3FCqsr1OP" -o "$Music/YT/$nameformat"
mkdir "$Music/YT/thumbs"; mv "$Music/YT/"*.webp "$Music/YT/thumbs/"
echo "Creating compatibility for eac3"
parentdone=""
conveac3 "$Music/YT/"
echo downloading Gaming Music
yt-dlp $antiban --download-archive gamingmusic.txt --yes-playlist $besta $ytlist"PL00nN9ot3iD8DbeEIvGNml5A9aAOkXaIt" $ytlist"PLbk0w-b2PpkdWRITIHO9AnNRaXTTxsKSK" -o "$Music/YTGaming/$nameformat"
mkdir "$Music/YTGaming/thumbs"; mv "$Music/YTGaming/"*.webp "$Music/YTGaming/thumbs/"
echo "Creating compatibility for eac3"
parentdone=""
conveac3 "$Music/YTGaming/"
echo "finished the music!"
read -n 1 -t 3 -s

# ////////////////////////////////////////////////

## add songs that you got outside of youtube after --reject-title. No commas, just space and ""

echo downloading some collections
read -n 1 -t 3 -s
echo funny videos from reddit
read -n 1 -t 3 -s
yt-dlp $antiban --download-archive funnyreddit.txt --yes-playlist $bestv $ytlist"PL3hSzXlZKYpM8XhxS0v7v4SB2aWLeCcUj" -o "$Videos/funnyreddit/$nameformat"
mkdir "Videos/funnyreddit/thumbs"; mv "$Videos/funnyreddit/"*.webp "$Videos/funnyreddit/thumbs/"
echo Dance practice
read -n 1 -t 3 -s
yt-dlp $antiban --download-archive willit.txt --yes-playlist $bestv $ytlist"PL1F2E2EF37B160E82" -o "$Videos/Dance Practice/$nameformat"
mkdir "$Videos/Dance Practice/thumbs"; mv "$Videos/Dance Practice/"*.webp "$Videos/Dance Practice/thumbs/"
echo Soundux Soundboard
read -n 1 -t 3 -s
yt-dlp $antiban --download-archive soundboard.txt --yes-playlist $bestmp3 $ytlist"PLVOrGcOh_6kXwPvLDl-Jke3iq3j9JQDPB" -o "$Music/soundboard/$nameformat"
mkdir "$Music/soundboard/thumbs"; mv "$Music/soundboard/"*.webp "$Music/soundboard/thumbs/"
echo Videos to send as a message
read -n 1 -t 3 -s
yt-dlp $antiban --download-archive fweapons.txt $bestv --recode-video mp4 $ytlist"PLE3oUPGlbxnK516pl4i256e4Nx4j2qL2c" -o "$Videos/forumweapons/$nameformat" #alternatively -S ext:mp4:m4a or -f "bv*[ext=mp4]+ba[ext=m4a]/b[ext=mp4] / bv*+ba/b"
mkdir "$Videos/fweapons/thumbs"; mv "$Videos/fweapons/"*.webp "$Videos/fweapons/thumbs/"
echo Podcast Episodes
read -n 1 -t 3 -s
yt-dlp $antiban --download-archive podcast.txt $audiolite $ytlist"PLJkXhqcWoCzL-p07DJh_f7JHQBFTVIg-o" -o "$Music/Podcasts/$nameformat"
mkdir "$Music/Podcasts/thumbs"; mv "$Music/Podcasts/"*.webp "$Music/Podcasts/thumbs/"

echo "archiving playlists"
cd ~/Documents/idlists/YTArchive/
echo "liked videos, requires cookies.txt"
yt-dlp $antiban --download-archive likes.txt --yes-playlist $frugal $ytlist"LL" -o "$Videos/Archives/Liked Videos/$nameformat"
mkdir "$Videos/Archives/Liked Videos/thumbs"; mv "$Videos/Archives/Liked Videos/"*.webp "$Videos/Archives/Liked Videos/thumbs/"
echo "Will it? by Good Mythical Morning"
yt-dlp $antiban --download-archive willit.txt --yes-playlist $v480p $ytlist"PLJ49NV73ttrucP6jJ1gjSqHmhlmvkdZuf" -o "$Videos/Archives/Will it - Good Mythical Morning/$nameformat"
mkdir "$Videos/Archives/Will it - Good Mythical Morning/thumbs"; mv "$Videos/Archives/Will it - Good Mythical Morning/"*.webp "$Videos/Archives/Will it - Good Mythical Morning/thumbs/"

echo "archiving channels"
echo "HealthyGamerGG"
yt-dlp $antiban --download-archive HealthyGamerGG.txt --match-filter '!is_live & !was_live & is_live != true & was_live != true & live_status != was_live & live_status != is_live & live_status != post_live & live_status != is_upcoming & original_url!*=/shorts/ & title ~= (?i)@|w/|ft.|interviews & view_count >=? 60000' --dateafter 20200221 $frugal $ytchannel"UClHVl2N3jPEbkNJVx-ItQIQ/videos" -o "$Videos/Archives/HealthyGamerGG/$nameformat"
mkdir "$Videos/Archives/HealthyGamerGG/thumbs"; mv "$Videos/Archives/HealthyGamerGG/"*.webp "$Videos/Archives/HealthyGamerGG/thumbs/"
remnanter "$Videos/Archives/HealthyGamerGG"
echo "Veritasium"
yt-dlp $antiban --download-archive veritasium.txt --match-filter '!is_live & !was_live & is_live != true & was_live != true & live_status != was_live & live_status != is_live & live_status != post_live & live_status != is_upcoming & view_count >=? 1000000' $frugal $ytchannel"UCHnyfMqiRRG1u-2MsSQLbXA" -o "$Videos/Archives/veritasium/$nameformat"
mkdir "$Videos/Archives/veritasium/thumbs"; mv "$Videos/Archives/veritasium/"*.webp "$Videos/Archives/veritasium/thumbs/"
echo "JCS"
yt-dlp $antiban --download-archive JCS.txt --match-filter '!is_live & !was_live & is_live != true & was_live != true & live_status != was_live & live_status != is_live & live_status != post_live & live_status != is_upcoming' $v480p $ytchannel"UCYwVxWpjeKFWwu8TML-Te9A" -o "$Videos/Archives/JCS/$nameformat"
mkdir "$Videos/Archives/JCS/thumbs"; mv "$Videos/Archives/JCS/"*.webp "$Videos/Archives/JCS/thumbs/"
echo "Creating compatibility for eac3"
parentdone=""
conveac3 "$Show/Videos/Archives"

echo "it's done!"
read -n 1 -t 30 -s
exit

# (not used, untested) --match-filter "duration < 3600" exclude videos that are over one hour
# (not used, untested) --match-filter "duration > 120" exclude videos that are under 2 minutes
