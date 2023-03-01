#!/bin/bash
#
# To Do:
#
# Test if nmap is installed
#

# Help                                                     #
Help()
{
   # Display Help
   echo "A helper script to automate the tedious task of running a"
   echo "nmap scans and generating the HTML report." 
   echo
   echo "Syntax: "$(basename "$0")" -[t|n|h]"
   echo
   echo "Example:"
   echo "> "$(basename "$0")" -t <IP or FQDN> -n <reports filename>"
   echo
   echo "options:"
   echo "t     target - IP or FQDN."
   echo "n     filename for the reports"
   echo "h     Print this Help."
   echo
}

# Get the options
while getopts ":htn:" option; do
   case $option in
      h) # display Help
         Help
         exit;;
      t) # target 
         target=$OPTARG;;
      n) # filename 
         filename=$OPTARG;;
     \?) # Invalid option
         echo "Error: Invalid option"
         exit;;
   esac
done

shift "$(( OPTIND - 1 ))"

if [ -z "$target" ] || [ -z "$filename" ]; then
  echo "[.] "
  echo '[!] The following arguments are required:' >&2
  echo "[.] "
  echo "[!] -t <target> or -n <filename>"
  echo "[.] "
  echo "[*] Help:"
  echo
  Help
  exit 1
fi

echo "[*] nmap scan against $target"

# -sTV                          TCP connect scan with version detection
# -p-                           Port selection: All ports from 1-65535
# -A                            Enables several modes
# -vvvv                         Very high level of verbosity
# -oA <file output name>        Output data in “All” formats

nmap -sTV -p- -A -vvvv -oA $filename $target

wait

echo "[!] Scan complete."
echo "[*] Generating HTML report"

xsltproc $filename.xml -o $filename.html

wait

echo "[!] Report complete."
echo "[.] "
echo "[>] To review the report in the browser type in:"
echo "[>] > open $filename.html"
echo "[.] "
echo "[!] Finished."
