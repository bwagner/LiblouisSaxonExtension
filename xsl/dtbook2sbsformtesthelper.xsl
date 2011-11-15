<?xml version="1.0" encoding="utf-8"?>

	<!-- Copyright (C) 2010 Swiss Library for the Blind, Visually Impaired and Print Disabled -->
	
	<!-- This file is part of LiblouisSaxonExtension. -->
	
	<!-- LiblouisSaxonExtension is free software: you can redistribute it -->
	<!-- and/or modify it under the terms of the GNU Lesser General Public -->
	<!-- License as published by the Free Software Foundation, either -->
	<!-- version 3 of the License, or (at your option) any later version. -->
	
	<!-- This program is distributed in the hope that it will be useful, -->
	<!-- but WITHOUT ANY WARRANTY; without even the implied warranty of -->
	<!-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU -->
	<!-- Lesser General Public License for more details. -->
	
	<!-- You should have received a copy of the GNU Lesser General Public -->
	<!-- License along with this program. If not, see -->
	<!-- <http://www.gnu.org/licenses/>. -->
	
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:dtb="http://www.daisy.org/z3986/2005/dtbook/" xmlns:louis="http://liblouis.org/liblouis"
  xmlns:brl="http://www.daisy.org/z3986/2009/braille/" xmlns:my="http://my-functions"
  xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:data="http://sbsform.ch/data"
  exclude-result-prefixes="dtb louis data my" extension-element-prefixes="my">

<xsl:include href="dtbook2sbsform.xsl"/>

  <xsl:template match="text()[contains(string(.),'tests-following-text-within-block')]">
    <xsl:value-of select="concat('bla',my:following-text-within-block(.),'blo')"/>
  </xsl:template>
   
  <xsl:template match="tests-preceding-text-within-block">
    <xsl:value-of select="concat('bla',my:preceding-text-within-block(.),'blo')"/>
  </xsl:template>
  

</xsl:stylesheet>
