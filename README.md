# 🔍 Subdomain Enumeration Automation Script
```

░██████╗░██╗░░██╗░█████╗░░██████╗████████╗██████╗░███████╗░█████╗░░█████╗░███╗░░██╗
██╔════╝░██║░░██║██╔══██╗██╔════╝╚══██╔══╝██╔══██╗██╔════╝██╔══██╗██╔══██╗████╗░██║
██║░░██╗░███████║██║░░██║╚█████╗░░░░██║░░░██████╔╝█████╗░░██║░░╚═╝██║░░██║██╔██╗██║
██║░░╚██╗██╔══██║██║░░██║░╚═══██╗░░░██║░░░██╔══██╗██╔══╝░░██║░░██╗██║░░██║██║╚████║
╚██████╔╝██║░░██║╚█████╔╝██████╔╝░░░██║░░░██║░░██║███████╗╚█████╔╝╚█████╔╝██║░╚███║
░╚═════╝░╚═╝░░╚═╝░╚════╝░╚═════╝░░░░╚═╝░░░╚═╝░░╚═╝╚══════╝░╚════╝░░╚════╝░╚═╝░░╚══╝

                     Author : Ashik Ahmed
                     Github : https://github.com/AshikAhmed007
```
This script automates the process of subdomain enumeration using multiple tools and techniques. It gathers subdomains, filters and deduplicates them, checks which ones are alive, and takes screenshots using Aquatone.

---

## 📦 Features

- Enumerates subdomains using **Subfinder, Assetfinder, Amass, Sublist3r, Findomain, crt.sh, PureDNS**, and **FFuf**
- Supports **custom wordlist** and **custom resolvers**
- Merges and deduplicates results
- Checks for **live hosts using HTTPX**
- Captures screenshots using **Aquatone**
- Logs everything to a timestamped output directory
- Color-coded output (✔ success = green, ❌ fail = red, ➜ info = brown)

---

## ⚙️ Requirements

Ensure the following tools are installed and available in your system's `$PATH`:

- [`subfinder`](https://github.com/projectdiscovery/subfinder)
- [`assetfinder`](https://github.com/tomnomnom/assetfinder)
- [`amass`](https://github.com/owasp-amass/amass)
- [`sublist3r`](https://github.com/aboul3la/Sublist3r)
- [`findomain`](https://github.com/findomain/findomain)
- [`puredns`](https://github.com/d3mondev/puredns)
- [`ffuf`](https://github.com/ffuf/ffuf)
- [`httpx`](https://github.com/projectdiscovery/httpx)
- [`aquatone`](https://github.com/michenriksen/aquatone/releases/)
- `jq`, `curl`, `cut`, `sed`, `grep`, `tee`, `sort`

> **Note**: Aquatone requires Google Chrome or Chromium installed and in your path.

---

## 🧪 Sample Installation Commands (Debian/Ubuntu)

```bash
sudo apt update
sudo apt install -y jq curl chromium-browser git python3-pip

go install github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest
go install github.com/tomnomnom/assetfinder@latest
go install github.com/owasp-amass/amass/v3/...@master
go install github.com/d3mondev/puredns/v2@latest
go install github.com/ffuf/ffuf@latest
go install github.com/projectdiscovery/httpx/cmd/httpx@latest
go install github.com/findomain/findomain@latest

# Sublist3r
git clone https://github.com/aboul3la/Sublist3r.git
cd Sublist3r && pip install -r requirements.txt
sudo ln -s "$(pwd)/sublist3r.py" /usr/local/bin/sublist3r

# Aquatone
Download the latest release of Aquatone : https://github.com/michenriksen/aquatone/releases/
▶ Run : unzip aquatone_filename.zip (example : unzip aquatone_linux_amd64_1.7.0.zip)
▶ Run : mv aquatone /usr/bin/
```

Make sure `$GOPATH/bin` is added to your `$PATH` in your `.bashrc` or `.zshrc`.

---

## 🚀 Usage

```bash
# Clone the repository
git clone https://github.com/AshikAhmed007/Gh0stRec0n.git

# Navigate into the project folder
Gh0stRec0n

# Make the script executable
chmod +x gh0st_rec0n.sh

# Execution
./gh0st_rec0n.sh <domain.com> <wordlist.txt> <resolvers.txt>
```

Example:

```bash
./gh0st_rec0n.sh example.com wordlist.txt resolvers.txt
```

---

## 🧭 Script Workflow

1. **Subfinder** – Passive subdomain enumeration
2. **Assetfinder** – Passive enumeration from Tomnomnom's tool
3. **Amass** – Full enumeration with filtering
4. **Sublist3r** – Passive enumeration from popular sources
5. **Findomain** – Fast and simple domain discovery
6. **crt.sh** – Collect cert transparency logs and parse them
7. **PureDNS** – Brute-force subdomains using the wordlist and resolvers
8. **FFuf** – DNS fuzzing and filter result domains from CSV
9. **Merge & Deduplicate** – Combine all tool outputs into one unique list
10. **HTTPX + Aquatone** – Check live subdomains and screenshot them

---

## 📂 Output Directory Structure

The results will be saved under `recon_<domain>`:

```
recon_example.com/
├── final_amass.txt
├── amass_full.txt
├── assetfinder.txt
├── crtsh.txt
├── ffuf.csv
├── ffuf.txt
├── findomain.txt
├── live.txt
├── log.log
├── puredns.txt
├── subfinder.txt
├── sublist3r.txt
├── all_subdomains.txt
└── aquatone/
```

---

## 🎨 Output Coloring

- 🟢 **Green** – Step completed successfully
- 🔴 **Red** – Step failed
- 🟤 **Brown** – Descriptive/Informational messages
- 🌐 **No color** – Target domain or subdomain output

---

## 📘 License

This script is open for educational and ethical security testing only. Always get permission before scanning third-party domains.

---

## 👨‍💻 Author

**Ashik Ahmed**  
Web Pentester | Cybersecurity Enthusiast  
📧 ashikahmedgd007@gmail.com  
🔗 [GitHub](https://github.com/your-github-username) | [LinkedIn](https://linkedin.com/in/your-profile)

---

## 📄 License

This project is licensed under the [MIT License](LICENSE).
