#!/bin/bash
#
# Instructions:
#
# Create a file containing all of the ports to be tested with testssl.sh
# e.g.,
#
# ports.txt
#
# 1
# 2
# 3
# ...
#
# To Do:
#
# Test if testssl.sh is installed
# Check to be sure the file isn't empty
# Skip lines that isn't a number
# Check if its in the range of 0 to 65535
# Accept any port list format - nmap grepable, csv, etc.
#

# Help                                                     #
Help()
{
   # Display Help
   echo "A helper script to test all of the open ports on an box"
   echo "with SSL/TLS enabled for vulnerabilities based on testssh.sh"
   echo
   echo "Syntax: "$(basename "$0")" -[t|p|h]"
   echo
   echo "Example:"
   echo "> "$(basename "$0")" -t <IP or FQDN> -p <port list filename>"
   echo
   echo "options:"
   echo "t     target - IP or FQDN."
   echo "p     ports lists"
   echo "h     Print this Help."
   echo
}

# Get the options
while getopts ":h:t:p:" option; do
   case ${option} in
      h) # display Help
         Help
         exit;;
      t) # target
         target=$OPTARG;;
      p) # plist
         plist=$OPTARG;;
     \?) # Invalid option
         echo "Error: Invalid option"
         exit;;
   esac
done

shift $(( OPTIND - 1 ))

if [ -z ${target} ] || [ -z ${plist} ]; then
  echo "[.] "
  echo '[!] The following arguments are required:' >&2
  echo "[.] "
  echo "[!] -t <target> or -n <filename>"
  echo "[.] "
  echo "[*] Help:"
  Help
  exit 1
fi

if [ ! -e "$plist" ]; then
  echo "[.] "
  echo '[!] File does not exists.' >&2
  echo "[.] "
  Help
  exit 1
fi

#echo "t = ${target}"
#echo "n = ${plist}"

while IFS= read -r port; do

  echo "Processing port $port"

  testssl.sh -9 -oH $target'_'$port.html $target:$port

  wait

done < "${plist}"

echo "[!] Report complete."
echo "[.] "
echo "[>] To review the report in the browser, for example, type the following:"
echo "[>] > open ${target}_443.html"
echo "[.] "
echo "[!] Finished."
