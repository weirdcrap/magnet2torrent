# magnet2torrent
I wrote/tested this in about an hour to enhance the functionality of Sonarr/Radarr's torrent black hole feature to convert .magnet files (links) into a torrent file that rtorrent could natively import through my specified watch folder while preserving my custom labels, download directories, etc. If you found this script then you must already know my pain.
 
This loops through all the .magnet files in the directory saved in $FILES and passes them through to ih2torrent which is itself running in a python virtualenv (to prevent dependency/package conflicts) that takes the infohash or magnet url and turns it into a .torrent file that rtorrent can then import through its watch folder. 

All credit for ih2torrent goes to Elektito: https://github.com/elektito/ih2torrent
I look forward to seeing your v1.0 release with support for magnets with trackers!

# important notice
At this point due to ih2torrent not having support for extracting trackers from magnet links this entire script and ih2torrent depend on the proper functionality of the DHT network and the DHT network only! This may lead to this script never working properly, downloads not starting due to lack of peers, etc! Please do not file any sort of bug report or complaint with me about why your download isn't working unless you believe you have actual evidence to show that this may be caused by my small script. Any bugs or issues with ih2torrent please address them to the appropriate author/repository.

# Setup
I designed and tested this script on a WhatBox slot and it works flawlessly. As long as your provider has Python3, allows you to install python packages, and allows you to create/modify/execute shell scripts this should work pretty much anywhere. The VirtualEnv is how WhatBox recommends you set things up but you should be able to accomplish the same results without it. See Elektito's GitHub above for details and requirements for ih2torrent.

If you are a WhatBox user this wiki page should cover getting pip installed and setting up VirtualEnv: https://whatbox.ca/wiki/python

This page will help you set up your rtorrent.rc file to create your watch directories: https://whatbox.ca/wiki/Editing_rtorrentrc

Modify the directories on lines 32, 34, 40, & 41 to match your setup. If you are not using VirtualEnvs you can comment out lines 40 & 45.

To automate this conversion process I setup a cronjob to run every 30 minutes and used the timeout command in Linux to keep the script from running forever. The reason for this is ih2torrent is currently trackerless and can only use the DHT protocol to resolve the metadata from other peers so if you are having trouble connecting to peers and downloading metadata or you simply have a ton of .magnet files to process this script could potentially run for hours. To prevent this my crontab is set up like so:

*/30 * * * * timeout 15m sh ~/magnet2torrent > /dev/null 2>&1

What this does is launches the timeout process which then spawns a subprocess that executes my script and tracks how long it has been running. If the script hasn't exited on its own by the time 15 minutes is up timeout kills the script with kill -9. I do this because I assume that I will either:

A) have so many magnet links it will take hours to resolve them all so this allows the script to process the files in "chunks" so to speak since it only removes a .magnet file once it has been successfully returned from the ih2torrent process.

OR

B) DHT is having trouble resolving some of the metadata so the script is called and it can just "try again later" when there are hopefully more peers available with the data we need.

In my limited testing this has worked flawlessly and that if configured correctly there is little danger (I don't want to claim there is no potential dangers) of this script causing data loss or deleting a .magnet file before it has downloaded all of the metadata for that magnet and saved the corresponding trackerless .torrent file.

# Bug Reports
Please use some common sense if you are going to file a bug report.

-What OS are you running and is this a dedicated server or a seedbox?
-What version of python are you running?
-Is the script unmodified from how I have provided it?
-Are you running it an a virtualenv like I suggested? No? Then try that before you file a report.
-Does the offending magnet link work if you put it directly into your torrent client?
