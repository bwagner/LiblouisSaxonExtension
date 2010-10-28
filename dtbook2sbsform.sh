#!/bin/sh

if [ $# != 1 ] ; then
	PRG=`basename $0` 
	echo "Usage: $PRG dtbook.xml\n"
	echo "\tone dtbook xml source file expected. Exiting.\n"
	exit 1
fi

./saxon.sh \
	-xsl:resources/xsl/dtbook2sbsform.xsl \
	-s:$1 | \
	./linebreak.sh
