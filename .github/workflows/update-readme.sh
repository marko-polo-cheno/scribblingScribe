#!/bin/bash

BIBLE_FILE="bible_outline.csv"
HYMN_FILE="hymn_metadata.csv"
PRAYER_FILE="prayer_log.csv"

update_latest_data() {
    local csv_file="$1"
    local section_title="$2"
    local columns="$3"
    local format="$4"
    local latest_data_line="$5"  # This is the line that formats the latest data

    # Ensure the CSV file exists
    if [ ! -f "$csv_file" ]; then
        echo "CSV file does not exist: $csv_file"
        return 1
    fi

    tail -n 1 "$csv_file" > latest_data.csv

    # Generate Markdown content for the latest data
    latest_data="\n## $section_title\n$columns"
    while IFS=, read -r $format; do
        eval "latest_data_line=\"$latest_data_line\""  # Use eval to expand variables in the template
        latest_data+="$latest_data_line\n"
    done < latest_data.csv

    # Update the README.md with the latest data
    awk -v latest_data="$latest_data" "/## $section_title/{print latest_data; f=1; next} f && /^##/{f=0} !f" README.md > README_tmp.md

    # Check if changes have been made, if so, update the README
    if ! cmp -s README_tmp.md README.md; then
        mv README_tmp.md README.md
    else
        echo "No changes in $section_title; README.md is not updated."
        rm README_tmp.md
    fi
}

# Update Bible data
update_latest_data "$BIBLE_FILE" "Latest Bible Data" \
"| MMDDYY | Book | Chapter | Start | End | Section | Link |\n| ------ | ---- | ------- | ----- | --- | ------- | ---- |\n" \
"mmddyy book chapter start end section link" \
"| \${mmddyy} | \${book} | \${chapter} | \${start} | \${end} | \${section} | [Link](\${link}) |"

# Update Prayer data
update_latest_data "$PRAYER_FILE" "Latest Prayer Data" \
"| MMDDYY | Time | Thanksgiving | Request | OOF |\n| ------ | ---- | ------------ | ------- | --- |\n" \
"mmddyy time thanksgiving request oof"

# Update Hymn data
update_latest_data "$HYMN_FILE" "Latest Hymn Data" \
"| Number | Title | Tags | Verse | Thoughts |\n| ------ | ----- | ---- | ----- | -------- |\n" \
"number title tags verse thoughts"
