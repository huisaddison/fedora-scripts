#!/usr/bin/python

import sys
import subprocess
from lxml import html
import requests
source = sys.argv[1]
page = requests.get(source)
tree = html.fromstring(page.content)

def writeTitle(f, title):
	f.write('= ' + title + ' =\n')

def writeSubHeading(f, subhead):
	f.write('== ' + subhead + ' ==\n')

def writeImage(f, source, filename):
	subprocess.call(["sh", "imgscrape-allrecipes.sh", source, filename + ".jpeg"])
	subprocess.call(["cp", filename + ".jpeg", "/home/addison/Dropbox/wiki/images/"])
	f.write("{{images/" + filename + ".jpeg}}\n")

def writeBullets(f, bulList):
	for item in bulList:
		f.write("    * " + item.encode('ascii', 'ignore') + "\n")

def writeNumbered(f, numList):
	for item in numList:
		f.write("    # " + item + "\n")

def writeTime(f, timeNames, timeNums):
	f.write("    * Time required:\n")
	for i in range(len(timeNames)):
		f.write("        - " + timeNames[i] + ": " + timeNums[i] + " m\n")

def writeSource(f, source):
	f.write("[[" + source + " |Source.]]\n")


title       = tree.xpath('//h1[@class="recipe-summary__h1"]/text()')[0]
filename    = "/home/addison/Documents/recipes/" + title.replace(' ', '-').lower()
servings    = tree.xpath('//p[@class="subtext"]/text()')
timeNames   = tree.xpath('//p[@class="prepTime__item--type"]/text()')
timeNums    = tree.xpath('//span[@class="prepTime__item--time"]/text()')
ingredients = tree.xpath('//span[@class="recipe-ingred_txt added"]/text()')
directions  = tree.xpath('//span[@class="recipe-directions__list--item"]/text()')

with open(filename + ".md", 'w') as f:
	writeTitle(f, title)
	f.write("\n")
	writeImage(f, source, filename)
	f.write("\n")
	writeSubHeading(f, "Preliminaries")
	writeTime(f, timeNames, timeNums)
	writeBullets(f, servings)
	f.write("\n")
	writeSubHeading(f, "Ingredients")
	writeBullets(f, ingredients)
	f.write("\n")
	writeSubHeading(f, "Directions")
	writeNumbered(f, directions)
	f.write("\n")
	writeSource(f, source)
