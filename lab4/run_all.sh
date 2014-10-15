DIR="$( pwd )"
for file in $1/*; do
    ruby $DIR/closest_pair.rb $file
done
