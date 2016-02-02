#!/bin/bash
# 
# Script based largely on https://gist.github.com/rogeliodh/1560289

USERHOME="/home/addison"

source /home/addison/Documents/fedora-scripts/credentials
## Email credentials kept in source file as this script is kept on github
## Source file format:
# USERNAME="username"
# PASSWORD="password"
# FROM="username@gmail.com"
##

# Directory to store periodicals
OUTDIR="$USERHOME/news"
# Common choices: kindle, kindle_dx, kindle_fire, kobo, ipad, sony
OUTPROFILE="kindle"
# A text file with an email per line.
EMAILSFILE="$USERHOME/news/emails.txt"
# Email transcript with success/failure for each periodical
TRANSCRIPT="$USERHOME/Documents/fedora-scripts/dailydigest.md"
echo "Periodicals successfully sent to Kindle:" >> $TRANSCRIPT
# Miscellaneous SMTP credentials
SMTP="smtp.gmail.com"
PORT="587"

CONTENTPREFIX="Attached is the your periodical downloaded by calibre"

DATEFILE=`date "+%Y_%m_%d"`
DATESTR=`date "+%Y/%m/%d"`

function fetch_and_send {
	RECIPE=$1
	SUBJECTPREFIX="News: $2"
	OUTPUTPREFIX=$3	
	OUTFILE="${OUTDIR}/${OUTPUTPREFIX}${DATEFILE}.mobi"

	echo "Fetching $RECIPE into $OUTFILE"
	ebook-convert "$RECIPE" "$OUTFILE" --output-profile "$OUTPROFILE" 

	echo "Setting date $DATESTR as author in $OUTFILE"
	ebook-meta -a "$DATESTR" "$OUTFILE"

	# email the files
	if [[ -f $OUTFILE ]]; then
		FILESIZE=$(wc -c $OUTFILE | awk '{print $1}')
		if [[ $FILESIZE -le 25000000 ]]; then
			if [ -n "$EMAILSFILE" -a -f "$EMAILSFILE" ]; then
			    for TO in `cat $EMAILSFILE`; do
				echo "Sending $OUTFILE to $TO"
				calibre-smtp --attachment "$OUTFILE" --relay "$SMTP" --port "$PORT" --username "$USERNAME" --password "$PASSWORD"  --encryption-method TLS --subject "$SUBJECTPREFIX ($DATESTR)" "$FROM" "$TO"  "$CONTENTPREFIX ($DATESTR)"
			    done
			    echo "    * $2" >> $TRANSCRIPT
			fi	
		else
			echo "    * $2 exceed the email attachment size." >> $TRANSCRIPT
		fi
	else
		echo "    * $2 recipe failed." >> $TRANSCRIPT
	fi
	notify-send "$2 daily pull complete!"
	}

fetch_and_send "New York Times.recipe" "The New York Times" "nyt_"

fetch_and_send "Los Angeles Times.recipe" "The Los Angeles Times" "lat_"

fetch_and_send "The Washington Post.recipe" "The Washington Post" "wp_"

if [[ $(date +%u) == 5 ]]; then
	fetch_and_send "The Economist.recipe" "The Economist" "economist_"
fi

if [[ $(date +%d) == 01 ]]; then
	fetch_and_send "The Atlantic.recipe" "The Atlantic" "atlantic_"
fi

cat $TRANSCRIPT | mail -s "Daily Update" huisaddison@gmail.com
calibre-smtp --relay "$SMTP" --port "$PORT" --username "$USERNAME" --password "$PASSWORD"  --encryption-method TLS --subject "Daily Update" "$FROM" "huisaddison@gmail.com"  "$TRANSCRIPT"
rm -f $TRANSCRIPT