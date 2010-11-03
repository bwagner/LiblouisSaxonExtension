#!/bin/sh

# Copyright (C) 2010 Swiss Library for the Blind, Visually Impaired and Print Disabled
#
# This file is part of LiblouisSaxonExtension.
#
# LiblouisSaxonExtension is free software: you can redistribute it
# and/or modify it under the terms of the GNU Lesser General Public
# License as published by the Free Software Foundation, either
# version 3 of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
# Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public
# License along with this program. If not, see
# <http://www.gnu.org/licenses/>.

if [ $# != 1 ] ; then
	PRG=`basename $0` 
	echo "Usage: $PRG dtbook.xml\n"
	echo "\tone dtbook xml source file expected. Exiting.\n"
	exit 1
fi

./saxon.sh \
	-xsl:xsl/dtbook2sbsform.xsl \
	-s:$1 | \
	./linebreak.sh
