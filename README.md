Liblouis Saxon Extension
========================

This project provides a saxon extension that allows to translate text nodes to braille using liblouis from within xsl. 

It does this by providing a specialized `javax.xml.transform.sax.SAXTransformerFactory`
that can be used to configure applications that respect the
System property `"javax.xml.transform.TransformerFactory"`.

It uses [saxon](http://saxon.sourceforge.net/) with a [java extension](https://github.com/bwagner/LiblouisSaxonExtension)
that offers translating text into braille using [liblouis](http://code.google.com/p/liblouis/).

Usage `org.liblouis.LouisExtensionTransformerFactoryImpl`
--------------------------------------------------------

    java -Djavax.xml.transform.sax.SAXTransformerFactory YourAppThatUsesJaxp

Examples can be found in the xsl tests which are performed using
[utf-x](http://utf-x.sourceforge.net/) (we're using the svn version, which has been ported to work with saxon9he).
See utfx.sh shell script in the project [dtbooktosbsform](https://github.com/bwagner/dtbooktosbsform).

Prerequisite installs
------------------------

* [java](http://java.sun.com)
* [liblouis](http://code.google.com/p/liblouis/)

Authors
-------

**Christian Egli**

+ https://github.com/egli

**Bernhard Wagner**

+ http://xmlizer.net
+ http://github.com/bwagner

License
---------------------

Copyright 2011 SBS.

Licensed under GNU Lesser General Public License as published by the Free Software Foundation,
either [version 3](http://www.gnu.org/licenses/gpl-3.0.html) of the License, or (at your option) any later version.
