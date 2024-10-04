This is the yt-dlp bash script I had been using for years to archive channels and youtube playlists, and also build my music collection. I had recently significantly updated it to make it much easier to update the options and also automatically handle some operations. There are plenty of times where I am watching a video and I recognize that some of these things are going to be gone soon. It's very often for videos to go missing sometimes shortly after they are uploaded or shortly after I add it to the playlist. Just recently, a channel I really enjoyed got terminated for copyright. This is why I made this, and it's run every time I start my computer.

I am sharing this as an example or guide for people who wish to do the same.

***where there is a will, there is a bread. Always remember to share***

    #!/bin/bash
    echo "where there is a will, there is a bread. Always remember to share"
    echo "Hey. Please remember to manually make a backup of the descriptions of the playlists" # I had a false scare before only to find out it's a browser issue, but I still don't trust google regardless.
    idlists="~/Documents/idlists" # where all the lists of all downloaded ids are located.
    nameformat="%(title)s - %(uploader)s [%(id)s].%(ext)s"
    Music="~/Music"
    Videos="~/Videos"
    ytlist="https://www.youtube.com/playlist?list="
    ytchannel="https://www.youtube.com/channel/"
    besta='--cookies cookies.txt --geo-bypass --embed-metadata --embed-thumbnail --embed-chapters -x -c -f ba --audio-format best --audio-quality 0'
    bestmp3='--cookies cookies.txt --geo-bypass --embed-metadata --embed-thumbnail --embed-chapters -x -c -f ba --audio-format mp3 --audio-quality 0'
    bestv='--cookies cookies.txt --geo-bypass --embed-metadata --embed-thumbnail --sub-langs all,-live_chat,-rechat --embed-chapters -c'
    audiolite='--cookies cookies.txt --geo-bypass --embed-metadata --embed-thumbnail --embed-chapters -x -c --audio-format mp3 --audio-quality 96k'
    videolite='--cookies cookies.txt --geo-bypass --embed-metadata --embed-thumbnail --embed-chapters --sub-langs all,-live_chat,-rechat -f -f bv*[height<=480]+ba/b[height<=480] -c' # I prefer 360p as lowest, but some videos may not offer 360p, so I go for 480p to play it safe
    frugal='--cookies cookies.txt --geo-bypass --embed-metadata --embed-thumbnail --embed-chapters --sub-langs all,-live_chat,-rechat -S +size,+br,+res,+fps --audio-format aac --audio-quality 32k -c' #note to self: don't use -f "wv*[height<=240]+wa*"
    bestanometa=(--geo-bypass --embed-thumbnail --embed-chapters -x -c -f ba --audio-format best --audio-quality 0)
    cd $idlists
    
    #yt-dlp -U
    # --no-check-certificate
    #read -n 1 -t 30 -s
    echo downloading MyMusic Playlist
    yt-dlp --download-archive mymusic.txt --yes-playlist $besta $ytlist"PLmxPrb5Gys4cSHD1c9XtiAHO3FCqsr1OP" -o "$Music/YT/$nameformat"
    read -n 1 -t 3 -s
    echo downloading Gaming Music
    yt-dlp --download-archive gamingmusic.txt --yes-playlist $besta $ytlist"PL00nN9ot3iD8DbeEIvGNml5A9aAOkXaIt" -o "$Music/YTGaming/$nameformat"
    echo "finished the music!"
    read -n 1 -t 3 -s
    
    # ////////////////////////////////////////////////
    
    ## add songs that you got outside of youtube after --reject-title. No commas, just space and ""
    
    echo downloading some collections
    read -n 1 -t 3 -s
    echo funny videos from reddit
    yt-dlp --download-archive funnyreddit.txt --yes-playlist $bestv $ytlist"PL3hSzXlZKYpM8XhxS0v7v4SB2aWLeCcUj" -o "$Videos/funnyreddit/$nameformat"
    read -n 1 -t 3 -s
    echo Dance practice
    yt-dlp --download-archive willit.txt --yes-playlist $bestv $ytlist"PL1F2E2EF37B160E82" -o "$Videos/Dance Practice/$nameformat"
    read -n 1 -t 3 -s
    echo Soundux Soundboard
    yt-dlp --download-archive soundboard.txt --yes-playlist $bestmp3 $ytlist"PLVOrGcOh_6kXwPvLDl-Jke3iq3j9JQDPB" -o "$Music/soundboard/$nameformat"
    read -n 1 -t 3 -s
    echo Videos to send as a message
    yt-dlp --download-archive fweapons.txt $bestv --recode-video mp4 $ytlist"PLE3oUPGlbxnK516pl4i256e4Nx4j2qL2c" -o "$Videos/forumweapons/$nameformat" #alternatively -S ext:mp4:m4a or -f "bv*[ext=mp4]+ba[ext=m4a]/b[ext=mp4] / bv*+ba/b"
    read -n 1 -t 180 -s
    echo Podcast Episodes
    read -n 1 -t 3 -s
    yt-dlp --download-archive QChat_R.txt $audiolite $ytlist"PLJkXhqcWoCzL-p07DJh_f7JHQBFTVIg-o" -o "$Music/Podcasts/$nameformat"
    
    echo "archiving playlists"
    cd ~/Documents/idlists/YTArchive/
    echo "liked videos, requires cookies.txt"
    yt-dlp --download-archive likes.txt --yes-playlist $frugal $ytlist"LL" -o "$Videos/Archives/Liked Videos/$nameformat"
    echo "Will it? by Good Mythical Morning"
    yt-dlp --download-archive willit.txt --yes-playlist $videolite $ytlist"PLJ49NV73ttrucP6jJ1gjSqHmhlmvkdZuf" -o "$Videos/Archives/Will it - Good Mythical Morning/$nameformat"
    
    echo "archiving channels"
    echo "HealthyGamerGG"
    yt-dlp --download-archive HealthyGamerGG.txt --match-filter '!is_live & !was_live & is_live != true & was_live != true & live_status != was_live & live_status != is_live & live_status != post_live & live_status != is_upcoming & original_url!*=/shorts/' --dateafter 20200221 $frugal $ytchannel"UClHVl2N3jPEbkNJVx-ItQIQ/videos" -o "$Videos/Archives/HealthyGamerGG/$nameformat"
    echo "Daniel Hentschel"
    yt-dlp --download-archive DanHentschel.txt --match-filter '!is_live & !was_live & is_live != true & was_live != true & live_status != was_live & live_status != is_live & live_status != post_live & live_status != is_upcoming & view_count >=? 60000' $frugal $ytchannel"UCYMKvKclvVtQZbLrV2v-_5g" -o "$Videos/Archives/Daniel Hentschel/$nameformat"
    echo "JCS"
    yt-dlp --download-archive JCS.txt --match-filter '!is_live & !was_live & is_live != true & was_live != true & live_status != was_live & live_status != is_live & live_status != post_live & live_status != is_upcoming' $videolite $ytchannel"UCYwVxWpjeKFWwu8TML-Te9A" -o "$Videos/Archives/JCS/$nameformat"
    
    echo "Finally. The last step is to create compatibility for some codecs (not extensions or containers, codecs)"
    read -n 1 -t 30 -s
    
    echo "Create compatibility for eac3"
    #note: flaw. Videos will be redownloaded unnecessarily.
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
    yt-dlp --force-overwrites "${bestanometa[@]}" $id -o "$nameformat"
    #ffmpeg -i "$f" "${mpegset[@]}" compat/"${f%.m4a}".flac # better quality, significantly higher filesize
    ffmpeg -i "$f" "${mpegset[@]}" compat/"${f%.m4a}".m4a #I know adding m4a here is redundant. It should only be just $f instead. This is only here for consistency.
    rm "${f%%.*}.temp.m4a"
    rm "${f%%.*}.webp"
    fi
    done
    }
    
    probeset=(-v error -select_streams a:0 -of csv=p=0 -show_entries stream=codec_name)
    mpegset=(-n -c:v copy -c:a aac)
    parent="$Music/"
    isparent=""
    compateac3 "$parent"
    parent="$Show/Videos/Archives"
    isparent=""
    compateac3 "$parent"
    
    echo "it's done!"
    read -n 1 -t 30 -s
    exit
    
    # (not used, untested) --match-filter "duration < 3600" exclude videos that are over one hour
    # (not used, untested) --match-filter "duration > 120" exclude videos that are under 2 minutes

The only things I didn't explain are

* f is file as a rule of thumb.
* --cookies allows you to download private videos you have access to (including your own) and bypass vpn/geographic blocking and content warnings. Feel free to remove this option or take a different approach, since how well this works tends to change overtime. Youtube is volatile.
   * You are currently required to get a cookies.txt in an incognito tab for this to work indefinitely.
* ytchannel currently expects a channel id rather than usernames as used today. I prefer IDs because they are consistent, never changing, and have less issues. The channel id is in the page source under "channelId": but if you don't care to find it, just copy the entire url and forget the variable.
   * I chose variables because I used to forget what the url for channel id and playlists, and to make the script smaller.
* Wiz is where you are storing your download archives. The --download-archive is used to avoid downloading the same video multiple times. While sure, by default yt-dlp won't overwrite, it will still redownload the files if the title, channel name(commonly), or something else in your output template/naming format is changed. It's only downside is that it won't redownload a video that you delete. For everything else you don't understand, consider going to the github page.
* I think it's better to download than compress, rather than have yt-dlp download the lowest size, but this is less straightforward. If you want to implement this on your own script, here's my compression script I use for other purposes that you can modify as you wish (warning: it makes the video unwatchable) `for f in *.*; do ffmpeg -n -i "$f" -r 10.0 -c:v libx264 -crf 51 -preset veryfast -vf scale="-2:360" -ac 1 -c:a aac -ar 32k -aq 0.3 "folder/$f"; done` for worse `for f in *.*; do ffmpeg -n -i "$f" -r 10.0 -c:v libx265 -crf 51 -preset veryfast -vf scale="-2:144" -ac 1 -c:a aac -ar 32k -aq 0.3 "folder/$f"; done` (-2 is required since resolutions can vary)
* The metadata of the file, if --embed-metadata is used, should contain the video url under the comment field. This is something you may be able to use instead of relying on the filename like I did, I personally couldn't because eac3 files don't work with this option. See my [issue](https://github.com/yt-dlp/yt-dlp/issues/11122)
* Sometimes, you have to use " as opposed to '. This is usually the case when your command for your variable (or something else) has to also use either one of those. See the videolite variable. If you can't use either, maybe create a function instead? use \\ to escape character if possible. The alternative really depends in the situation. For yt-dlp options, my rule of thumb is to use ', but for everything else I use "" (note: "" and '' are not the same)
* I use read to make the script wait the amount of time I enter there. It's the same as timeout on Windows (but worse, imo). This is important to diagnose problems in the script that I detect. Ideally, it's better to pipe it to a file (yt-dlp-archiver.sh > ytdlp.log), but there is no need to open the file if you catch the error while it's running. Remove if you don't need it.
* Match filters so far
   * `!is_live & !was_live & is_live != true & was_live != true & live_status != was_live & live_status != is_live & live_status != post_live & live_status != is_upcoming` excludes livestreams.Use the filter to exclude videos over x time to make sure. Initially taken from [https://www.reddit.com/r/youtubedl/comments/nye5a2/comment/h2ynbx1/](https://www.reddit.com/r/youtubedl/comments/nye5a2/comment/h2ynbx1/), but I had to update it. This could be shorter but the length is only for extra measure. I'll share update this post at some point in the future with a shorter version, excluding livestreams is currently not something I had fully tested.
   * `original_url!*=/shorts/` - excludes shorts.
   * Add "/videos" at the end of your channel id to exclude both shorts and livestreams. I still use the match filter to ensure it works and survive the test of time (a.k.a youtube updates)
   * (not used, untested) `--match-filter "duration < 3600"` exclude videos that are over one hour
   * (not used, untested) `--match-filter "duration > 120"` exclude videos that are under 2 minutes
   * I chose against duration filters because it will get false positives and my use case would be too personal/specific to publicly present it. I would use the "over one hour" duration to exclude channels that rarely upload their vods as videos or rarely decide to make really long videos I just don't want to archive. (Example: Music artists that upload mixes/long albums. I prefer setting it to 2 hours because I still want albums)
* I use --sub-langs all,-live\_chat,-rechat as opposed to --embed-subs because I need to exclude livestream chat. embedding livestream chat tends to: make the whole download fail, make other embeds not embed, leave residuals files in the folder causing clutter. For my use case, I never care to archive stream chat.
* **You can get rate limited/blocked if you use a cookies.txt.** I can't even watch youtube videos on the browser, but it only affects the brand account rather than every account under my email or my ip address. I believe I did download over 2k videos without an issue though. This should only last for less than 2 hours.

Honestly, the compatibility section is the main reason I wanted to share this. I was having a lot of trouble figuring out how to do this. Some of the things you can learn from this script include: parameter expansion, finding the codec of an audio file with ffprobe, using variables inside a for loop (variable=value is unpredictable, export variable=value is not recommended. You should do it the way presented here), counting the amount of times a character appears in the filename, how to create and use functions, best yt-dlp settings for best audio, best video, decent quality video, lower quality audio(consider 64k and 32k values too if storage is dire), and lowest filesize, etc. I am somewhat embarrassed because I already had some of the knowledge shown here, but my lack of familiarity prevented me from implementing it sooner.

Nothing here is rocket science.

special thanks to: u/minecrafter1OOO, u/KlePu, u/sorpigal, u/hheimbuerger, and u/vegansgetsick for the help
