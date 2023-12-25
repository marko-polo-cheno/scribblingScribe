#!/bin/bash

CSV_FILE="scribblingScribe/bible_outline.csv"

# Ensure the CSV file exists
if [ ! -f "$CSV_FILE" ]; then
    echo "CSV file does not exist: $CSV_FILE"
    exit 1
fi

tail -n 3 "$CSV_FILE" > latest_data.csv

# Generate Markdown content for the latest data
latest_data="\n## Latest Data\n| MMDDYY | Book | Chapter | Start | End | Section | Link |\n| ------ | ---- | ------- | ----- | --- | ------- | ---- |\n"
while IFS=, read -r mmddyy book chapter start end section link; do
  latest_data+="| $mmddyy | $book | $chapter | $start | $end | $section | [Link]($link) |\n"
done < latest_data.csv

# Update the README.md with the latest data
awk -v latest_data="$latest_data" '/## Latest Data/{print latest_data; f=1; next} f && /^##/{f=0} !f' README.md > README_tmp.md

# Check if changes have been made, if so, update the README
if ! cmp -s README_tmp.md README.md; then
  mv README_tmp.md README.md
else
  echo "No changes in latest data; README.md is not updated."
  rm README_tmp.md
fi

# Cleanup
rm latest_data.csv
