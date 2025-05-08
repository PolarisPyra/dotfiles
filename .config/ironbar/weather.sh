ansiweather -l Plymouth,US -u imperial | sed -r "s/\x1B\[[0-9;]*[mGK]//g" | awk '{print "Plymouth, US:", $4}'
