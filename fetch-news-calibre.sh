#!/bin/bash
# 
# Script based largely on https://gist.github.com/rogeliodh/1560289

source ./credentials
## Email credentials kept in source file as this script is kept on github
## Source file format:
# USERNAME="username"
# PASSWORD="password"
# FROM="username@gmail.com"
##

# Directory to store periodicals
OUTDIR="$HOME/news"
# Common choices: kindle, kindle_dx, kindle_fire, kobo, ipad, sony
OUTPROFILE="kindle"
# A text file with an email per line.
EMAILSFILE="$HOME/news/emails.txt"
# Miscellaneous SMTP credentials
SMTP="smtp.gmail.com"
PORT="587"

CONTENTPREFIX="Attached is the your periodical downloaded by calibre"

DATEFILE=`date "+%Y_%m_%d"`
DATESTR=`date "+%Y/%m/%d"`

function fetch_and_send {
	RECIPE=$1
	SUBJECTPREFIX=$2
	OUTPUTPREFIX=$3	
	OUTFILE="${OUTDIR}/${OUTPUTPREFIX}${DATEFILE}.mobi"

	echo "Fetching $RECIPE into $OUTFILE"
	ebook-convert "$RECIPE" "$OUTFILE" --output-profile "$OUTPROFILE" 

	echo "Setting date $DATESTR as author in $OUTFILE"
	ebook-meta -a "$DATESTR" "$OUTFILE"

	# email the files
	if [ -n "$EMAILSFILE" -a -f "$EMAILSFILE" ]; then
	    for TO in `cat $EMAILSFILE`; do
		echo "Sending $OUTFILE to $TO"
		calibre-smtp --attachment "$OUTFILE" --relay "$SMTP" --port "$PORT" --username "$USERNAME" --password "$PASSWORD"  --encryption-method TLS --subject "$SUBJECTPREFIX ($DATESTR)" "$FROM" "$TO"  "$CONTENTPREFIX ($DATESTR)"
	    done
	fi
}

fetch_and_send "New York Times.recipe" "News: The New York Times" "nyt_"
notify-send "New York Times daily pull complete!"

fetch_and_send "Los Angeles Times.recipe" "News: The Los Angeles Times" "lat_"
notify-send "Los Angeles Times daily pull complete!"

fetch_and_send "The Washington Post.recipe" "News: The Washington Post" "wp_"
notify-send "Washington Post daily pull complete!"

if [ $(date +%u) == 5 ]; then
	fetch_and_send "The Economist.recipe" "News: The Economist" "economist_"
	notify-send "The Economist weekly pull complete!"
fi

if [ $(date +%d) == 01 ]; then
	fetch_and_send "The Atlantic.recipe" "News: The Atlantic" "atlantic_"
	notify-send "The Atlantic monthly pull complete!"
fi
