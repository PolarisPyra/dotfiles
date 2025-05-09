ansiweather -l Plymouth,US -u imperial -a false | sed -E 's/^([^-]*: [0-9]+ °F).*/\1/'
