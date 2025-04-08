# Parses out HTTP services from a gnmap file using nmap_http_parse.py
# from github.com/zenfosec/nmap_parsing_scripts

# Original script written by zenfosec on 4/7/2025

# Check to see if the script was run with the correct number of arguments
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <input_file> <output_file>"
    exit 1
fi

./nmap_http_parse.py "$1" > "$2"
if [ $? -ne 0 ]; then
    echo "Error: nmap_http_parse.py command failed. Please check your input and try again."
    exit 1
fi
echo "HTTP services parsed successfully. Resulting URLs saved to $2."

for url in $(cat "$2"); do
    # Check if the URL is valid
    if [[ $url =~ ^https?:// ]]; then
        # Use curl to check the HTTP response code
        response=$(curl -s -o /dev/null -w "%{http_code}" "$url")
        echo "URL: $url, Response Code: $response"
        urls +=("$url")
    else
        echo "Invalid URL: $url"
    fi
done

for url in "${urls[@]}"; do
    host =$(echo "$url" | awk -F/ '{print $3}')
    nikto -h "$url" -T2 -oA "$url" --no-update -o nikto_$host.txt
    if [ $? -ne 0 ]; then
        echo "Error: nikto command failed. Please check your input and try again."
        next
    fi
    echo "Nikto scan completed for $url. Results saved to nikto_$host.txt."