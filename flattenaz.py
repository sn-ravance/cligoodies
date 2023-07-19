#
# The code defines a function flatten_json to recursively flatten JSON data.
# Variables input_file and output_file are specified, representing the paths to the input and output files, respectively.
# The input file is read, and JSON data is extracted from all columns, storing the data in json_data_list.
# The JSON data is then flattened using the flatten_json function, and the flattened data is stored in flattened_data_list.
# All unique keys from the flattened data are collected and stored in unique_keys.
# The original input file is read again to access the rows.
# The unique keys are appended to the header.
# The flattened data is written to the output file, with each row in the input file being extended with the corresponding flattened data.
#

arg_desc = """\
Author: Rob Vance 
Version: 1.0
Date: 07/16/2023

Description:
The purpose of the script is to flatten JSON data from Azure Resource Graph Explorer query CSV output, creating separate columns for each flattened JSON key while preserving the original row structure.

Prerequisite:
The CSV output from a Azure Resource Graph Explorer query
        """

import argparse
import csv
import json


def flatten_json(json_data, prefix=""):
    flattened_data = {}
    for key, value in json_data.items():
        new_key = prefix + key if prefix else key
        if isinstance(value, dict):
            flattened_data.update(flatten_json(value, new_key + "_"))
        else:
            flattened_data[new_key] = value
    return flattened_data


# Create an ArgumentParser object
parser = argparse.ArgumentParser(
    formatter_class=argparse.RawDescriptionHelpFormatter, description=arg_desc
)

# Add the arguments
parser.add_argument("input_file", help="Path to the input CSV file")
parser.add_argument("output_file", help="Path to the output CSV file")

# Parse the command-line arguments
args = parser.parse_args()

input_file = args.input_file  # Path to the input CSV file
output_file = args.output_file  # Path to the output CSV file

# Read the input file and extract JSON data from all columns
json_data_list = []
with open(input_file, "r") as file:
    reader = csv.DictReader(file)
    headers = reader.fieldnames
    for row in reader:
        json_data = {}
        for header in headers:
            try:
                column_data = json.loads(row[header])
                json_data[header] = column_data
            except (json.JSONDecodeError, TypeError):
                pass
        json_data_list.append(json_data)

# Flatten the JSON data
flattened_data_list = []
for json_data in json_data_list:
    flattened_data = flatten_json(json_data)
    flattened_data_list.append(flattened_data)

# Collect all unique keys from the flattened data
unique_keys = set()
for flattened_data in flattened_data_list:
    unique_keys.update(flattened_data.keys())

# Read the original input file again
with open(input_file, "r") as file:
    reader = csv.reader(file)
    header = next(reader)  # Read the header

    # Append the unique keys to the header
    header += list(unique_keys)

    # Write the flattened data to the output file
    with open(output_file, "w", newline="") as output_file:
        writer = csv.writer(output_file)
        #writer = unicode_csv.UnicodeWriter(output_file)
        writer.writerow(header)  # Write the modified header
        for i, row in enumerate(reader):
            if i < len(flattened_data_list):
                writer.writerow(
                    row + [flattened_data_list[i].get(key, "") for key in unique_keys]
                )
            else:
                writer.writerow(row)

print("Flattened data saved to 'output.csv'.")
