#!/usr/bin/env bash

set -e

transfer() {
tmpfile=$( mktemp -t transferXXX ); if tty -s; then basefile=$(basename "$1" | sed -e 's/[^a-zA-Z0-9._-]/-/g'); curl -s --upload-file "$1" "https://transfer.sh/$basefile" >> $tmpfile; else curl --progress-bar --upload-file "-" "https://transfer.sh/$1" >> $tmpfile ; fi;
echo "$(<$tmpfile)"
rm -f $tmpfile;
}

MY_DIR="$(dirname "$0")"

cd ${MY_DIR}

mkdir "./tmp"
WIZARD_SH="./tmp/wizard.sh"

printf "#!/usr/bin/env bash

set -e

WIZARD_BUILD=$(git rev-parse --short HEAD)
WIZARD_VERSION=$(<".version")

" > ${WIZARD_SH}

awk -f inrep.awk _wizard_wrapper.sh >> ${WIZARD_SH}

printf "bumping version from $(<".version") to "
NEW_VERSION=$(echo $(<".version") | awk -F. -v OFS=. 'NF==1{print ++$NF}; NF>1{$NF=sprintf("%0*d", length($NF), ($NF+1)); print}')
echo ${NEW_VERSION} > ".version"
printf "$NEW_VERSION\n"

