#!/bin/bash

# Set up the specifics of your flight request using request.json
# For more information, see: https://developers.google.com/qpx-express/v1/requests

# The following code assumes request.json only requests 1 flight (lowest cost)
# The final cost is stored in COST as a float.

# Set the baseline cost here in cents.  This is necessary because bash 
# does not support float arithmetic
BASELINECOST=15000

# Request the current lowest price 
COST=$(curl -d @request.json --header "Content-Type: application/json" \
				https://www.googleapis.com/qpxExpress/v1/trips/search?key=YOUR_PUBLIC_KEY_HERE \
				| grep "saleTotal" -m 1 \
				| awk -F'"' '{print $4}' | sed 's/[A-Z]*//g')

# Store the current price in cents as an integer for bash
INTCOST=$(awk "BEGIN {printf \"%.0f\n\", $COST * 100}")


# If a price below the baseline has been detected, notify me via email
if (( INTCOST < BASELINECOST )); then
	mail -s "Flight Cost Update" YOUR_EMAIL_HERE <<<$COST
# Otherwise, send an email anyways so I know my script is working
# (Use an email filter so these get automatically archived.)
else
	mail -s "[qpx-success]" YOUR_EMAIL_HERE <<<$COST
fi

