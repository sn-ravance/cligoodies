import os
from bs4 import BeautifulSoup

output_doc = BeautifulSoup()
output_doc.append(output_doc.new_tag("html"))
output_doc.html.append(output_doc.new_tag("html"))

for file in os.listdir("<path to search for HTML files>"):
    if not file.lower().endswith('.html'):
        continue

    with open(file, 'r') as html_file:
        #output_doc.body.extend(BeautifulSoup(html_file.read(), "html.parser").body)
        output_doc.html.extend(BeautifulSoup(html_file.read(), "html.parser").html)

#print(output_doc.prettify())

with open("test.html","w") as file:
    file.write(output_doc.prettify())
