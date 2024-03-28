#!/bin/bash

#System packages install
apt update
apt install wget curl software-properties-common python3 python3-pip unzip jq -y
add-apt-repository ppa:longsleep/golang-backports
apt update
apt install golang-go -y

#Go Tools install
go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest
go install -v github.com/tomnomnom/assetfinder@latest
go install -v github.com/tomnomnom/anew@latest
go install -v github.com/owasp-amass/amass/v4/...@master
go install -v github.com/projectdiscovery/chaos-client/cmd/chaos@latest
go install -v github.com/projectdiscovery/shuffledns/cmd/shuffledns@latest
go install -v github.com/projectdiscovery/httpx/cmd/httpx@latest
go install -v github.com/jaeles-project/gospider@latest
go install -v github.com/edoardottt/csprecon/cmd/csprecon@latest
mv ~/go/bin/* /usr/bin/

#Installing Sublist3r
pip3 install git+https://github.com/aboul3la/Sublist3r.git

#Installing Subscraper
pip3 install git+https://github.com/m8sec/subscraper.git

#Installing Findomain
curl -LO https://github.com/findomain/findomain/releases/latest/download/findomain-linux-i386.zip
unzip findomain-linux-i386.zip -d findomain
chmod +x findomain/findomain
cp findomain/findomain /usr/bin/
rm -rf findomain/ findomain-linux-i386.zip

#Installing Massdns (Used for ShuffleDNS)
git clone https://github.com/blechschmidt/massdns.git
cd massdns
make
cp bin/massdns /usr/bin
cd .. && rm -rf massdns/
