#!/bin/bash

### Helper
if [ $# -eq 0 ]
  then
    echo -e "Dominio não inserido"
    echo -e "Metódo de uso: ./frogy.sh example.com"
    exit
fi

org=$1
domain_name=$1
cdir=`echo $org | tr '[:upper:]' '[:lower:]'| tr " " "_"`
cwhois=`echo $org | tr " " "+"`
webports="80,443,81,82,88,135,143,300,554,591,593,832,902,981,993,1010,1024,1311,2077,2079,2082,2083,2086,2087,2095,2096,2222,2480,3000,3128,3306,3333,3389,4243,4443,4567,4711,4712,4993,5000,5001,5060,5104,5108,5357,5432,5800,5985,6379,6543,7000,7170,7396,7474,7547,8000,8001,8008,8014,8042,8069,8080,8081,8083,8085,8088,8089,8090,8091,8118,8123,8172,8181,8222,8243,8280,8281,8333,8443,8500,8834,8880,8888,8983,9000,9043,9060,9080,9090,9091,9100,9200,9443,9800,9981,9999,10000,10443,12345,12443,16080,18091,18092,20720,28017,49152"


if [[ -d output ]]
then
        :
else
        mkdir output
fi
if [[ -d output/$cdir ]]
then
        echo -e "Criando o diretório '$org' para armazenar os resultados na pasta 'output'..."
        rm -r -f output/$cdir
else
        echo -e "Criando o diretório '$org' para armazenar os resultados na pasta 'output'..."
        mkdir output/$cdir
fi


### Subfinder Enum
subfinder -d $domain_name --all --silent >> output/$cdir/subfinder.txtls

### Chaos API KEY

chaos -silent -d $domain_name -key $CHAOS_KEY | anew output/$cdir/chaos.txtls

### Amass Enum
amass enum -passive -norecursive -d $domain_name >> output/$cdir/amass.txtls &

### WaybackEngine Enum
curl -sk "http://web.archive.org/cdx/search/cdx?url=*."$domain_name"&output=txt&fl=original&collapse=urlkey&page=" | awk -F / '{gsub(/:.*/, "", $3); print $3}' | anew | sort -u >> output/$cdir/wayback.txtls

### BufferOver Enum
curl -s "https://dns.bufferover.run/dns?q=."$domain_name"" | grep $domain_name | awk -F, '{gsub("\"", "", $2); print $2}' | anew >> output/$cdir/bufferover.txtls

### AssetFinder Enum
assetfinder --subs-only $domain_name | sort | uniq >> output/$cdir/assetfinder.txtls

### Certificate Enum
curl -s "https://crt.sh/?q="$domain_name"&output=json" | jq -r ".[].name_value" | sed 's/*.//g' | anew >> output/$cdir/whois.txtls

### Sublist3r Enum
sublist3r -d $domain_name -o sublister_output.txt &> /dev/null

### Findomain Enum
findomain -t $domain_name -q >> output/$cdir/findomain.txtls

#### Brute subdomains
shuffledns -d $domain_name -w wordlist/subdomains-top1million-5000.txt -r wordlist/resolvers.txt -o output/$cdir/dnstemp.txtls &> /dev/null

### Checking existance of files
while [[ $(ps aux | grep amass | wc -l) != 1 ]]
do
        sleep 5
done

if [ -f "sublister_output.txt" ]; then
        cat sublister_output.txt|anew|grep -v " "|grep -v "@" | grep "\." >> output/$cdir/sublister.txtls
        rm sublister_output.txt
        cat output/$cdir/sublister.txtls|anew|grep -v " "|grep -v "@" | grep "\." >> all.txtls
else
        sleep 0.1
fi

### Housekeeping
cat output/$cdir/chaos.txtls | anew all.txtls
cat output/$cdir/subfinder.txtls | anew all.txtls
cat output/$cdir/amass.txtls | anew all.txtls
cat output/$cdir/wayback.txtls |anew all.txtls
cat output/$cdir/bufferover.txtls |anew all.txtls
cat output/$cdir/assetfinder.txtls |anew all.txtls
cat output/$cdir/whois.txtls|anew|grep -v " "|grep -v "@" | grep "\." >> all.txtls
cat output/$cdir/findomain.txtls|anew|grep -v " "|grep -v "@" | grep "\." >> all.txtls
cat output/$cdir/dnstemp.txtls | grep $domain_name | egrep -iv ".(DMARC|spf|=|[*])" | cut -d " " -f1 | anew | sort -u | grep -v " "|grep -v "@" | grep "\." >>  output/$cdir/dnscan.txtls
rm output/$cdir/dnstemp.txtls
echo "www.$domain_name" |anew all.txtls
echo "$domain_name" |anew all.txtls
cat all.txtls | tr '[:upper:]' '[:lower:]'| anew | grep -v "*." | grep -v " "|grep -v "@" | grep "\." >> $cdir.master
mv $cdir.master output/$cdir.master
sed -i 's/<br>/\n/g' output/$cdir.master

## Recursive subdomain search
subfinder -dL output/$cdir.master -recursive -all -silent -o output/$cdir/subfinder-rec.txtls

cat output/$cdir/subfinder-rec.txtls | anew output/$cdir.master

## httpx get footprint
httpx -silent -l output/$cdir.master -p $webports -nc -title -status-code -content-length -content-type -ip -cname -cdn -location -favicon -jarm -o output/$cidir.master.fingerprint.txt

## Get urls
cat output/$cidir.master.fingerprint.txt | awk '{print $1}' | anew output/$cdir.master.urls.txt

rm all.txtls
rm -r -f output/$cdir

echo "[+] Done recon for $domain_name"
