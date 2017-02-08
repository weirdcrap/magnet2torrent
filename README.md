# magnet2torrent

I wrote/tested this in about an hour to enhance the functionality of Sonarr/Radarr's torrent black hole feature to convert .magnet files (links) into a torrent file that rtorrent could natively import through my specified watch folder while preserving my custom labels, download directories, etc. If you found this script then you must already know my pain.

This loops through all the .magnet files in the directory saved in $FILES and passes them through to ih2torrent which is itself running in a python virtualenv (to prevent dependency/package conflicts) that takes the infohash or magnet url and turns it into a .torrent file that rtorrent can then import through its watch folder. 

All credit for ih2torrent goes to Elektito: https://github.com/elektito/ih2torrent
I look forward to seeing your v1.0 release with support for magnets with trackers!


# Setup
I designed and tested this script on a WhatBox slot and it works flawlessly. As long as your provider has Python3, allows you to install python packages, and allows you to create/modify/execute shell scripts this should work pretty much anywhere. The VirtualEnv is how WhatBox recommends you set things up but you should be able to accomplish the same results without it. See Elektito's GitHub above for details and requirements for ih2torrent.

If you are a WhatBox user this wiki page should cover getting pip installed and setting up VirtualEnv: https://whatbox.ca/wiki/python

This page will help you set up your rtorrent.rc file to create your watch directories: https://whatbox.ca/wiki/Editing_rtorrentrc

Modify the directories on lines 32, 34, 40, & 41 to match your setup. If you are not using VirtualEnvs you can comment out lines 40 & 45.

To automate this conversion process I setup a cronjob to run every 30 minutes and used the timeout command in Linux to keep the script from running forever. The reason for this is ih2torrent is currently trackerless and can only use the DHT protocol to resolve the metadata from other peers so if you are having trouble connecting to peers and downloading metadata or you simply have a ton of .magnet files to process this script could potentially run for hours. To prevent this my crontab is set up like so:

*/30 * * * * timeout 15m sh ~/magnet2torrent > /dev/null 2>&1

In my limited testing this has worked flawlessly and there is little danger if configured correctly (I don't want to claim there is no potential dangers) of this script causing data loss or deleting a .magnet file before it has downloaded all of the metadata for that magnet and saved the corresponding trackerless .torrent file.
