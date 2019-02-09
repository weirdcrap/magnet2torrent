#!/bin/bash
####################################################################
# Author: weirdcrap                                                #
# Mail: weirdcrap    [(at)]     protonmail [dot]  com              #
# Version: 0.4 (beta)                                              #
# Purpose:                                                         #
# I wrote/tested this to enhance the functionality
# of Sonarr/Radarr's torrent black hole feature to convert .magnet #
# files (links) into a torrent file that rtorrent could natively   #
# import through my specified watch folder while preserving my     #
# custom labels, download directories, etc.                        #
# If you found this script then you must already know my pain lol  #
#                                                                  #
# Function:                                                        # 
# This loops through all the .magnet files in the directory saved  #
# in $FILES and passes them through to aria2c which takes          #
# the infohash or magnet url and turns it into a .torrent file that#
# rtorrent can then import through its watch folder.               #
#                                                                  #
# How to use:
# 1) install aria2 (sudo apt install aria2)
# 2) Aria2c daemon should be running i.e.
# aria2c --daemon --enable-rpc=true --enable-dht --dht-listen-port=6881
# 3) make sure incomming port 6881 (TCP and UDP) is open (forwarded) on your router/firewall
# 4) Replace $DIR with the watch directory path you have
# .magnet files being saved into by sonarr/radarr/sickgear/etc.
# 5) make sure this script is executable (chmod +x magnet2torrent.sh)
# 6) add this script to cron (crontab -e)
# */1 * * * * ~/magnet2torrent/magnet2torrent.sh
####################################################################

####################################################################
# Change log:                                                      #
#  v0.1 (beta): Initial release                                    #
#  v0.2 (beta): Switched to aria2c for magnet resolution           #
#  v0.3 (Beta): Added variable to define watch directory path.     #
#  v0.4 phatpaul: check that script is not already running.
#                  don't run aria2c if no .magnet files found
####################################################################
DIR=/mnt/scratch/downloads/watch

# Make sure this script is not already running!
if pidof -x $(basename $0) > /dev/null; then
  for p in $(pidof -x $(basename $0)); do
    if [ $p -ne $$ ]; then
      echo "Script $0 is already running: exiting"
      exit
    fi
  done
fi

####################################################################
# First some general file cleanup for my sanity.                   #
# this just deletes any torrent files older than 2 days            #
# which should gave rtorrent plenty of time to have picked them up.#
####################################################################
find $DIR -name '*.torrent' -mtime +2 -exec rm {} \;

for f in $DIR/*.magnet; do # $f stores current file name
  [ -e "$f" ] || continue # fix case where no files match, but for still executes with *.magnet
  # take action on each file. 
  echo "converting $f"
  aria2c -d $DIR --bt-metadata-only=true --bt-save-metadata=true --listen-port=6881 --enable-dht --dht-listen-port=6881 $(cat "$f")
  # $(cat $f) passes file contents of file named in $f to aria2c. 
  #Torrent file is saved in $DIR folder with unique hash as file name. ex: d9c5fd7034fc2eb7efab6ddcd5bfd34ce1fe3be0.torrent

  # cleanup: removes $f.magnet from watch directory so they won't be re-processed on next cron run.
  echo "deleting $f"
  rm -f "$f" 
done

# write a status file with date of last run.  Helps troubleshoot that cron task is running.
echo "$(basename $0) last run was at $(date)" > $DIR/_$(basename $0)_lastrun.txt

