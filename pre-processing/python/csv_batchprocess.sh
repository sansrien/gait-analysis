#!/bin/sh
#cd to openpose location first
for i in {26..31} #for the 32 videos
do
  echo "$i" | python3 json2csv.py #json2csv.py should be in the openpose folder
  echo "executed $i"
done

# for i in {26...31...1} #for the s5
# do
#   echo "pis5" | python3 json2csv.py #json2csv.py should be in the openpose folder
# done

