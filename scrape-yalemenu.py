#!/usr/bin/python

import sys
import subprocess
from lxml import html
import requests

def writeTitle(f, title):
	f.write('= ' + title + ' =\n')

def writeSubHeading(f, subhead):
	f.write('== ' + subhead + ' ==\n')

def writeBullets(f, bulList):
	for item in bulList:
		item = item.splitlines()[0]
		f.write("    * " + item.encode('ascii', 'ignore') + "\n")

def writeMenu(f, source, name):
	page = requests.get(source)
	tree = html.fromstring(page.content)
	foodlist = tree.xpath('//div[@class="recipe"]/h2/text()')
	if (len(foodlist) != 0):
		writeSubHeading(f, name)
		writeBullets(f, foodlist)

def writeSlifka(f):
	writeSubHeading(f, "Slifka")
	page = requests.get("http://www.slifkacenter.org/about/slifka-dining-menus/")
	tree = html.fromstring(page.content)
	foodlist = tree.xpath('//strong/text()')
	writeBullets(f, foodlist)

with open("/home/addison/Documents/fedora-scripts/dailydigest.md", "w") as f:
	writeTitle(f, "Today's Menus")
	writeMenu(f, "http://www.yaledining.org/menu.cfm?mDH=9", "Timothy Dwight")
	writeMenu(f, "http://www.yaledining.org/menu.cfm?mDH=11", "Commons")
	writeSlifka(f)
