#!/bin/bash

curl $1 | grep rec-photo | awk -F'"' '{print $4}' | wget -i- --output-document=$2