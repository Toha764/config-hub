#!/bin/bash
# script to count strictly unique lines of CSS code across the project
# usage: paste in project root directory

echo "Scanning for CSS files..."
total_files=$(find frontend/src -name "*.css" | wc -l | awk '{print $1}')
echo "Found $total_files CSS files."

echo ""
echo "Calculating unique lines of CSS (stripping spaces, ignoring blanks & comments)..."

# Find all CSS, strip leading/trailing spaces, remove comments/blanks, sort, get unique, count
unique_lines=$(find frontend/src -name "*.css" -exec cat {} + | \
  sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//' | \
  grep -v '^\/\*' | \
  grep -v '^\*.*' | \
  grep -v '^$' | \
  sort | \
  uniq | \
  wc -l | awk '{print $1}')

echo "Grand Total: $unique_lines absolutely unique lines of CSS code!"
