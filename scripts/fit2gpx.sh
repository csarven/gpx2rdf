#!/bin/bash

for file in *.fit;
    do
        filename=$(basename $file);
        extension=${filename##*.};
        file=${filename%.*};

        gpsbabel -i garmin_fit -f "$filename" -o gpx,gpxver=1.1,garminextensions -F "$file".gpx
    done;
