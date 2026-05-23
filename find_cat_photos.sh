#!/bin/bash

# Search for JPEG and PNG images containing the word "cat"
find / -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" \) -print0 | xargs -0 grep -l "cat" 2>/dev/null
