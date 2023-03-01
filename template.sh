#!/bin/bash
# 

# Help                                                     #
Help()
{
   # Display Help
   echo "Add description of the script functions here."
   echo
   echo "Syntax: "$(basename "$0")" -[t|n|h]"
   echo
   echo "Example:"
   echo "> "$(basename "$0")" -t <IP or FQDN> -n <reports filename>"
   echo
   echo "options:"
   echo "t     target - IP or FQDN."
   echo "n     filename for the reports"
   echo "p     ports lists"
   echo "h     Print this Help."
   echo
}

# Get the options
while getopts ":h:t:n:p:" option; do
   case ${option} in
      h) # display Help
         Help
         exit;;
      t) # target 
         target=$OPTARG;;
      n) # filename 
         filename=$OPTARG;;
      p) # plist 
         plist=$OPTARG;;
     \?) # Invalid option
         echo "Error: Invalid option"
         exit;;
   esac
done

shift $(( OPTIND - 1 ))

if [ -z ${target} ] || [ -z ${filename} ]; then
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

echo "t = ${target}"
echo "n = ${filename}"
echo "n = ${plist}"

while IFS= read -r port; do

  echo "Processing port $port"

  #testssl.sh -9 -oH $target'_'$port.html $target:$port

  wait

done < "${plist}"

wait

echo "[!] Report complete."
echo "[.] "
echo "[>] To review the report in the browser type in:"
echo "[>] > open $filename.html"
echo "[.] "
echo "[!] Finished."
