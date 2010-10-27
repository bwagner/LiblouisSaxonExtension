#!/bin/sh

./saxon.sh \
	-xsl:xsl/dtbook2sbsform.xsl \
	-s:$1 | \
	./linebreak.sh
