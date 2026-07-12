#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

echo "+--------------------------------+"
echo "|    Branded by VIPHACKER100     |"
echo "+--------------------------------+"
echo "[+] Burp Suite Patcher v2026.x"

# Get current script path
extract_path=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )

VMOPTIONS_FILENAME="BurpSuitePro.vmoptions"
LOADER_JAR_FILENAME="BurpLoaderKeygen_v1.18.jar"

# Find all BurpSuite installed on the system
echo "[+] Finding Burp Suite Installations..."
installs=$(find / -type f -name $VMOPTIONS_FILENAME -printf "%h\n" 2>/dev/null || true)

# Check if we found any installations
if [[ -z "$installs" ]]; then
    echo "[!] Couldn't find the Burp Suite installation."
    exit 1
fi

# Prompt the user to choose a file
echo "[?] Choose Installation:"
select burp_dir in "${installs[@]}"; do
    if [[ -n "$burp_dir" ]]; then
        vmoptions="$burp_dir/$VMOPTIONS_FILENAME"

        # Clean up old patching approach
        echo "[+] Cleaning old patching files..."
        if [[ -f "$burp_dir/activation.vmoptions" ]]; then
            rm -f "$burp_dir/activation.vmoptions"
            echo "    Removed activation.vmoptions"
        fi
        if [[ -f "$vmoptions" ]]; then
            sed -i '/-include-options activation.vmoptions/d' "$vmoptions"
            echo "    Cleaned BurpSuitePro.vmoptions"
        fi

        # Copy the loader jar
        echo "[+] Copying Loader..."
        cp "$extract_path/$LOADER_JAR_FILENAME" "$burp_dir/Loader.jar"

        echo "[+] Finished!"
        echo "
Activation Instructions: 
    1. The Loader will now start
    2. In the Loader window, click \"Run\" to start Burp Suite
    3. Copy the License string from the Loader to Burp Suite
    4. Click \"Manual activation\" in Burp Suite
    5. Copy Activation Request to the Loader
    6. Copy the generated Activation Response back to Burp Suite
    7. That's it ;)
        "

        read -p "Press [Enter] key to start the Loader..."
        cd "$burp_dir"
        echo "[+] Starting Loader..."
        "$burp_dir/jre/bin/java" -jar "$burp_dir/Loader.jar" &
        break
    else
        echo "Invalid selection. Please choose again."
    fi
done

exit 0
