#!/bin/bash

CSV_FILE="scribblingScribe/bible_outline.csv"

tail -n 3 "$CSV_FILE" > latest_data.csv

# Generate the Markdown content for the latest data
latest_data=$(cat <<EOF
## Latest Data
| MMDDYY | Book | Chapter | Start | End | Section | Link |
| ------ | ---- | ------- | ----- | --- | ------- | ---- |
EOF
)
while IFS=, read -r mmddyy book chapter start end section link; do
  latest_data+="\n| $mmddyy | $book | $chapter | $start | $end | $section | [Link]($link) |"
done < latest_data.csv

# Update the README.md with the latest data
awk -v latest_data="$latest_data" '/## Latest Data/{print latest_data; f=1; next} f && /^$/{f=0} !f' README.md > README_tmp.md
mv README_tmp.md README.md

# Ensure latest_data.csv is not included in the commit
git reset latest_data.csv