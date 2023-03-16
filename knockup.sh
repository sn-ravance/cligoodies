#!/bin/bash

# Help                                                     #
Help()
{
   # Display Help
   echo "Add description of the script functions here."
   echo
   echo "Syntax: "$(basename "$0")" -[t|k|h]"
   echo
   echo "Example:"
   echo "> "$(basename "$0")" -t <domain name> -k <folder name>"
   echo
   echo "options:"
   echo "t     target - domain name i.e., domain.com"
   echo "k     Folder to where the results are dumped to"
   echo "h     Print this Help."
   echo
}


# arg is optional, do not set colons after 

# Get the options
while getopts ":h:t:k:" option; do
   case ${option} in
      h) # display Help
         Help
         exit;;
      t) # target 
         target=$OPTARG;;
      k) # kdata 
         kdata=$OPTARG;;
     \?) # Invalid option
         echo "Error: Invalid option"
         exit;;
   esac
done

shift $(( OPTIND - 1 ))

if [ -z ${target} ]; then
  echo "[.] "
  echo '[!] The following arguments are required:' >&2
  echo "[.] "
  echo "[!] -t <target> "
  echo "[.] "
  echo "[*] Help:"
  Help
  exit 1
fi

if [ ! -d "$kdata" ]; then
  echo "[.] "
  echo '[!] Folder does not exists.' >&2
  echo "[.] "
  mkdir -p $kdata
fi  

echo "t = ${target}"
echo "n = ${kdata}"

knockpy $target --no-http-code 404 500 530 -o $kdata

echo "[!] Report complete."
echo "[.] "
echo "[>] To review the report in the browser type in:"
echo "[>] > open $filename.html"
echo "[.] "
echo "[!] Finished."
