#!/bin/bash

echo "Gathering subdomains with sublist3r..."

sublist3r -d $1 -o all.txt 
#subdomains $1 >> all.txt

#we are using pwd because we will need it later on with eyewitness
pwd=$(pwd)
#if the directory does not exist, create it!
if [ ! -d "thirdlevels" ]; then
mkdir thirdlevels
fi

if [ ! -d "scans" ]; then
mkdir scans
fi

if [ ! -d "eyewitness" ]; then
mkdir eyewitness
fi

# by default sublist3r does not add the original domain, so we need to add it manually 
echo $1 >> all.txt
echo "compiling third level domains..."

#using regex to get all the third level domains from the all.txt file

cat all.txt | grep -Po "(\w+\.\w+\.\w+)$" | sort -u >> third-level.txt

echo "Gathering full third-level domains with sublist3r..."

for domain in $(cat third-level.txt);
do
sublist3r -d $omain -o thirdlevels/$domain.txt;
cat thirdlevels/$domain.txt | sort -u >> all.txt;
done

echo "probing alive third level domains..."
cat all.txt | sort -u | httprobe -s -p https:443 | sed 's/https\?:\/\///' | tr -d ":443" > probed.txt

echo "Scanning for open ports..."
nmap -iL probed.txt -T5 -oA scans/scanned.txt

echo "Running Eyewitness..."
#sudo apt-get install eyewitness to install Eyewitness. 
eyewitness -f $pwd/probed.txt -d $1

mv /usr/share/eyewitness/$1 eyewitness/$1
