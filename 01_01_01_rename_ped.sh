#!/usr/bin/env bash
# Rename all_ped_1.csv ... all_ped_180.csv
# to all_ped_1.ped ... all_ped_180.ped

set -Eeuo pipefail

# Directory containing this script.
# By default, pedigree files are expected to be in the same directory.
# Alternatively, a different directory can be supplied as the first argument.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DIR="${1:-$SCRIPT_DIR}"

LOW=1
HIGH=180

echo "Pedigree directory: $DIR"
echo

renamed=0
missing=0

for i in $(seq "$LOW" "$HIGH"); do

    oldfile="${DIR}/all_ped_${i}.csv"
    newfile="${DIR}/all_ped_${i}.ped"

    if [[ -f "$oldfile" ]]; then

        mv "$oldfile" "$newfile"
        echo "Renamed: all_ped_${i}.csv -> all_ped_${i}.ped"
        ((renamed+=1))

    elif [[ -f "$newfile" ]]; then

        echo "Already renamed: all_ped_${i}.ped"

    else

        echo "File not found: all_ped_${i}.csv"
        ((missing+=1))

    fi

done

echo
echo "============================================================"
echo "SUMMARY"
echo "============================================================"
echo "Pedigree files renamed: $renamed"
echo "Pedigree files missing: $missing"
echo "============================================================"