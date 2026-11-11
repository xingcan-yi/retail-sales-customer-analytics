import csv
from pathlib import Path

source = Path("data/online_retail.csv")
target = Path("data/online_retail_numbered.csv")

with source.open("r", encoding="utf-8", newline="") as infile, \
     target.open("w", encoding="utf-8", newline="") as outfile:

    reader = csv.reader(infile)
    writer = csv.writer(outfile)

    header = next(reader)
    writer.writerow(["source_row"] + header)

    count = 0

    for source_row, record in enumerate(reader, start=2):
        writer.writerow([source_row] + record)
        count += 1

print(f"Numbered records: {count}")
print(f"Output: {target}")
