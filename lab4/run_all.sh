DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
for file in $1/*; do
    ruby $DIR/conq.rb $file
done
