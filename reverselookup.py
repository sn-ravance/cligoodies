#
## Instructions
#
# 1. Run the following query in Splunk to discover all of the internal assets
#
# index="name of index" sourcetype="name of source" 
# | where dns_request_queried_domain like "%.<target domain name>.com" 
# | dedup dns_request_queried_domain
# | rex field=dns_request_queried_domain "^(?<fqdn>[^ ]*)" 
# | rex field=dns_request_client_ip "^(?<internal_ip>[^ ]*)" 
# | table internal_ip, fqdn
#
# 2. Export the results (limit to less than 10,000 - per Splunk) as a csv file
#
#    The CSV should look like this -
#
#     "internal_ip","fqdn"
#
# 3. Run this script
# 4. Review the results
#
import socket
import argparse
from csv import writer
from csv import reader
from colorama import init as colorama_init
from colorama import Fore
from colorama import Style

arg_desc = '''\
Author: sealmindset
Version: 1.0
Date: 02/16/2023

Description:
Identify DNS names (or IP Address) that are resolvable externally.

Potential Use Case:
A list of internal DNS names and IP Addresses.

Prerequisite:
A CSV file containing a list of IP Addresses and/or FQDN.
The column number of the attribute to do a reverse lookup on.
        '''
parser = argparse.ArgumentParser(formatter_class = argparse.RawDescriptionHelpFormatter,
                                    description= arg_desc)

parser.add_argument('-n','--name', type=str, required=True, help='source csv file')
parser.add_argument('-c','--column', type=int, required=True, help='column number starting from zero')
parser.add_argument('-l','--lookup', type=str, required=True, help='by domain | ip')
parser.add_argument('-o','--output', type=str, required=True, help='append to the filename')

args = parser.parse_args()

infile = args.name
ofileext = args.output

outfile = infile.replace(".csv", "_" + ofileext + ".csv")

colnum = args.column

class status:
    OKGREEN = f'[{Fore.GREEN}>{Style.RESET_ALL}]'
    FAIL = f'[{Fore.RED}!{Style.RESET_ALL}]'

def domain_name(ip_addr):
  try:
    dom_name = socket.gethostbyaddr(ip_addr)
    print(f"{status.OKGREEN} The domain name for " + ip_addr + " is", dom_name)
  except:
    print(f"{status.FAIL} Could not resolve " + ip_addr + " for", dom_name)
  return dom_name

def ip_address(fqdn):
  try:
    ip_addr = socket.gethostbyip(fqdn)
    print(f"{status.OKGREEN} The IP Address for " + fqdn + " is", ip_addr)
  except:
    print(f"{status.FAIL} Could not resolve " + fqdn + " for", ip_addr)
  return ip_addr

with open(infile, 'r') as read_obj, open(outfile, 'w', newline='') as write_obj:
    csv_reader = reader(read_obj)
    csv_writer = writer(write_obj)
    for row in csv_reader:
      try:
        if args.lookup == 'domain':
          results = domain_name(row[colnum])

        if args.lookup == 'ip':
          results = ip_address(row[colnum])

        row.append(results)
        csv_writer.writerow(row)
      except:
        print(f"{status.FAIL} Unable to resolve: " + row[colnum])
