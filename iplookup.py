#
# 1. Run the following query in Splunk to discover all of the internal assets
#
# index="name of index" source="name of source" 
# | where dns_request_queried_domain like "%.<target domain name>.com" 
# | dedup dns_request_queried_domain
# | rex field=dns_request_queried_domain "^(?<fqdn>[^ ]*)" 
# | rex field=dns_request_client_ip "^(?<internal_ip>[^ ]*)" 
# | table internal_ip, fqdn
#
# 2. Export the results (limit to less than 10,000 - per Splunk) as a csv file
#
#     "internal_ip","fqdn"
#
# 3. Run this script
#    
#     python3 lookup.py --nmae <name of csv file>.csv
#
# 4. Output of the new file is <name of csv file>_intip2extip.csv
#
#     "internal_ip","fqdn","external_ip"
#
import socket
import argparse
from csv import writer
from csv import reader

parser = argparse.ArgumentParser()
parser.add_argument('--name', type=str, required=True, help='name of the csv file')
args = parser.parse_args()

infile = args.name
outfile = infile.replace(".csv", "_intip2extip.csv")

with open(infile, 'r') as read_obj, \
        open(outfile, 'w', newline='') as write_obj:
    csv_reader = reader(read_obj)
    csv_writer = writer(write_obj)
    for row in csv_reader:
      try:
      	print("Resolving: " + row[1])

      	ip = socket.gethostbyname(row[1])
      	print(row[1] + " resolved to " + ip)

      	row.append(ip)
      	csv_writer.writerow(row)
      except:
        print('Unable to resolve: ' + row[1])
