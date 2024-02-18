#!/bin/bash
# steamcmd Base Installation Script
#
# Server Files: /mnt/server
# Image to install with is 'ubuntu:18.04'
apt -y update
apt -y --no-install-recommends install curl lib32gcc1 ca-certificates

## just in case someone removed the defaults.
if [ "${STEAM_USER}" == "" ]; then
    STEAM_USER=anonymous
    STEAM_PASS=""
    STEAM_AUTH=""
fi

## download and install steamcmd
cd /tmp
mkdir -p /mnt/server/steamcmd
curl -sSL -o steamcmd.tar.gz https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz
tar -xzvf steamcmd.tar.gz -C /mnt/server/steamcmd
cd /mnt/server/steamcmd

# SteamCMD fails otherwise for some reason, even running as root.
# This is changed at the end of the install process anyways.
chown -R root:root /mnt
export HOME=/mnt/server

## install game using steamcmd
./steamcmd.sh +login ${STEAM_USER} ${STEAM_PASS} ${STEAM_AUTH} +force_install_dir /mnt/server +app_update ${SRCDS_APPID} ${EXTRA_FLAGS} +quit ## other flags may be needed depending on install. looking at you cs 1.6

## set up 32 bit libraries
mkdir -p /mnt/server/.steam/sdk32
cp -v linux32/steamclient.so ../.steam/sdk32/steamclient.so

## set up 64 bit libraries
mkdir -p /mnt/server/.steam/sdk64
cp -v linux64/steamclient.so ../.steam/sdk64/steamclient.so

# Creating needed default files for the game
cd /mnt/server/garrysmod/lua/autorun/server
echo '
-- Docs: https://wiki.garrysmod.com/page/resource/AddWorkshop
-- Place the ID of the workshop addon you want to be downloaded to people who join your server, not the collection ID
-- Use https://beta.configcreator.com/create/gmod/resources.lua to easily create a list based on your collection ID

resource.AddWorkshop( "" )
' > workshop.lua

cd /mnt/server/garrysmod/cfg
echo '
// Please do not set RCon in here, use the startup parameters.

hostname		"Zero TTT Server"
sv_password		""
sv_loadingurl   "https://www.youtube.com/embed/tiyDk_-jGAY?si=9K-3Z8FNtdVieXfh&amp;controls=0&autoplay=1"
sv_allowupload 1
sv_allowdownload 0
sv_allowcslua 0
sv_cheats 0

// Steam Server List Settings
sv_hibernate_think 0
sv_location "de"
sv_region 255
sv_lan "0"
sv_max_queries_sec_global "30000"
sv_max_queries_window "45"
sv_max_queries_sec "5"

// Server Limits
sbox_maxprops		100
sbox_maxragdolls	5
sbox_maxnpcs		10
sbox_maxballoons	10
sbox_maxeffects		10
sbox_maxdynamite	10
sbox_maxlamps		10
sbox_maxthrusters	10
sbox_maxwheels		10
sbox_maxhoverballs	10
sbox_maxvehicles	20
sbox_maxbuttons		10
sbox_maxsents		20
sbox_maxemitters	5
sbox_godmode		0
sbox_noclip		    0

// Network Settings - Please keep these set to default.

sv_minrate		75000
sv_maxrate		0
gmod_physiterations	2
net_splitpacket_maxrate	45000
decalfrequency		12 

// Execute Ban Files - Please do not edit
exec banned_ip.cfg 
exec banned_user.cfg 

// Add custom lines under here
' > server.cfg