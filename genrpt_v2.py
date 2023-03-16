import os
from bs4 import BeautifulSoup

output_doc = BeautifulSoup()
output_doc.append(output_doc.new_tag("html"))
output_doc.html.append(output_doc.new_tag("html"))

for file in sorted(os.listdir('.')):
    if not file.lower().endswith('.html'):
        continue

    with open(file, 'r') as html_file:
        output_doc.html.extend(BeautifulSoup(html_file.read(), "html.parser").html)

with open("test.html","w") as file:
    file.write(output_doc.prettify())
