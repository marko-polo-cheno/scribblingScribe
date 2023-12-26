#!/bin/bash

BIBLE_FILE="bible_outline.csv"
PRAYER_FILE="prayer_log.csv"

# Prepare a new README content
NEW_README_CONTENT=$(< README.md)

# Update Bible data
if [ -f "$BIBLE_FILE" ]; then
    LATEST_BIBLE_DATA=$(tail -n 1 "$BIBLE_FILE" | awk -F, '{printf "| %s | %s | %s | %s | %s | %s | [Link](%s) |\n", $1, $2, $3, $4, $5, $6, $7}')
    BIBLE_TABLE_HEADER="| MMDDYY | Book | Chapter | Start | End | Section | Link |\n| ------ | ---- | ------- | ----- | --- | ------- | ---- |\n"
    NEW_README_CONTENT=$(echo "$NEW_README_CONTENT" | sed "/<!--BIBLE_DATA_START-->/, /<!--BIBLE_DATA_END-->/c\<!--BIBLE_DATA_START-->\n$BIBLE_TABLE_HEADER$LATEST_BIBLE_DATA<!--BIBLE_DATA_END-->")
else
    echo "CSV file does not exist: $BIBLE_FILE"
fi

# Update Prayer data
if [ -f "$PRAYER_FILE" ]; then
    LATEST_PRAYER_DATA=$(tail -n 1 "$PRAYER_FILE" | awk -F, '{printf "| %s | %s | %s | %s | %s |\n", $1, $2, $3, $4, $5}')
    PRAYER_TABLE_HEADER="| MMDDYY | Time | Thanksgiving | Request | OOF |\n| ------ | ---- | ------------ | ------- | --- |\n"
    NEW_README_CONTENT=$(echo "$NEW_README_CONTENT" | sed "/<!--PRAYER_DATA_START-->/, /<!--PRAYER_DATA_END-->/c\<!--PRAYER_DATA_START-->\n$PRAYER_TABLE_HEADER$LATEST_PRAYER_DATA<!--PRAYER_DATA_END-->")
else
    echo "CSV file does not exist: $PRAYER_FILE"
fi

# Save the modified content back to README.md
echo "$NEW_README_CONTENT" > README.md
