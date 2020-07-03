if [[ $# -eq 0 ]] ;
then
	echo "exemple: bash subdomain.sh yahhoo.com"
	exit 1
else
	
    curl -s "https://certspotter.com/api/v0/certs?domain="$1 | jq '.[].dns_names[]' | sed 's/\"//g' | sed 's/\*\.//g' | sort -u | grep $1 >>$1.txt
		echo "Certspotter Done"



	curl -s "http://web.archive.org/cdx/search/cdx?url=*."$1"/*&output=text&fl=original&collapse=urlkey" |sort| sed -e 's_https*://__' -e "s/\/.*//" -e 's/:.*//' -e 's/^www\.//' | uniq >>$1.txt

		echo "Webarchieve Done"

	

    curl -s "https://crt.sh/?q=%25."$1"&output=json"| jq -r '.[].name_value' | sed 's/\*\.//g' | sort -u|grep -o "\w.*$1" > $1.txt

		echo "Crt.sh Done"


	curl -s "https://www.threatcrowd.org/searchApi/v2/domain/report/?domain=$1"|jq .subdomains|grep -o "\w.*$1" >>$1.txt
		
		echo "Threatcrowd Done"
      

	curl -s "https://api.hackertarget.com/hostsearch/?q=$1"|grep -o "\w.*$1" >>$1.txt
        echo ">>> Hackertarget Done"

	
	curl -s "https://dns.bufferover.run/dns?q=."$1 | jq -r .FDNS_A[]|cut -d',' -f2|sort -u >>$1.txt
        echo "Dns bufferover Done"

curl -s  -X POST --data "url=$1&Submit1=Submit" -H 'User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.1) Gecko/20100122 firefox/3.6.1' "https://suip.biz/?act=amass"|grep -o "\w*.$1"| uniq >>$1.txt
       echo "Amass Done"
      
	curl -s  -X POST --data "url=$1&Submit1=Submit" -H 'User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.1) Gecko/20100122 firefox/3.6.1' "https://suip.biz/?act=subfinder"|grep -o "\w*.$1"|cut -d ">" -f 2|egrep -v " "| uniq >>$1.txt
	   echo "Subfinder Done"
	
	curl -s -X POST --data "url=$1&Submit1=Submit" -H 'User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.1) Gecko/20100122 firefox/3.6.1' "https://suip.biz/?act=findomain"|grep -o "\w.*$1"|egrep -v " "| uniq >>$1.txt
       echo "Findomain Done"
	   
       


	cat $1.txt|sort -u|egrep -v "//|:|,| |_|\|@" |grep -o "\w.*$1"|tee all.txt
	
	
	

fi
