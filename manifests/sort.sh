# just run this file from this directory like: bash sort.sh
for file in $(ls); do sort -o $file{,}; done
