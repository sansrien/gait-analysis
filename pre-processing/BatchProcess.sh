#!/bin/sh
#cd to openpose location first
for i in {1...32...1} #for the 32 videos
do
  bin/openposedemo.exe -video "examples/mediarun/$i.avi" --logging_level 0 --net_resolution "-320x160" --write_json "examples/output/$i" 
  #bin/openposedemo.exe --image_dir "examples/lowlevel/" --net_resolution "-320x160" --write_images "output_images/"
  echo "$i" | python3 json2csv.py #json2csv.py should be in the openpose folder
done