
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

SAXON=lib/saxon9he.jar
LOUIS=lib/jna.jar:lib/louis.jar
LOUIS_TRANSFORM_FACTORY=-Djavax.xml.transform.TransformerFactory=org.liblouis.transformerfactory.LouisExtensionTransformerFactoryImpl
LOUIS_SAXON_EXT=bin
UTFX=.:utfx_lib/avalon.jar:utfx_lib/batik.jar:utfx_lib/fop.jar:utfx_lib/JimiProClasses.zip:utfx_lib/junit.jar:utfx_lib/log4j-1.2.8.jar:utfx_lib/resolver.jar:utfx_lib/utfxPatched.jar:utfx_lib/xalan.jar:utfx_lib/xercesImpl.jar:utfx_lib/xercesSamples.jar:utfx_lib/xml-apis.jar
UTFX_TEST=-Dutfx.test.file=test_xsl/dtbook2sbsform_test.xml

java \
	$LOUIS_TRANSFORM_FACTORY \
	$UTFX_TEST \
	-cp $SAXON:$LOUIS:$LOUIS_SAXON_EXT:$UTFX \
	 utfx.runner.TestRunner utfx.framework.XSLTRegressionTest
