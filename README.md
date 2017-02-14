# magnet2torrent
I wrote/tested this in about an hour to enhance the functionality of Sonarr/Radarr's torrent black hole feature to convert .magnet files (links) into a torrent file that rtorrent could natively import through my specified watch folder while preserving my custom labels, download directories, etc. If you found this script then you must already know my pain.
 
This loops through all the .magnet files in the directory saved in $FILES and passes them through to aria2c which takes the infohash or magnet url and turns it into a .torrent file that rtorrent can then import through its watch folder.

All credit for aria2c goes to the original developers: https://aria2.github.io/

# Setup
I designed and tested this script on a WhatBox slot and it works flawlessly. Place the magnet2torrent file in your home directory and modify the paths in the file to match your directory structure.

Aria2c will need to be compiled from source. I had no issues with dependencies on WhatBox when compiling. For info on compiling software on Whatbox see: https://whatbox.ca/wiki/Installing_Software

This page will help you set up your rtorrent.rc file to create your watch directories: https://whatbox.ca/wiki/Editing_rtorrentrc

To automate this conversion process I setup a cronjob to run every 5 minutes:

*/5 * * * * ~/magnet2torrent

In my limited testing this has worked flawlessly and that if configured correctly there is little danger (I don't want to claim there is no potential dangers) of this script causing data loss or deleting a .magnet file before it has downloaded all of the metadata for that magnet and saved the corresponding trackerless .torrent file.

# Bug Reports
Please use some common sense if you are going to file a bug report.

-What OS are you running and is this a dedicated server or a seedbox?
-Is the script unmodified from how I have provided it?
-Does the offending magnet link work if you put it directly into your torrent client?
