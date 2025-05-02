#!/bin/bash

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
BROWN='\033[0;33m'
NC='\033[0m' # No Color

if [ "$#" -ne 3 ]; then
  echo -e "${RED}Usage: $0 <domain> <wordlist.txt> <resolvers.txt>${NC}"
  exit 1
fi

domain=$1
wordlist=$2
resolvers=$3
out="recon_$domain"
log="$out/log.txt"

mkdir -p "$out"

exec > >(tee -a "$log") 2>&1

echo -e "${BROWN}🔍 Starting Subdomain Enumeration for:${NC} $domain"
echo -e "${BROWN}📁 Output Directory:${NC} $out"
echo -e "${BROWN}📝 Logging to:${NC} $log"
echo -e "${BROWN}=============================================${NC}"

total_steps=10
step=1

progress() {
  echo ""
  echo -e "${BROWN}[Step $step/$total_steps] ➜ $1${NC}"
  start_time=$(date +%s)
}

end_step() {
  end_time=$(date +%s)
  duration=$((end_time - start_time))
  if [ $? -eq 0 ]; then
    echo -e "${GREEN}    ✔ Step completed in ${duration}s${NC}"
  else
    echo -e "${RED}    ✖ Step failed in ${duration}s${NC}"
  fi
  ((step++))
}

# Step 1: Subfinder
progress "Running Subfinder..."
subfinder -d "$domain" -silent -o "$out/subfinder.txt"
end_step

# Step 2: Assetfinder
progress "Running Assetfinder..."
assetfinder --subs-only "$domain" > "$out/assetfinder.txt"
end_step

# Step 3: Amass with IPs
progress "Running Amass with IP output..."
amass enum -d "$domain" >"$out/amass_full.txt"
grep -oE '\b([a-zA-Z0-9_-]+\.)+'"$domain" "$out/amass_full.txt" > "$out/final_amass.txt"
end_step

# Step 4: Sublist3r
progress "Running Sublist3r..."
sublist3r -d "$domain" -o "$out/sublist3r.txt" 
end_step

# Step 5: Findomain
progress "Running Findomain..."
findomain -t "$domain" -q > "$out/findomain.txt"
end_step

# Step 6: crt.sh
progress "Fetching crt.sh..."
curl -s "https://crt.sh/?q=%25.$domain&output=json" |
  jq -r '.[].name_value' | sed 's/\*\.//g' | sort -u > "$out/crtsh.txt"
end_step

# Step 7: PureDNS Brute-force
progress "Running PureDNS bruteforce..."
puredns bruteforce "$wordlist" "$domain" -r "$resolvers" --write "$out/puredns.txt"
end_step

# Step 8: FFuf DNS Fuzzing
progress "Running FFuf..."
ffuf -w "$wordlist" -u http://FUZZ."$domain" -fs 0 -of csv -o "$out/ffuf.csv" -t 50 
tail -n +2 "$out/ffuf.csv" | cut -d',' -f2 | sed -E 's|https?://([^/]+).*|\1|' > "$out/ffuf.txt"
end_step

# Step 9: Merge and Deduplicate
progress "Merging and deduplicating..."
cat "$out"/*.txt | grep -iE "\.$domain$" | sort -u > "$out/all_subdomains.txt"
echo -e "${BROWN}Total unique subdomains:${NC} $(wc -l < "$out/all_subdomains.txt")"
end_step

# Step 10: HTTPX and Aquatone
progress "Checking live domains with HTTPX..."
httpx -silent -l "$out/all_subdomains.txt" -o "$out/live.txt"
echo -e "${BROWN}Live domains found:${NC} $(wc -l < "$out/live.txt")"

echo -e "${BROWN}Capturing screenshots with Aquatone...${NC}"
cat "$out/live.txt" | aquatone -out "$out/aquatone" 
end_step

# Done
echo ""
echo -e "${GREEN}✅ Subdomain Enumeration Completed for${NC} $domain"
echo -e "${BROWN}📂 Results saved in:${NC} $out/"
