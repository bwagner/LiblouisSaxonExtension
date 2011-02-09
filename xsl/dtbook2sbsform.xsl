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
	
  <xsl:output method="text" encoding="utf-8" indent="no"/>
  <xsl:strip-space elements="*"/>
  <xsl:preserve-space
    elements="dtb:p dtb:byline dtb:author dtb:li dtb:lic dtb:doctitle dtb:docauthor dtb:span dtb:line dtb:h1 dtb:h2 dtb:h3 dtb:h4 dtb:h5 dtb:h6"/>

  <xsl:param name="contraction">2</xsl:param>
  <xsl:param name="version">0</xsl:param>
  <xsl:param name="cells_per_line">28</xsl:param>
  <xsl:param name="lines_per_page">28</xsl:param>
  <xsl:param name="hyphenation" select="false()"/>
  <xsl:param name="toc_level">0</xsl:param>
  <xsl:param name="footer_level">0</xsl:param>
  <xsl:param name="show_original_page_numbers" select="true()"/>
  <xsl:param name="show_v_forms" select="true()"/>
  <xsl:param name="downshift_ordinals" select="true()"/>
  <xsl:param name="enable_capitalization" select="false()"/>
  <xsl:param name="detailed_accented_characters">de-accents-ch</xsl:param>
  <xsl:param name="include_macros" select="true()"/>
  <xsl:param name="footnote_placement">standard</xsl:param>

  <xsl:variable name="volumes">
    <xsl:value-of select="count(//brl:volume[@brl:grade=$contraction]) + 1"/>
  </xsl:variable>

  <xsl:variable name="book_type">
    <xsl:choose>
      <xsl:when test="//dtb:meta[@name='prod:series']/@content='PPP'">rucksack</xsl:when>
      <xsl:when test="//dtb:meta[@name='prod:series']/@content='SJW'">sjw</xsl:when>
      <xsl:otherwise>standard</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:function name="my:isLower" as="xs:boolean">
    <xsl:param name="char"/>
    <xsl:value-of select="$char=lower-case($char)"/>
  </xsl:function>

  <xsl:function name="my:isUpper" as="xs:boolean">
    <xsl:param name="char"/>
    <xsl:value-of select="$char=upper-case($char)"/>
  </xsl:function>

  <xsl:function name="my:isNumber" as="xs:boolean">
    <xsl:param name="number"/>
    <xsl:value-of select="number($number)=number($number)"/>
  </xsl:function>

  <xsl:function name="my:hasSameCase" as="xs:boolean">
    <xsl:param name="a"/>
    <xsl:param name="b"/>
    <xsl:value-of
      select="(my:isLower($a) and my:isLower($b)) or (my:isUpper($a) and my:isUpper($b))"/>
  </xsl:function>

  <xsl:function name="my:tokenizeByCase" as="item()*">
    <xsl:param name="string"/>
    <xsl:sequence select="tokenize(replace($string,'([0-9]+|[A-Z]+|[a-z]+)', '$1#'), '#')[.]"/>
  </xsl:function>

  <xsl:function name="my:containsDot" as="xs:boolean">
    <xsl:param name="string"/>
    <xsl:value-of select="contains($string,'.')"/>
  </xsl:function>

  <xsl:function name="my:ends-with-number" as="xs:boolean">
    <xsl:param name="string"/>
    <xsl:value-of select="matches($string, '\d$')"/>
  </xsl:function>

  <xsl:function name="my:ends-with-non-word" as="xs:boolean">
    <xsl:param name="string"/>
    <xsl:value-of select="empty($string) or matches($string, '\W$')"/>
  </xsl:function>

  <xsl:function name="my:ends-with-word" as="xs:boolean">
    <xsl:param name="string"/>
    <xsl:value-of select="not(empty($string)) and matches($string, '\w$')"/>
  </xsl:function>

  <xsl:function name="my:starts-with-non-word" as="xs:boolean">
    <xsl:param name="string"/>
    <xsl:value-of select="empty($string) or matches($string, '^\W')"/>
  </xsl:function>

  <xsl:function name="my:starts-with-word" as="xs:boolean">
    <xsl:param name="string"/>
    <xsl:value-of select="not(empty($string)) and matches($string, '^\w')"/>
  </xsl:function>

  <xsl:function name="my:starts-with-non-whitespace" as="xs:boolean">
    <xsl:param name="string"/>
    <xsl:value-of select="not(empty($string)) and matches($string, '^\S')"/>
  </xsl:function>

  <xsl:function name="my:ends-with-non-whitespace" as="xs:boolean">
    <xsl:param name="string"/>
    <xsl:value-of select="not(empty($string)) and matches($string, '\S$')"/>
  </xsl:function>

  <xsl:function name="my:starts-with-punctuation" as="xs:boolean">
    <xsl:param name="string"/>
    <xsl:value-of select="matches($string, '^\p{P}')"/>
  </xsl:function>

  <xsl:function name="my:starts-with-punctuation-word" as="xs:boolean">
    <xsl:param name="string"/>
    <xsl:value-of select="matches($string, '^(\p{P}|[-/])+\W')"/>
  </xsl:function>

  <xsl:function name="my:ends-with-punctuation-word" as="xs:boolean">
    <xsl:param name="string"/>
    <xsl:value-of select="matches($string, '\W([-/]|\p{P})+$')"/>
  </xsl:function>

  <xsl:template name="getTable">
    <xsl:param name="context" select="local-name()"/>
    <xsl:choose>
      <xsl:when test="lang('fr')">
        <xsl:choose>
          <xsl:when test="$contraction = 2">
            <xsl:text>Fr-Fr-g2.ctb</xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>fr-fr-g1.utb</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:when test="lang('it')">
        <xsl:text>it-it-g1.utb</xsl:text>
      </xsl:when>
      <xsl:when test="lang('en')">
        <xsl:choose>
          <xsl:when test="$contraction = 2">
            <xsl:text>en-us-g2.ctb</xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>en-us-g1.ctb</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:when test="lang('de')">
        <!-- handle explicit setting of the contraction -->
        <xsl:variable name="actual_contraction">
          <xsl:choose>
            <xsl:when test="ancestor-or-self::dtb:span[@brl:grade and @brl:grade &lt; $contraction]">
              <xsl:value-of select="ancestor-or-self::dtb:span/@brl:grade"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="$contraction"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <xsl:text>sbs.dis,</xsl:text>
        <xsl:text>sbs-de-core6.cti,</xsl:text>
        <xsl:text>sbs-de-accents.cti,</xsl:text>
        <xsl:text>sbs-special.cti,</xsl:text>
        <xsl:text>sbs-whitespace.mod,</xsl:text>
        <xsl:if
          test="$context = 'v-form' or $context = 'name_capitalized' or ($actual_contraction != '2' and $enable_capitalization = true())">
          <xsl:text>sbs-de-capsign.mod,</xsl:text>
        </xsl:if>
        <xsl:if
          test="$actual_contraction = '2' and not($context = 'abbr' and not(my:containsDot(.))) and $context != 'date_month' and $context != 'date_day' and $context !='name_capitalized'">
          <xsl:text>sbs-de-letsign.mod,</xsl:text>
        </xsl:if>
        <xsl:if test="$context != 'date_month' and $context != 'denominator'">
          <xsl:text>sbs-numsign.mod,</xsl:text>
        </xsl:if>
        <xsl:choose>
          <xsl:when
            test="$context = 'num_ordinal' or $context = 'date_day' or $context = 'denominator'">
            <xsl:text>sbs-litdigit-lower.mod,</xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>sbs-litdigit-upper.mod,</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
        <xsl:if test="$context != 'date_month' and $context != 'date_day'">
          <xsl:text>sbs-de-core.mod,</xsl:text>
        </xsl:if>
        <xsl:if
          test="$context = 'name_capitalized' or ($context = 'abbr' and not(my:containsDot(.))) or ($actual_contraction &lt;= '1' and $context != 'date_day' and $context != 'date_month')">
          <xsl:text>sbs-de-g0-core.mod,</xsl:text>
        </xsl:if>
        <xsl:if
          test="$actual_contraction = '1' and ($context != 'name_capitalized' and ($context != 'abbr' or my:containsDot(.)) and $context != 'date_month' and $context != 'date_day')">
          <xsl:if test="$hyphenation = true()">
            <xsl:text>sbs-de-g1-white.mod,</xsl:text>
          </xsl:if>
          <xsl:text>sbs-de-g1-core.mod,</xsl:text>
        </xsl:if>
        <xsl:if test="$actual_contraction = '2'">
          <xsl:if test="$context = 'place'">
            <xsl:text>sbs-de-g2-place.mod,</xsl:text>
          </xsl:if>
          <xsl:if test="$context = 'place' or $context = 'name'">
            <xsl:text>sbs-de-g2-name.mod,</xsl:text>
          </xsl:if>
          <xsl:if
            test="$context != 'name' and $context != 'name_capitalized' and $context != 'place' and ($context != 'abbr' or  my:containsDot(.)) and $context != 'date_day' and $context != 'date_month'">
            <xsl:if test="$hyphenation = true()">
              <xsl:text>sbs-de-g2-white.mod,</xsl:text>
            </xsl:if>
            <xsl:text>sbs-de-g2-core.mod,</xsl:text>
          </xsl:if>
        </xsl:if>
	<xsl:choose>
	  <xsl:when test="$hyphenation = false()">
	    <xsl:text>sbs-de-hyph-none.mod,</xsl:text>
	  </xsl:when>
	  <xsl:otherwise>
	    <xsl:choose>
	      <xsl:when test="lang('de-1901')">
		<xsl:text>sbs-de-hyph-old.mod,</xsl:text>
	      </xsl:when>
	      <xsl:otherwise>
		<xsl:text>sbs-de-hyph-new.mod,</xsl:text>
	      </xsl:otherwise>
	    </xsl:choose>
	  </xsl:otherwise>
	</xsl:choose>
        <xsl:if test="$context != 'date_month' and $context != 'date_day'">
          <xsl:choose>
            <xsl:when test="ancestor-or-self::dtb:span[@brl:accents = 'reduced']">
              <xsl:text>sbs-de-accents-reduced.mod,</xsl:text>
            </xsl:when>
            <xsl:when test="ancestor-or-self::dtb:span[@brl:accents = 'detailed']">
              <xsl:text>sbs-de-accents.mod,</xsl:text>
            </xsl:when>
            <xsl:otherwise>
              <!-- no local accents are defined -->
              <xsl:choose>
                <xsl:when test="$detailed_accented_characters = 'de-accents-ch'">
                  <xsl:text>sbs-de-accents-ch.mod,</xsl:text>
                </xsl:when>
                <xsl:when test="$detailed_accented_characters = 'de-accents-reduced'">
                  <xsl:text>sbs-de-accents-reduced.mod,</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:text>sbs-de-accents.mod,</xsl:text>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:if>
        <xsl:text>sbs-special.mod</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>en-us-g2.ctb</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="sbsform-macro-definitions">
    <xsl:variable name="braille_tables">
      <xsl:call-template name="getTable"/>
    </xsl:variable>
    <xsl:variable name="vform_braille_tables">
      <xsl:call-template name="getTable">
        <xsl:with-param name="context" select="'v-form'"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:text>&#10;x ======================= ANFANG SBSFORM.MAK =========================&#10;</xsl:text>
    <xsl:text>x Bei Aenderungen den ganzen Block in separate Makrodatei auslagern.&#10;&#10;</xsl:text>

    <xsl:text>xxxxxxxxxxxxxxxxxxxxxxxxxx book, body, rear xxxxxxxxxxxxxxxxxxxxxxxxxx&#10;&#10;</xsl:text>

    <xsl:text>y b BOOKb ; Anfang des Buches: Globale Einstellungen&#10;</xsl:text>
    <xsl:text>z&#10;</xsl:text>
    <xsl:text>i b=</xsl:text>
    <xsl:value-of select="$cells_per_line"/>
    <xsl:text>&#10;</xsl:text>
    <xsl:text>i s=</xsl:text>
    <xsl:value-of select="$lines_per_page"/>
    <xsl:text>&#10;</xsl:text>
    <xsl:if test="$footer_level &gt; 0">
      <xsl:text>I ~=j&#10;</xsl:text>
      <xsl:text>i k=0&#10;</xsl:text>
    </xsl:if>
    <xsl:text>y e BOOKb&#10;</xsl:text>

    <xsl:text>y b BOOKe ; Ende des Buches, evtl. Inhaltsverzeichnis&#10;</xsl:text>
    <xsl:text>y EndBook&#10;</xsl:text>
    <xsl:if test="$toc_level &gt; 0">
      <xsl:text>y Inhaltsv&#10;</xsl:text>
    </xsl:if>
    <xsl:text>&#10;y e BOOKe&#10;</xsl:text>

    <xsl:text>y b BODYb ; Begin Bodymatter&#10;</xsl:text>
    <xsl:text>R=X&#10;</xsl:text>
    <xsl:text>Y&#10;</xsl:text>
    <xsl:if test="$show_original_page_numbers = true()">
      <xsl:text>RX&#10;</xsl:text>
    </xsl:if>
    <xsl:text>&#10;y e BODYb&#10;</xsl:text>
    <xsl:text>y b BODYe ; Ende Bodymatter&#10;</xsl:text>
    <xsl:text>y e BODYe&#10;</xsl:text>

    <xsl:if test="//dtb:rearmatter">
      <xsl:text>y b REARb ; Begin Rearmatter&#10;</xsl:text>
      <xsl:text>z&#10;</xsl:text>
      <xsl:if test="$toc_level &gt; 0">
        <xsl:text>H`lm1&#10;</xsl:text>
      </xsl:if>
      <xsl:text>y e REARb&#10;</xsl:text>
      <xsl:text>y b REARe ; End Rearmatter&#10;</xsl:text>
      <xsl:text>y e REARe&#10;</xsl:text>
    </xsl:if>

    
    <xsl:if test="//dtb:frontmatter//dtb:level1[not(@class) or (@class!='titlepage' and @class!='toc')]">
      <xsl:text>&#10;xxxxxxxxxxxxxxxxxxxxxxxx Frontmatter Levels und Headings xxxxxxxxxxxxx&#10;</xsl:text>
      <xsl:if test="//dtb:frontmatter//dtb:level1[not(@class) or (@class!='titlepage' and @class!='toc')]/dtb:h1">
	<xsl:text>y b H1_FRONT&#10;</xsl:text>
	<xsl:text>n6&#10;</xsl:text>
	<xsl:text>L&#10;</xsl:text>
	<xsl:text>i f=1 l=1&#10;</xsl:text>
	<xsl:text>Y&#10;</xsl:text>
	<xsl:text>u&#10;</xsl:text>
	<xsl:text>i f=3 l=1&#10;</xsl:text>
	<xsl:text>y e H1_FRONT&#10;</xsl:text>
      </xsl:if>
      <xsl:if test="//dtb:frontmatter//dtb:level1[not(@class) or (@class!='titlepage' and @class!='toc')]//dtb:h2">
	<xsl:text>y b H2_FRONT&#10;</xsl:text>
	<xsl:text>n6&#10;</xsl:text>
	<xsl:text>L&#10;</xsl:text>
	<xsl:text>i f=1 l=1&#10;</xsl:text>
	<xsl:text>Y&#10;</xsl:text>
	<xsl:text>u&#10;</xsl:text>
	<xsl:text>i f=3 l=1&#10;</xsl:text>
	<xsl:text>y e H2_FRONT&#10;</xsl:text>
      </xsl:if>
      <xsl:if test="//dtb:frontmatter//dtb:level1[not(@class) or (@class!='titlepage' and @class!='toc')]//dtb:h3">
	<xsl:text>y b H3_FRONT&#10;</xsl:text>
	<xsl:text>n5&#10;</xsl:text>
	<xsl:text>L&#10;</xsl:text>
	<xsl:text>i f=1 l=1&#10;</xsl:text>
	<xsl:text>Y&#10;</xsl:text>
	<xsl:text>u,&#10;</xsl:text>
	<xsl:text>i f=3 l=1&#10;</xsl:text>
	<xsl:text>y e H3_FRONT&#10;</xsl:text>
      </xsl:if>
    </xsl:if>

    <xsl:text>&#10;xxxxxxxxxxxxxxxxxxxxxxxx Levels und Headings xxxxxxxxxxxxxxxxxxxxxxxxx&#10;</xsl:text>
    <xsl:text>y b LEVEL1b&#10;</xsl:text>
    <xsl:text>p&#10;</xsl:text>
    <xsl:text>Y&#10;</xsl:text>
    <xsl:text>y e LEVEL1b&#10;</xsl:text>
    <xsl:text>y b LEVEL1e&#10;</xsl:text>
    <xsl:text>y e LEVEL1e&#10;</xsl:text>
    <xsl:text>y b H1&#10;</xsl:text>
    <xsl:text>L&#10;</xsl:text>
    <xsl:text>i f=3 l=1&#10;</xsl:text>
    <xsl:text>i A=4 R=4&#10;</xsl:text>
    <xsl:text>t&#10;</xsl:text>
    <xsl:text>Y&#10;</xsl:text>
    <xsl:text>u-&#10;</xsl:text>
    <xsl:text>i A=0 R=0&#10;</xsl:text>
    <xsl:if test="$toc_level &gt; 0">
      <xsl:text>H`B+&#10;</xsl:text>
      <xsl:text>H`i F=1&#10;</xsl:text>
      <xsl:text>Y&#10;</xsl:text>
      <xsl:text>H`B-&#10;</xsl:text>
    </xsl:if>
    <xsl:if test="$footer_level &gt; 0">
      <xsl:text>~~&#10;</xsl:text>
      <xsl:text>Y&#10;</xsl:text>
    </xsl:if>
    <xsl:text>lm1&#10;</xsl:text>
    <xsl:text>y e H1&#10;</xsl:text>

    <xsl:if test="//dtb:level2">
      <xsl:text>&#10;y b LEVEL2b&#10;</xsl:text>
      <xsl:text>lm2&#10;</xsl:text>
      <xsl:text>n10&#10;</xsl:text>
      <xsl:text>Y&#10;</xsl:text>
      <xsl:text>y e LEVEL2b&#10;</xsl:text>
      <xsl:text>y b LEVEL2e&#10;</xsl:text>
      <xsl:text>y e LEVEL2e&#10;</xsl:text>
      <xsl:text>y b H2&#10;</xsl:text>
      <xsl:text>lm1&#10;</xsl:text>
      <xsl:text>i f=3 l=1&#10;</xsl:text>
      <xsl:text>w&#10;</xsl:text>
      <xsl:text>Y&#10;</xsl:text>
      <xsl:text>u&#10;</xsl:text>
      <xsl:if test="$toc_level &gt; 1">
        <xsl:text>H`B+&#10;</xsl:text>
        <xsl:text>H`i F=3&#10;</xsl:text>
        <xsl:text>Y&#10;</xsl:text>
        <xsl:text>H`B-&#10;</xsl:text>
      </xsl:if>
      <xsl:if test="$footer_level &gt; 1">
        <xsl:text>Y&#10;</xsl:text>
      </xsl:if>
      <xsl:text>y e H2&#10;</xsl:text>
    </xsl:if>

    <xsl:if test="//dtb:level3">
      <xsl:text>
y b LEVEL3b
lm1
n6
Y
y e LEVEL3b
y b LEVEL3e
y e LEVEL3e
y b H3
lm1
i f=3 l=1
w
Y
u,
</xsl:text>
      <xsl:if test="$toc_level &gt; 2">
        <xsl:text>H`B+&#10;</xsl:text>
        <xsl:text>H`i F=5&#10;</xsl:text>
        <xsl:text>Y&#10;</xsl:text>
        <xsl:text>H`B-&#10;</xsl:text>
      </xsl:if>
      <xsl:if test="$footer_level &gt; 2">
        <xsl:text>Y&#10;</xsl:text>
      </xsl:if>
      <xsl:text>y e H3&#10;</xsl:text>
    </xsl:if>

    <xsl:if test="//dtb:level4">
      <xsl:text>&#10;y b LEVEL4b&#10;</xsl:text>
      <xsl:text>lm1&#10;</xsl:text>
      <xsl:text>n4&#10;</xsl:text>
      <xsl:text>Y&#10;</xsl:text>
      <xsl:text>y e LEVEL4b&#10;</xsl:text>
      <xsl:text>y b LEVEL4e&#10;</xsl:text>
      <xsl:text>y e LEVEL4e&#10;</xsl:text>
      <xsl:text>y b H4&#10;</xsl:text>
      <xsl:text>lm1&#10;</xsl:text>
      <xsl:text>i f=3 l=1&#10;</xsl:text>
      <xsl:text>w&#10;</xsl:text>
      <xsl:text>Y&#10;</xsl:text>
      <xsl:if test="$toc_level &gt; 3">
        <xsl:text>H`B+&#10;</xsl:text>
        <xsl:text>H`i F=7&#10;</xsl:text>
        <xsl:text>Y&#10;</xsl:text>
        <xsl:text>H`B-&#10;</xsl:text>
      </xsl:if>
      <xsl:if test="$footer_level &gt; 3">
        <xsl:text>Y&#10;</xsl:text>
      </xsl:if>
      <xsl:text>y e H4&#10;</xsl:text>
    </xsl:if>

    <xsl:if test="//dtb:level5">
      <xsl:text>&#10;y b LEVEL5b&#10;</xsl:text>
      <xsl:text>lm1&#10;</xsl:text>
      <xsl:text>n4&#10;</xsl:text>
      <xsl:text>Y&#10;</xsl:text>
      <xsl:text>y e LEVEL5b&#10;</xsl:text>
      <xsl:text>y b LEVEL5e&#10;</xsl:text>
      <xsl:text>y e LEVEL5e&#10;</xsl:text>
      <xsl:text>y b H5&#10;</xsl:text>
      <xsl:text>lm1&#10;</xsl:text>
      <xsl:text>i f=3 l=1&#10;</xsl:text>
      <xsl:text>w&#10;</xsl:text>
      <xsl:text>Y&#10;</xsl:text>
      <xsl:if test="$toc_level &gt; 4">
        <xsl:text>H`B+&#10;</xsl:text>
        <xsl:text>H`i F=9&#10;</xsl:text>
        <xsl:text>Y&#10;</xsl:text>
        <xsl:text>H`B-&#10;</xsl:text>
      </xsl:if>
      <xsl:if test="$footer_level &gt; 4">
        <xsl:text>Y&#10;</xsl:text>
      </xsl:if>
      <xsl:text>y e H5&#10;</xsl:text>
    </xsl:if>

    <xsl:if test="//dtb:level6">
      <xsl:text>&#10;y b LEVEL6b&#10;</xsl:text>
      <xsl:text>lm1&#10;</xsl:text>
      <xsl:text>n4&#10;</xsl:text>
      <xsl:text>Y&#10;</xsl:text>
      <xsl:text>y e LEVEL6b&#10;</xsl:text>
      <xsl:text>y b LEVEL6e&#10;</xsl:text>
      <xsl:text>y e LEVEL6e&#10;</xsl:text>
      <xsl:text>y b H6&#10;</xsl:text>
      <xsl:text>lm1&#10;</xsl:text>
      <xsl:text>i f=3 l=1&#10;</xsl:text>
      <xsl:text>w&#10;</xsl:text>
      <xsl:text>Y&#10;</xsl:text>
      <xsl:if test="$toc_level &gt; 5">
	<xsl:text>H`B+&#10;</xsl:text>
	<xsl:text>H`i F=11&#10;</xsl:text>
	<xsl:text>Y&#10;</xsl:text>
	<xsl:text>H`B-&#10;</xsl:text>
      </xsl:if>
      <xsl:if test="$footer_level &gt; 5">
	<xsl:text>Y&#10;</xsl:text>
      </xsl:if>
      <xsl:text>y e H6&#10;</xsl:text>
    </xsl:if>

    <xsl:if test="//dtb:*[@brl:class]">
      <xsl:text>&#10;xxxxxxxxxxxxxxxxxxxx Makros mit Class Attributen xxxxxxxxxxxxxxxxxxxx&#10;</xsl:text>
      <!-- Elements that only have a start macro -->
      <xsl:for-each-group select="//dtb:author[@brl:class]|//dtb:byline[@brl:class]|//dtb:li[@brl:class]|//dtb:p[@brl:class]|//dtb:h1[@brl:class]|//dtb:h2[@brl:class]|//dtb:h3[@brl:class]|//dtb:h4[@brl:class]|//dtb:h5[@brl:class]|//dtb:h6[@brl:class]" group-by="local-name()">
	<xsl:variable name="element-name" select="current-grouping-key()"/>
	<xsl:variable name="makro-name" select="upper-case($element-name)"/>
	<xsl:for-each select="distinct-values(//dtb:*[local-name() = $element-name]/@brl:class)">
	  <xsl:text>&#10;y b </xsl:text>
	  <xsl:value-of select="$makro-name"/><xsl:text>_</xsl:text>
	  <xsl:value-of select="."/><xsl:text>&#10;</xsl:text>
	  <xsl:text>X TODO: Fix this macro&#10;</xsl:text>
	  <xsl:text>y e </xsl:text>
	  <xsl:value-of select="$makro-name"/><xsl:text>_</xsl:text>
	  <xsl:value-of select="."/><xsl:text>&#10;&#10;</xsl:text>
	</xsl:for-each>
      </xsl:for-each-group>
      <!-- Elements that have both a start and an end macro -->
      <xsl:for-each-group select="//dtb:blockquote[@brl:class]|//dtb:epigraph[@brl:class]|//dtb:list[@brl:class]|//dtb:poem[@brl:class]|//dtb:linegroup[@brl:class]|//dtb:line[@brl:class]|//dtb:div[@brl:class]" group-by="local-name()">
	<xsl:variable name="element-name" select="current-grouping-key()"/>
	<xsl:variable name="makro-name" >
	  <xsl:choose>
	    <xsl:when test="$element-name = 'blockquote'">BLQUO</xsl:when>
	    <xsl:when test="$element-name = 'epigraph'">EPIGR</xsl:when>
	    <xsl:otherwise>
	      <xsl:value-of select="upper-case($element-name)"/>
	    </xsl:otherwise>
	  </xsl:choose>
	</xsl:variable>
	<xsl:for-each select="distinct-values(//dtb:*[local-name() = $element-name]/@brl:class)">
	  <xsl:text>&#10;y b </xsl:text>
	  <xsl:value-of select="$makro-name"/><xsl:text>b_</xsl:text>
	  <xsl:value-of select="."/><xsl:text>&#10;</xsl:text>
	  <xsl:text>X TODO: Fix this macro&#10;</xsl:text>
	  <xsl:text>y e </xsl:text>
	  <xsl:value-of select="$makro-name"/><xsl:text>b_</xsl:text>
	  <xsl:value-of select="."/><xsl:text>&#10;&#10;</xsl:text>
	  <xsl:text>&#10;y b </xsl:text>
	  <xsl:value-of select="$makro-name"/><xsl:text>e_</xsl:text>
	  <xsl:value-of select="."/><xsl:text>&#10;</xsl:text>
	  <xsl:text>X TODO: Fix this macro&#10;</xsl:text>
	  <xsl:text>y e </xsl:text>
	  <xsl:value-of select="$makro-name"/><xsl:text>e_</xsl:text>
	  <xsl:value-of select="."/><xsl:text>&#10;&#10;</xsl:text>
	</xsl:for-each>
      </xsl:for-each-group>
    </xsl:if>

    <xsl:if test="//dtb:note and $footnote_placement != 'standard'">
      <xsl:text>&#10;xxxxxxxxxxxxxxxxxxxx Notes xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx&#10;</xsl:text>
      <xsl:text>y b Notes&#10;</xsl:text>
      <xsl:text>X TODO: Fix this macro&#10;</xsl:text>
      <xsl:text>y e Notes&#10;</xsl:text>
    </xsl:if>

    <xsl:if test="//dtb:p[not(@brl:class)]">
      <xsl:text>&#10;xxxxxxxxxxxxxxxxxxxx Absatz, Leerzeile, Separator xxxxxxxxxxxxxxxxxxxx&#10;</xsl:text>
      <xsl:text>y b P&#10;</xsl:text>
      <xsl:text>a&#10;</xsl:text>
      <xsl:text>y e P&#10;</xsl:text>
    </xsl:if>

    <xsl:if test="//dtb:p[not(@brl:class) and contains(@class, 'precedingemptyline')]">
      <xsl:text>y b BLANK&#10;</xsl:text>
      <xsl:text>lm1&#10;</xsl:text>
      <xsl:text>n2&#10;</xsl:text>
      <xsl:text>y e BLANK&#10;</xsl:text>
    </xsl:if>

    <xsl:if test="//dtb:p[not(@brl:class) and contains(@class, 'precedingseparator')]">
      <xsl:text>y b SEPARATOR&#10;</xsl:text>
      <xsl:text>lm1&#10;</xsl:text>
      <xsl:text>t::::::&#10;</xsl:text>
      <xsl:text>lm1&#10;</xsl:text>
      <xsl:text>y e SEPARATOR&#10;</xsl:text>
    </xsl:if>

    <xsl:if test="//dtb:p[not(@brl:class) and contains(@class, 'noindent')]">
      <xsl:text>y b P_noi&#10;</xsl:text>
      <xsl:text>w&#10;</xsl:text>
      <xsl:text>y e P_noi&#10;</xsl:text>
    </xsl:if>

    <xsl:if test="//dtb:author[not(@brl:class)]">
      <xsl:text>y b AUTHOR&#10;</xsl:text>
      <xsl:text>r&#10;</xsl:text>
      <xsl:text>y e AUTHOR&#10;</xsl:text>
    </xsl:if>

    <xsl:if test="//dtb:byline[not(@brl:class)]">
      <xsl:text>y b BYLINE&#10;</xsl:text>
      <xsl:text>r&#10;</xsl:text>
      <xsl:text>y e BYLINE&#10;</xsl:text>
    </xsl:if>

    <xsl:if test="//dtb:blockquote[not(@brl:class)]">
      <xsl:text>&#10;xxxxxxxxxxxxxxxxxxxxxxxxxxxxx Blockquote xxxxxxxxxxxxxxxxxxxxxxxxxxxxx&#10;</xsl:text>
      <xsl:text>y b BLQUOb&#10;</xsl:text>
      <xsl:text>lm1&#10;</xsl:text>
      <xsl:text>n2&#10;</xsl:text>
      <xsl:text>i A=2&#10;</xsl:text>
      <xsl:text>y e BLQUOb&#10;</xsl:text>
      <xsl:text>y b BLQUOe&#10;</xsl:text>
      <xsl:text>i A=0&#10;</xsl:text>
      <xsl:text>lm1&#10;</xsl:text>
      <xsl:text>n2&#10;</xsl:text>
      <xsl:text>y e BLQUOe&#10;</xsl:text>
    </xsl:if>

    <xsl:if test="//dtb:epigraph[not(@brl:class)]">
      <xsl:text>
xxxxxxxxxxxxxxxxxxxxxxxxxxxxx Epigraph xxxxxxxxxxxxxxxxxxxxxxxxxxxxx
y b EPIGRb
lm1
n2
i A=4
y e EPIGRb
y b EPIGRe
i A=0
lm1
n2
y e EPIGRe
</xsl:text>
    </xsl:if>

    <xsl:if test="//dtb:poem[not(@brl:class)]|//dtb:line[not(@brl:class)]">
      <xsl:text>&#10;xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx Poem xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx;&#10;</xsl:text>
      <xsl:text>y b POEMb&#10;</xsl:text>
      <xsl:text>lm1&#10;</xsl:text>
      <xsl:text>i f=1 l=3&#10;</xsl:text>
      <xsl:text>n4&#10;</xsl:text>
      <xsl:text>i A=2&#10;</xsl:text>
      <xsl:text>y e POEMb&#10;</xsl:text>
      <xsl:text>y b POEMe&#10;</xsl:text>
      <xsl:text>i A=0&#10;</xsl:text>
      <xsl:text>i f=3 l=1&#10;</xsl:text>
      <xsl:text>lm1&#10;</xsl:text>
      <xsl:text>n2&#10;</xsl:text>
      <xsl:text>y e POEMe&#10;&#10;</xsl:text>
      
      <xsl:text>y b LINEb&#10;</xsl:text>
      <xsl:text>a&#10;</xsl:text>
      <xsl:text>B+&#10;</xsl:text>
      <xsl:text>y e LINEb&#10;</xsl:text>
      <xsl:text>y b LINEe&#10;</xsl:text>
      <xsl:text>B-&#10;</xsl:text>
      <xsl:text>y e LINEe&#10;</xsl:text>
    </xsl:if>

    <xsl:if test="//dtb:linegroup[not(@brl:class)]">
      <xsl:text>&#10;y b LINEGRb&#10;</xsl:text>
      <xsl:text>lm1&#10;</xsl:text>
      <xsl:text>i f=1 l=3&#10;</xsl:text>
      <xsl:text>n2&#10;</xsl:text>
      <xsl:text>y e LINEGRb&#10;</xsl:text>
      <xsl:text>y b LINEGRe&#10;</xsl:text>
      <xsl:text>i f=3 l=1&#10;</xsl:text>
      <xsl:text>y e LINEGRe&#10;</xsl:text>
    </xsl:if>

    <xsl:if test="//dtb:list[not(@brl:class)]|//dtb:li[not(@brl:class)]">
      <xsl:text>&#10;xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx Listen xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx&#10;&#10;</xsl:text>

      <xsl:text>y b PLISTb ; Vorformatierte Liste&#10;</xsl:text>
      <xsl:text>lm1&#10;</xsl:text>
      <xsl:text>i f=1 l=3&#10;</xsl:text>
      <xsl:text>n2&#10;</xsl:text>
      <xsl:text>y e PLISTb&#10;</xsl:text>
      <xsl:text>y b PLISTe&#10;</xsl:text>
      <xsl:text>i f=3 l=1&#10;</xsl:text>
      <xsl:text>lm1&#10;</xsl:text>
      <xsl:text>n2&#10;</xsl:text>
      <xsl:text>y e PLISTe&#10;</xsl:text>

      <xsl:text>y b LI&#10;</xsl:text>
      <xsl:text>a&#10;</xsl:text>
      <xsl:text>y e LI&#10;</xsl:text>
    </xsl:if>

    <xsl:text>&#10;xxxxxxxxxxxxxxxxxxxxxxxxxxx Bandeinteilung xxxxxxxxxxxxxxxxxxxxxxxxxxx&#10;</xsl:text>
    <xsl:text>y b BrlVol&#10;</xsl:text>
    <xsl:text>?vol:vol+1&#10;</xsl:text>
    <xsl:text>y Titlepage&#10;</xsl:text>
    <xsl:if test="$volumes &gt; 1 and $toc_level &gt; 0">
      <xsl:text>&#10;xy InhTit&#10;</xsl:text>
      <xsl:text>H`lm1&#10;</xsl:text>
      <xsl:text>H`n5&#10;</xsl:text>
      <xsl:choose>
        <xsl:when test="$volumes &lt; 13">
          <xsl:text>"H`t%B</xsl:text>
          <xsl:value-of select="louis:translate(string($braille_tables),'er')"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>"H`t%B</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:value-of select="louis:translate(string($braille_tables),' Band')"/>
      <xsl:text>&#10;H`lm1&#10;</xsl:text>
    </xsl:if>
    <xsl:text>&#10;y e BrlVol&#10;</xsl:text>

    <xsl:if test="//brl:volume">
      <xsl:text>y b EndVol
B+
L
tCCCCCCCCCCCC
t
 </xsl:text>
      <xsl:value-of select="louis:translate(string($braille_tables),'Ende des')"/>
      <xsl:choose>
        <xsl:when test="$volumes &gt; 12">
          <xsl:text>&#10;" %B&#10; </xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:choose>
            <xsl:when test="$contraction = 2">
              <xsl:text>&#10;" %BC&#10; </xsl:text>
            </xsl:when>
            <xsl:otherwise>
              <xsl:text>&#10;" %BEN&#10; </xsl:text>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:value-of select="louis:translate(string($braille_tables),'Bandes')"/>
      <xsl:text>
B-
y e EndVol
</xsl:text>
    </xsl:if>

    <xsl:text>&#10;xxxxxxxxxxxxxxxxxxxxxxxxxxxx Hilfsmakros xxxxxxxxxxxxxxxxxxxxxxxxxxxxx&#10;</xsl:text>
    <xsl:if test="$toc_level &gt; 0">
      <xsl:text>y b Inhaltsv
E
P1
~~
I ~=j
L
t~
 </xsl:text>
      <xsl:value-of select="louis:translate(string($braille_tables),'Inhaltsverzeichnis')"/>
      <xsl:text>
u-
lm1
y e Inhaltsv
</xsl:text>
    </xsl:if>

    <xsl:text>y b EndBook
lm1
B+
L
tCCCCCCCCCCCC
t
 </xsl:text>
    <xsl:value-of select="louis:translate(string($braille_tables),'Ende des Buches')"/>
    <xsl:text>
t======
B-
y e EndBook
</xsl:text>

    <xsl:if test="$volumes &gt; 1 and $toc_level &gt; 0">
      <xsl:text>
y b InhTit                   ; Hilfsmakro zum Inhaltsverzeichnis der Einzelbaende
H`z
H`P1
I ~=j
i k=0
H`L
H`t~~</xsl:text>
      <xsl:value-of select="louis:translate(string($braille_tables),'Inhaltsverzeichnis')"/>
      <xsl:text>
H`u-
H`lm1
y e InhTit
</xsl:text>
    </xsl:if>

    <xsl:if test="$volumes &gt; 12">
      <!-- FIXME: numbers should be translated with liblouis -->
      <xsl:text>
y b Ziff   ; Hilfsmakro zum Uebersetzen der (tiefgestellten) Ziffern
?z=0
+R=Z)
?z=1
+R=Z,
?z=2
+R=Z;
?z=3
+R=Z:
?z=4
+R=Z/
?z=5
+R=Z?
?z=6
+R=Z+
?z=7
+R=Z=
?z=8
+R=Z(
?z=9
+R=B*
"R=B%B%Z
y e Ziff
</xsl:text>
    </xsl:if>

    <xsl:if test="$volumes &gt; 1">
      <xsl:text>y b Volumes&#10;t&#10; </xsl:text>
      <xsl:value-of select="louis:translate(string($braille_tables),'In ')"/>
      <xsl:choose>
        <xsl:when test="$volumes &lt; 13">
          <xsl:variable name="number">
            <xsl:choose>
              <xsl:when test="$volumes = '2'">zwei</xsl:when>
              <xsl:when test="$volumes = '3'">drei</xsl:when>
              <xsl:when test="$volumes = '4'">vier</xsl:when>
              <xsl:when test="$volumes = '5'">fünf</xsl:when>
              <xsl:when test="$volumes = '6'">sechs</xsl:when>
              <xsl:when test="$volumes = '7'">sieben</xsl:when>
              <xsl:when test="$volumes = '8'">acht</xsl:when>
              <xsl:when test="$volumes = '9'">neun</xsl:when>
              <xsl:when test="$volumes = '10'">zehn</xsl:when>
              <xsl:when test="$volumes = '11'">elf</xsl:when>
              <xsl:when test="$volumes = '12'">zwölf</xsl:when>
            </xsl:choose>
          </xsl:variable>
          <xsl:value-of select="louis:translate(string($braille_tables),string($number))"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="louis:translate(string($braille_tables),string($volumes))"/>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:value-of select="louis:translate(string($braille_tables),' Braillebänden')"/>
      <xsl:text>&#10;t&#10;</xsl:text>
      <xsl:choose>
        <xsl:when test="$volumes &lt; 13">
          <!-- bis zu zwölf Bänden in Worten -->
          <xsl:text>?vol=1&#10;+R=B</xsl:text>
          <xsl:value-of select="louis:translate(string($braille_tables),'erst')"/>
          <xsl:text>&#10;?vol=2&#10;+R=B</xsl:text>
          <xsl:value-of select="louis:translate(string($braille_tables),'zweit')"/>
          <xsl:if test="$volumes &gt; 2">
            <xsl:text>&#10;?vol=3&#10;+R=B</xsl:text>
            <xsl:value-of select="louis:translate(string($braille_tables),'dritt')"/>
          </xsl:if>
          <xsl:if test="$volumes &gt; 3">
            <xsl:text>&#10;?vol=4&#10;+R=B</xsl:text>
            <xsl:value-of select="louis:translate(string($braille_tables),'viert')"/>
          </xsl:if>
          <xsl:if test="$volumes &gt; 4">
            <xsl:text>&#10;?vol=5&#10;+R=B</xsl:text>
            <xsl:value-of select="louis:translate(string($braille_tables), 'fünft')"/>
          </xsl:if>
          <xsl:if test="$volumes &gt; 5">
            <xsl:text>&#10;?vol=6&#10;+R=B</xsl:text>
            <xsl:value-of select="louis:translate(string($braille_tables), 'sechst')"/>
          </xsl:if>
          <xsl:if test="$volumes &gt; 6">
            <xsl:text>&#10;?vol=7&#10;+R=B</xsl:text>
            <xsl:value-of select="louis:translate(string($braille_tables), 'siebt')"/>
          </xsl:if>
          <xsl:if test="$volumes &gt; 7">
            <xsl:text>&#10;?vol=8&#10;+R=B</xsl:text>
            <xsl:value-of select="louis:translate(string($braille_tables), 'acht')"/>
          </xsl:if>
          <xsl:if test="$volumes &gt; 8">
            <xsl:text>&#10;?vol=9&#10;+R=B</xsl:text>
            <xsl:value-of select="louis:translate(string($braille_tables), 'neunt')"/>
          </xsl:if>
          <xsl:if test="$volumes &gt; 9">
            <xsl:text>&#10;?vol=10&#10;+R=B</xsl:text>
            <xsl:value-of select="louis:translate(string($braille_tables), 'zehnt')"/>
          </xsl:if>
          <xsl:if test="$volumes &gt; 10">
            <xsl:text>&#10;?vol=11&#10;+R=B</xsl:text>
            <xsl:value-of select="louis:translate(string($braille_tables), 'elft')"/>
          </xsl:if>
          <xsl:if test="$volumes &gt; 11">
            <xsl:text>&#10;?vol=12&#10;+R=B</xsl:text>
            <xsl:value-of select="louis:translate(string($braille_tables), 'zwölft')"/>
          </xsl:if>
          <xsl:choose>
            <xsl:when test="$contraction = 2">
              <xsl:text>&#10;" %B7&#10;</xsl:text>
            </xsl:when>
            <xsl:otherwise>
              <xsl:text>&#10;" %BER&#10;</xsl:text>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>
xxx Zahl einfuegen (herabgesetzt) - Maximal 99
R=B#
?z:vol/10
?z>0
+y Ziff
?z:vol%10
y Ziff
" %B
</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:text> </xsl:text>
      <xsl:value-of select="louis:translate(string($braille_tables), 'Band')"/>
      <xsl:text>&#10;y e Volumes&#10;  </xsl:text>
    </xsl:if>
    <xsl:text>
xxxxxxxxxxxxxxxxxxxxxxxxxxxx Titelblatt xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
y b Titlepage
O
bb
L5
t
 </xsl:text>
    <xsl:apply-templates select="//dtb:docauthor"/>
    <xsl:text>
l2
t
 </xsl:text>
    <xsl:apply-templates select="//dtb:doctitle"/>
    <xsl:text>&#10;u-&#10;</xsl:text>
    <xsl:if test="$book_type = 'sjw'">
      <xsl:text>l2&#10;t&#10; </xsl:text>
      <xsl:call-template name="handle_abbr">
        <xsl:with-param name="context" select="'abbr'"/>
        <xsl:with-param name="content" select="'SJW-'"/>
      </xsl:call-template>
      <xsl:value-of
        select="louis:translate(string($braille_tables), 'Heft Nr.')"/>
      <xsl:value-of
        select="louis:translate(string($braille_tables), string(//dtb:meta[@name='prod:seriesNumber']/@content))"/>
      <xsl:text>&#10;</xsl:text>
    </xsl:if>
    <xsl:if test="$volumes &gt; 1">
      <!-- Leerzeilencheck hierhin verschoben, Leerzeile aus "y b Volumes" entfernt! -->
      <xsl:variable name="leer">
        <xsl:choose>
          <xsl:when test="$book_type = 'rucksack'">5</xsl:when>
          <xsl:when test="$book_type = 'sjw'">4</xsl:when>
          <xsl:otherwise>6</xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <xsl:text>&#10;l</xsl:text>
      <xsl:choose>
        <xsl:when test="$contraction = 2">
          <xsl:value-of select="$leer"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$leer -1"/>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:text>&#10;y Volumes&#10;</xsl:text>
    </xsl:if>
    <xsl:if test="$book_type = 'rucksack'">
      <xsl:choose>
        <xsl:when test="$contraction = 2">
          <xsl:text>lv22&#10;</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>lv21&#10;</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:text>t&#10; </xsl:text>
      <xsl:value-of
        select="louis:translate(string($braille_tables), 'Rucksackbuch Nr.')"/>
      <xsl:value-of
        select="louis:translate(string($braille_tables), string(//dtb:meta[@name='prod:seriesNumber']/@content))"/>
      <xsl:text>&#10;t&#10; </xsl:text>
      <xsl:text> PUNKT POINT PUNTO</xsl:text> <!-- FIXME: Pass this with grade 0 through liblouis " PUNKT POINT PUNTO"-->
      <xsl:text>&#10;</xsl:text>
    </xsl:if>
    <xsl:choose>
      <xsl:when test="$contraction = 2">
        <xsl:text>lv25&#10;</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>lv24&#10;</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:text>t&#10; </xsl:text>
    <xsl:value-of
      select="louis:translate(string($braille_tables), 'Schweizerische Bibliothek')"/>
    <xsl:text>&#10;t&#10; </xsl:text>
    <xsl:value-of
      select="louis:translate(string($braille_tables), 'für Blinde, Seh- und ')"/>
    <xsl:if test="not($contraction = 2)">
      <xsl:text>&#10;t&#10; </xsl:text>
    </xsl:if>
    <xsl:value-of
      select="louis:translate(string($braille_tables), 'Lesebehinderte')"/>
    <xsl:text>
p
L
i f=1 l=1
 </xsl:text>

    <xsl:choose>
      <xsl:when test="$book_type = 'sjw'">
        <xsl:value-of
          select="louis:translate(string($braille_tables), 'Brailleausgabe mit freundlicher Genehmigung des ')"/>
        <xsl:call-template name="handle_abbr">
          <xsl:with-param name="context" select="'abbr'"/>
          <xsl:with-param name="content" select="'SJW'"/>
        </xsl:call-template>
        <xsl:value-of
          select="louis:translate(string($braille_tables), ' Schweizerischen Jugenschriftenwerks, Zürich.')"/>
        <xsl:text>l#10; </xsl:text>
        <xsl:value-of
          select="louis:translate(string($braille_tables), 'Wir danken dem ')"/>
        <xsl:call-template name="handle_abbr">
          <xsl:with-param name="context" select="'abbr'"/>
          <xsl:with-param name="content" select="'SJW-'"/>
        </xsl:call-template>
        <xsl:value-of
          select="louis:translate(string($braille_tables), '¦Verlag für die Bereitstellung der Daten.')"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of
          select="louis:translate(string($braille_tables), 'Dieses Braillebuch ist die ausschließlich ')"/>
        <xsl:value-of
          select="louis:translate(string($braille_tables), 'für die Nutzung durch Lesebehinderte Menschen ')"/>
        <xsl:value-of
          select="louis:translate(string($braille_tables), 'bestimmte zugängliche Version eines urheberrechtlich ')"/>
        <xsl:value-of
          select="louis:translate(string($braille_tables), 'geschützten Werks. ')"/>
        <xsl:value-of
          select="louis:translate(string($vform_braille_tables), 'Sie ')"/>
        <xsl:value-of select="louis:translate(string($braille_tables), 'können ')"/>
        <xsl:value-of
          select="louis:translate(string($braille_tables), 'es im Rahmen des Urheberrechts persönlich nutzen, ')"/>
        <xsl:value-of
          select="louis:translate(string($braille_tables), 'dürfen es aber nicht weiter verbreiten oder öffentlich ')"/>
        <xsl:value-of
          select="louis:translate(string($braille_tables), 'zugänglich machen.')"/>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:if test="$book_type = 'rucksack'">
      <xsl:choose>
        <xsl:when test="$contraction = 2">
          <xsl:text>&#10;lv18&#10; </xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>&#10;lv17&#10; </xsl:text>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:text>PUNKT POINT PUNTO'- </xsl:text> <!-- FIXME: Pass this with grade 0 through liblouis "PUNKT POINT PUNTO &#x2013;"-->
      <xsl:text>&#10;a&#10; </xsl:text>
      <xsl:value-of
        select="louis:translate(string($braille_tables), 'Rucksackbuch Nr.')"/>
      <xsl:value-of
        select="louis:translate(string($braille_tables), string(//dtb:meta[@name='prod:seriesNumber']/@content))"/>
    </xsl:if>
    <xsl:choose>
      <xsl:when test="$contraction = 2">
        <xsl:text>&#10;lv21&#10; </xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>&#10;lv20&#10; </xsl:text>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:value-of
      select="louis:translate(string($braille_tables), 'Verlag, Satz und Druck')"/>
    <xsl:text>&#10;a&#10; </xsl:text>
    <xsl:value-of
      select="louis:translate(string($braille_tables), 'Schweizerische Bibliothek')"/>
    <xsl:text>&#10;a&#10; </xsl:text>
    <xsl:value-of
      select="louis:translate(string($braille_tables), 'für Blinde, Seh- und ')"/>
    <xsl:if test="not($contraction = 2)">
      <xsl:text>&#10;a&#10; </xsl:text>
    </xsl:if>
    <xsl:value-of
      select="louis:translate(string($braille_tables), 'Lesebehinderte, Zürich')"/>
    <xsl:text>&#10;a&#10; </xsl:text>
    <xsl:value-of
      select="louis:translate(string($braille_tables), 'www.sbs.ch')"/>
    <xsl:text>&#10;l&#10; </xsl:text>
    <xsl:call-template name="handle_abbr">
      <xsl:with-param name="context" select="'abbr'"/>
      <xsl:with-param name="content" select="'SBS'"/>
    </xsl:call-template>
    <xsl:text> </xsl:text>
    <xsl:value-of
      select="louis:translate(string($braille_tables), string(substring-before(//dtb:meta[@name='dc:Date']/@content,'-')))"/>
    <xsl:text>&#10;p&#10;xxx Titelblatt der Originalausgabe (Gestaltung der Vorlage nachempfinden)</xsl:text>
    <xsl:text>&#10;L5&#10; </xsl:text>
    <xsl:apply-templates select="//dtb:docauthor"/>
    <xsl:text>&#10;l2&#10; </xsl:text>
    <xsl:apply-templates select="//dtb:doctitle"/>
    <xsl:text>&#10;u-&#10;l&#10; </xsl:text>
    <xsl:apply-templates
      select="//dtb:frontmatter/dtb:level1[@class='titlepage']" mode="titlepage"/>
    <xsl:text>&#10;b&#10;</xsl:text>
    <xsl:text>O&#10;</xsl:text>
    <xsl:text>y e Titlepage&#10;</xsl:text>
    <xsl:text>xxx ====================== ENDE SBSFORM.MAK ====================== xxx&#10;</xsl:text>
  </xsl:template>

  <xsl:template name="rest-of-frontmatter">
    <xsl:text>&#10;y BOOKb&#10;</xsl:text>
    <xsl:if test="//dtb:note and $footnote_placement = 'standard'">
      <xsl:call-template name="insert_footnotes"/>
    </xsl:if>
    <xsl:text>y BrlVol&#10;</xsl:text>
    <xsl:if test="//dtb:frontmatter/dtb:level1[not(@class) or (@class!='titlepage' and @class!='toc')]">
      <xsl:text>xxxxxxxxxxxxxxxxxxxxxxxxxx Klappentext etc. xxxxxxxxxxxxxxxxxxxxxxxxxx&#10;</xsl:text>
      <xsl:text>O&#10;</xsl:text>
      <xsl:apply-templates
	  select="//dtb:frontmatter/dtb:level1[not(@class) or (@class!='titlepage' and @class!='toc')]"/>
      <xsl:text>O&#10;</xsl:text>
    </xsl:if>
    <xsl:text>&#10;xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx Buchinhalt xxxxxxxxxxxxxxxxxxxxxxxxxxxx&#10;</xsl:text>
  </xsl:template>

  <xsl:template match="/">
    <xsl:text>x </xsl:text>
    <xsl:value-of select="//dtb:docauthor"/>
    <xsl:text>: </xsl:text>
    <xsl:value-of select="//dtb:doctitle"/>
    <xsl:text>&#10;</xsl:text>
    <xsl:text>x Daisy Producer Version: </xsl:text>
    <xsl:value-of select="$version"/>
    <xsl:text>&#10;</xsl:text>
    <xsl:text>x SBS Braille Tables Version: </xsl:text>
    <!-- Use a special table to query the version of the SBS-specific (German) tables -->
    <xsl:value-of select="louis:translate('sbs-version.utb', '{{sbs-braille-tables-version}}')"/>
    <xsl:text>&#10;</xsl:text>
    <xsl:text>x contraction:</xsl:text>
    <xsl:value-of select="$contraction"/>
    <xsl:text>&#10;</xsl:text>
    <xsl:text>x cells_per_line:</xsl:text>
    <xsl:value-of select="$cells_per_line"/>
    <xsl:text>&#10;</xsl:text>
    <xsl:text>x lines_per_page:</xsl:text>
    <xsl:value-of select="$lines_per_page"/>
    <xsl:text>&#10;</xsl:text>
    <xsl:text>x hyphenation:</xsl:text>
    <xsl:value-of select="$hyphenation"/>
    <xsl:text>&#10;</xsl:text>
    <xsl:text>x toc_level:</xsl:text>
    <xsl:value-of select="$toc_level"/>
    <xsl:text>&#10;</xsl:text>
    <xsl:text>x show_original_page_numbers:</xsl:text>
    <xsl:value-of select="$show_original_page_numbers"/>
    <xsl:text>&#10;</xsl:text>
    <xsl:text>x show_v_forms:</xsl:text>
    <xsl:value-of select="$show_v_forms"/>
    <xsl:text>&#10;</xsl:text>
    <xsl:text>x downshift_ordinals:</xsl:text>
    <xsl:value-of select="$downshift_ordinals"/>
    <xsl:text>&#10;</xsl:text>
    <xsl:text>x enable_capitalization:</xsl:text>
    <xsl:value-of select="$enable_capitalization"/>
    <xsl:text>&#10;</xsl:text>
    <xsl:text>x detailed_accented_characters:</xsl:text>
    <xsl:value-of select="$detailed_accented_characters"/>
    <xsl:text>&#10;</xsl:text>
    <xsl:text>x include_macros:</xsl:text>
    <xsl:value-of select="$include_macros"/>
    <xsl:text>&#10;</xsl:text>
    <xsl:text>x ---------------------------------------------------------------------------&#10;</xsl:text>
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="dtb:dtbook">
    <xsl:choose>
      <xsl:when test="$include_macros = true()">
        <xsl:call-template name="sbsform-macro-definitions"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>&#10;U dtbook.mak&#10;</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:call-template name="rest-of-frontmatter"/>
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="dtb:head">
    <!-- ignore -->
  </xsl:template>

  <xsl:template match="dtb:meta">
    <!-- ignore -->
  </xsl:template>

  <xsl:template match="dtb:book">
    <xsl:apply-templates/>
    <xsl:text>&#10;y BOOKe&#10;</xsl:text>
  </xsl:template>

  <xsl:template match="dtb:frontmatter"> </xsl:template>

  <xsl:template match="dtb:bodymatter">
    <xsl:text>&#10;y BODYb&#10;</xsl:text>
    <xsl:text>i j=</xsl:text>
    <!-- value of first pagenum within body -->
    <xsl:value-of select="descendant::dtb:pagenum[1]/text()"/>
    <xsl:text>&#10;</xsl:text>
    <xsl:apply-templates/>
    <!-- Apply end notes of last volume -->
    <xsl:if test="$footnote_placement = 'end_vol'">
      <xsl:variable name="noterefs" select="//dtb:noteref[not(following::brl:volume[@brl:grade = $contraction])]"/>
      <xsl:variable name="notes" select="for $noteref in $noterefs return //dtb:note[@id=translate($noteref/@idref,'#','')]"/>
      <xsl:if test="exists($notes)">
	<xsl:text>&#10;y Notes&#10;</xsl:text>
	<xsl:for-each select="$notes">
	  <xsl:apply-templates />
	</xsl:for-each>
      </xsl:if>
    </xsl:if>
    <xsl:text>&#10;&#10;y BODYe&#10;</xsl:text>
  </xsl:template>

  <xsl:template match="dtb:doctitle">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="dtb:docauthor">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template name="handle_level_endnotes">
    <xsl:variable name="level">
      <xsl:choose>
	<xsl:when test="local-name() = 'level1'">1</xsl:when>
	<xsl:when test="local-name() = 'level2'">2</xsl:when>
	<xsl:when test="local-name() = 'level3'">3</xsl:when>
	<xsl:when test="local-name() = 'level4'">4</xsl:when>
	<xsl:otherwise>NoMatch</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:if test="$footnote_placement = concat('level', $level)">
      <xsl:variable name="noterefs" select="current()//dtb:noteref"/>
      <xsl:variable name="notes" select="for $noteref in $noterefs return //dtb:note[@id=translate($noteref/@idref,'#','')]"/>
      <xsl:if test="exists($notes)">
	<xsl:text>&#10;y Notes&#10;</xsl:text>
	<xsl:for-each select="$notes">
	  <xsl:apply-templates/>
	</xsl:for-each>
      </xsl:if>
    </xsl:if>
  </xsl:template>

  <!-- Frontmatter handling -->
  <xsl:template match="dtb:frontmatter//dtb:level1">
    <xsl:text>&#10;z&#10;</xsl:text>
    <xsl:apply-templates/>
    <xsl:text>&#10;</xsl:text>
  </xsl:template>

  <xsl:template match="dtb:frontmatter//dtb:level2|dtb:frontmatter//dtb:level3">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="dtb:frontmatter//dtb:h1|dtb:frontmatter//dtb:h2|dtb:frontmatter//dtb:h3">
    <xsl:variable name="level" select="number(substring(local-name(), 2))"/>
    <xsl:value-of select="concat('&#10;y H',$level,'_FRONT&#10; ')"/>
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="dtb:level1">
    <xsl:text>&#10;y LEVEL1b&#10;</xsl:text>
    <!-- add a comment if the first child is not a pagenum -->
    <xsl:if test="not(name(child::*[1])='pagenum')">
      <xsl:text>.xNOPAGENUM&#10;</xsl:text>
    </xsl:if>
    <xsl:apply-templates/>
    <xsl:call-template name="handle_level_endnotes"/>
    <xsl:text>&#10;y LEVEL1e&#10;</xsl:text>
  </xsl:template>

  <xsl:template match="dtb:level2">
    <xsl:text>&#10;y LEVEL2b&#10;</xsl:text>
    <!-- add a comment if the first child is not a pagenum -->
    <xsl:if test="not(name(child::*[1])='pagenum')">
      <xsl:text>.xNOPAGENUM&#10;</xsl:text>
    </xsl:if>
    <xsl:apply-templates/>
    <xsl:call-template name="handle_level_endnotes"/>
    <xsl:text>&#10;y LEVEL2e&#10;</xsl:text>
  </xsl:template>

  <xsl:template match="dtb:level3">
    <xsl:text>&#10;y LEVEL3b&#10;</xsl:text>
    <!-- add a comment if the first child is not a pagenum -->
    <xsl:if test="not(name(child::*[1])='pagenum')">
      <xsl:text>.xNOPAGENUM&#10;</xsl:text>
    </xsl:if>
    <xsl:apply-templates/>
    <xsl:call-template name="handle_level_endnotes"/>
    <xsl:text>&#10;y LEVEL3e&#10;</xsl:text>
  </xsl:template>

  <xsl:template match="dtb:level4">
    <xsl:text>&#10;y LEVEL4b&#10;</xsl:text>
    <!-- add a comment if the first child is not a pagenum -->
    <xsl:if test="not(name(child::*[1])='pagenum')">
      <xsl:text>.xNOPAGENUM&#10;</xsl:text>
    </xsl:if>
    <xsl:apply-templates/>
    <xsl:call-template name="handle_level_endnotes"/>
    <xsl:text>&#10;y LEVEL4e&#10;</xsl:text>
  </xsl:template>

  <xsl:template match="dtb:level5">
    <xsl:text>&#10;y LEVEL5b&#10;</xsl:text>
    <!-- add a comment if the first child is not a pagenum -->
    <xsl:if test="not(name(child::*[1])='pagenum')">
      <xsl:text>.xNOPAGENUM&#10;</xsl:text>
    </xsl:if>
    <xsl:apply-templates/>
    <xsl:text>&#10;y LEVEL5e&#10;</xsl:text>
  </xsl:template>

  <xsl:template match="dtb:level6">
    <xsl:text>&#10;y LEVEL6b&#10;</xsl:text>
    <!-- add a comment if the first child is not a pagenum -->
    <xsl:if test="not(name(child::*[1])='pagenum')">
      <xsl:text>.xNOPAGENUM&#10;</xsl:text>
    </xsl:if>
    <xsl:apply-templates/>
    <xsl:text>&#10;y LEVEL6e&#10;</xsl:text>
  </xsl:template>

  <xsl:template match="dtb:p" mode="titlepage">
    <xsl:text>&#10;a&#10; </xsl:text>
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="dtb:note/dtb:p">
    <xsl:variable name="braille_tables">
      <xsl:call-template name="getTable"/>
    </xsl:variable>
    <xsl:text>&#10;</xsl:text>
    <xsl:choose>
      <xsl:when test="position()=1">
	<xsl:choose>
	  <xsl:when test="$footnote_placement = 'standard'">
	    <xsl:text>p </xsl:text>
	  </xsl:when>
	  <xsl:otherwise>
	    <xsl:text>a </xsl:text>
	  </xsl:otherwise>
	</xsl:choose>
	<xsl:text>&#10; </xsl:text>
	<!-- Place the foot note number in the first para of the foot note -->
	<xsl:variable name="idref" select="concat('#',../@id)"/>
	<xsl:variable name="corresponding_noteref" select="//dtb:noteref[@idref=$idref][1]"/>
	<xsl:variable name="note_number" select="count($corresponding_noteref/preceding::dtb:noteref)+1"/>
	<xsl:variable name="prefix" select="if ($footnote_placement = 'standard') then '*' else ''"/>
	<xsl:value-of select="concat(louis:translate(string($braille_tables), concat($prefix, $note_number)), ' ')"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>w </xsl:text>
	<xsl:text>&#10; </xsl:text>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="dtb:p">
    <xsl:text>&#10;</xsl:text>
    <xsl:if test="contains(@class, 'precedingseparator')">
      <xsl:text>y SEPARATOR&#10;</xsl:text>
    </xsl:if>
    <xsl:if test="contains(@class, 'precedingemptyline')">
      <xsl:text>y BLANK&#10;</xsl:text>
    </xsl:if>
    <xsl:choose>
      <xsl:when test="contains(@class, 'noindent')">
        <xsl:text>y P_noi&#10; </xsl:text>
      </xsl:when>
      <xsl:when test="exists(@brl:class)">
        <xsl:text>y P_</xsl:text><xsl:value-of select="@brl:class"/><xsl:text>&#10; </xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>y P&#10; </xsl:text>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="dtb:list">
    <xsl:text>&#10;y PLISTb</xsl:text>
    <xsl:if test="@brl:class"><xsl:text>_</xsl:text><xsl:value-of select="@brl:class"/></xsl:if>
    <xsl:text>&#10;</xsl:text>
    <xsl:apply-templates/>
    <xsl:text>&#10;y PLISTe</xsl:text>
    <xsl:if test="@brl:class"><xsl:text>_</xsl:text><xsl:value-of select="@brl:class"/></xsl:if>
    <xsl:text>&#10;</xsl:text>
  </xsl:template>

  <xsl:template match="dtb:li">
    <xsl:text>&#10;y LI</xsl:text>
    <xsl:if test="@brl:class"><xsl:text>_</xsl:text><xsl:value-of select="@brl:class"/></xsl:if>
    <xsl:text>&#10; </xsl:text>
    <xsl:apply-templates/>
    <xsl:text>&#10;</xsl:text>
  </xsl:template>

  <xsl:template match="dtb:lic">
    <xsl:apply-templates/>
    <xsl:text> </xsl:text>
  </xsl:template>

  <xsl:template match="dtb:pagenum">
    <xsl:text>&#10;j </xsl:text>
    <xsl:value-of select="text()"/>
    <!-- Add a newline unless the following node is another pagenum
         (ignore intermediate empty text nodes and comment nodes -->
    <xsl:variable name="following-nodes"
      select="following-sibling::* | following-sibling::text()[normalize-space(.)]"/>
    <!-- FIXME: this doesn't properly handle comment nodes -->
    <xsl:if test="not($following-nodes[position() = 1 and local-name() = 'pagenum'])">
      <!-- add a space for the following inline elements -->
      <xsl:text>&#10; </xsl:text>
    </xsl:if>
  </xsl:template>

  <xsl:template match="dtb:h1|dtb:h2|dtb:h3|dtb:h4|dtb:h5|dtb:h6">
    <xsl:variable name="level" select="number(substring(local-name(), 2))"/>
    <xsl:text>&#10;y H</xsl:text>
    <xsl:value-of select="$level"/>
    <xsl:if test="@brl:class"><xsl:text>_</xsl:text><xsl:value-of select="@brl:class"/></xsl:if>
    <xsl:text>&#10; </xsl:text>
    <xsl:variable name="header">
      <xsl:apply-templates
	  select="*[local-name() != 'toc-line' and local-name() != 'running-line']|text()"/>
    </xsl:variable>
    <!-- Remove hypenation marks ('t','k', 'p' and 'w') -->
    <xsl:value-of select="translate(normalize-space(string($header)),'tkpw','')"/>
    <xsl:if test="$toc_level &gt;= $level">
      <xsl:text>&#10;H</xsl:text>
      <xsl:variable name="toc-line">
        <xsl:choose>
          <xsl:when test="brl:toc-line">
            <xsl:apply-templates select="brl:toc-line"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:apply-templates
              select="*[local-name() != 'toc-line' and local-name() != 'running-line']|text()"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <xsl:value-of select="normalize-space(string($toc-line))"/>
    </xsl:if>
    <xsl:if test="$footer_level &gt;= $level">
      <xsl:text>&#10;~</xsl:text>
      <xsl:variable name="running-line">
        <xsl:choose>
          <xsl:when test="brl:running-line[not(@brl:grade) or @brl:grade = $contraction]">
            <xsl:apply-templates
              select="brl:running-line[not(@brl:grade)]|brl:running-line[@brl:grade = $contraction]"
            />
          </xsl:when>
          <xsl:otherwise>
            <xsl:apply-templates
              select="*[local-name() != 'toc-line' and local-name() != 'running-line']|text()"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <!-- Replace spaces by 's' and remove hypenation marks ('t','k', 'p' and 'w') -->
      <xsl:value-of select="translate(normalize-space(string($running-line)),' tkpw','s')"/>
    </xsl:if>
    <xsl:text>&#10;</xsl:text>
  </xsl:template>

  <xsl:template match="dtb:blockquote">
    <xsl:text>&#10;y BLQUOb</xsl:text>
    <xsl:if test="@brl:class"><xsl:text>_</xsl:text><xsl:value-of select="@brl:class"/></xsl:if>
    <xsl:text>&#10;</xsl:text>
    <xsl:apply-templates/>
    <xsl:text>&#10;y BLQUOe</xsl:text>
    <xsl:if test="@brl:class"><xsl:text>_</xsl:text><xsl:value-of select="@brl:class"/></xsl:if>
    <xsl:text>&#10;</xsl:text>
  </xsl:template>

  <xsl:template match="dtb:epigraph">
    <xsl:text>&#10;y EPIGRb</xsl:text>
    <xsl:if test="@brl:class"><xsl:text>_</xsl:text><xsl:value-of select="@brl:class"/></xsl:if>
    <xsl:text>&#10;</xsl:text>
    <xsl:apply-templates/>
    <xsl:text>&#10;y EPIGRe</xsl:text>
    <xsl:if test="@brl:class"><xsl:text>_</xsl:text><xsl:value-of select="@brl:class"/></xsl:if>
    <xsl:text>&#10;</xsl:text>
  </xsl:template>

  <xsl:template match="dtb:poem">
    <xsl:text>&#10;y POEMb</xsl:text>
    <xsl:if test="@brl:class"><xsl:text>_</xsl:text><xsl:value-of select="@brl:class"/></xsl:if>
    <xsl:text>&#10;</xsl:text>
    <xsl:apply-templates/>
    <xsl:text>&#10;y POEMe</xsl:text>
    <xsl:if test="@brl:class"><xsl:text>_</xsl:text><xsl:value-of select="@brl:class"/></xsl:if>
    <xsl:text>&#10;</xsl:text>
  </xsl:template>

  <xsl:template name="insert_footnotes">
    <xsl:text>&#10;xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx Fussnoten xxxxxxxxxxxxxxxxxxxxxxxxxxxx&#10;&#10;</xsl:text>
    <xsl:text>"N %Y.nf&#10;</xsl:text>
    <xsl:text>O&#10;</xsl:text>
    <xsl:text>I L=n&#10;</xsl:text>
    <xsl:text>i f=1 l=3 w=5&#10;</xsl:text>
    <xsl:for-each select="//dtb:note">
      <xsl:apply-templates/>
    </xsl:for-each>
    <xsl:text>&#10;O&#10;</xsl:text>
    <xsl:text>"N %Y.f&#10;</xsl:text>
    <xsl:text>I *=j L=j&#10;</xsl:text>
    <xsl:text>i f=3 l=1&#10;</xsl:text>
    <xsl:text>"* %Y.nf&#10;</xsl:text>
  </xsl:template>

  <xsl:template match="dtb:note">
    <!-- Ignore notes. Place them at the beginning or with each chapter -->
  </xsl:template>

  <xsl:template match="dtb:noteref">
    <xsl:variable name="braille_tables">
      <xsl:call-template name="getTable"/>
    </xsl:variable>
    <xsl:variable name="note_number" select="count(preceding::dtb:noteref)+1"/>
    <xsl:value-of select="louis:translate(string($braille_tables), concat('*',string($note_number)))"/>
    <xsl:text>&#10;* &#10; </xsl:text>
  </xsl:template>

  <xsl:template match="dtb:author">
    <xsl:text>&#10;y AUTHOR</xsl:text>
    <xsl:if test="@brl:class"><xsl:text>_</xsl:text><xsl:value-of select="@brl:class"/></xsl:if>
    <xsl:text>&#10; </xsl:text>
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="dtb:byline">
    <xsl:text>&#10;y BYLINE</xsl:text>
    <xsl:if test="@brl:class"><xsl:text>_</xsl:text><xsl:value-of select="@brl:class"/></xsl:if>
    <xsl:text>&#10; </xsl:text>
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="dtb:linegroup">
    <xsl:text>&#10;y LINEGRb</xsl:text>
    <xsl:if test="@brl:class"><xsl:text>_</xsl:text><xsl:value-of select="@brl:class"/></xsl:if>
    <xsl:text>&#10; </xsl:text>
    <xsl:apply-templates/>
    <xsl:text>&#10;y LINEGRe</xsl:text>
    <xsl:if test="@brl:class"><xsl:text>_</xsl:text><xsl:value-of select="@brl:class"/></xsl:if>
    <xsl:text>&#10; </xsl:text>
  </xsl:template>

  <xsl:template match="dtb:line">
    <xsl:text>&#10;y LINEb</xsl:text>
    <xsl:if test="@brl:class"><xsl:text>_</xsl:text><xsl:value-of select="@brl:class"/></xsl:if>
    <xsl:text>&#10; </xsl:text>
    <xsl:apply-templates/>
    <xsl:text>&#10;y LINEe</xsl:text>
    <xsl:if test="@brl:class"><xsl:text>_</xsl:text><xsl:value-of select="@brl:class"/></xsl:if>
    <xsl:text>&#10; </xsl:text>
  </xsl:template>

  <xsl:template match="dtb:br">
    <!-- ignore for now -->
  </xsl:template>

  <xsl:template match="dtb:rearmatter">
    <xsl:text>&#10;y REARb&#10;</xsl:text>
    <xsl:apply-templates/>
    <xsl:text>&#10;y REARe&#10;</xsl:text>
  </xsl:template>

  <xsl:template match="dtb:strong[lang('de')]|dtb:em[lang('de')]|brl:emph[lang('de')]">
    <xsl:variable name="braille_tables">
      <xsl:call-template name="getTable"/>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="@brl:render = 'singlequote'">
        <!-- render the emphasis using singlequotes -->
        <xsl:value-of select="louis:translate(string($braille_tables), '&#8250;')"/>
        <xsl:apply-templates/>
        <xsl:value-of select="louis:translate(string($braille_tables), '&#8249;')"/>
      </xsl:when>
      <xsl:when test="@brl:render = 'quote'">
        <!-- render the emphasis using quotes -->
        <xsl:value-of select="louis:translate(string($braille_tables), '&#x00BB;')"/>
        <xsl:apply-templates/>
        <xsl:value-of select="louis:translate(string($braille_tables), '&#x00AB;')"/>
      </xsl:when>
      <xsl:when test="@brl:render = 'ignore'">
        <!-- ignore the emphasis for braille -->
        <xsl:apply-templates/>
      </xsl:when>
      <xsl:otherwise>
        <!-- render the emphasis using emphasis annotation -->
        <!-- Since we send every (text) node to liblouis separately, it
	   has no means to know when an empasis starts and when it ends.
	   For that reason we do the announcing here in xslt. This also
	   neatly works around a bug where liblouis doesn't correctly
	   announce multi-word emphasis -->
        <xsl:choose>
          <xsl:when test="count(tokenize(string(.), '(\s|/|-)+')) > 1">
            <!-- There are multiple words. Insert a multiple word announcement -->
            <xsl:value-of select="louis:translate(string($braille_tables), '&#x2560;')"/>
            <xsl:apply-templates/>
            <!-- Announce the end of emphasis -->
            <xsl:value-of select="louis:translate(string($braille_tables), '&#x2563;')"/>
          </xsl:when>
          <xsl:otherwise>
            <!-- Its a single word. Insert a single word announcement unless it is within a word -->
            <xsl:choose>
              <!-- emph is at the beginning of the word -->
              <xsl:when
                test="my:ends-with-non-word(preceding-sibling::text()[1]) and my:starts-with-word(following-sibling::text()[1])">
                <xsl:value-of select="louis:translate(string($braille_tables), '&#x255F;')"/>
                <xsl:apply-templates/>
                <xsl:value-of select="louis:translate(string($braille_tables), '&#x2561;')"/>
              </xsl:when>
              <!-- emph is at the end of the word -->
              <xsl:when
                test="my:ends-with-word(preceding-sibling::text()[1]) and my:starts-with-non-word(following-sibling::text()[1])">
                <xsl:value-of select="louis:translate(string($braille_tables), '&#x255E;')"/>
                <xsl:apply-templates/>
              </xsl:when>
              <!-- emph is inside the word -->
              <xsl:when
                test="my:ends-with-word(preceding-sibling::text()[1]) and my:starts-with-word(following-sibling::text()[1])">
                <xsl:value-of select="louis:translate(string($braille_tables), '&#x255E;')"/>
                <xsl:apply-templates/>
                <xsl:value-of select="louis:translate(string($braille_tables), '&#x2561;')"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="louis:translate(string($braille_tables), '&#x255F;')"/>
                <xsl:apply-templates/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="dtb:em">
    <xsl:apply-templates mode="italic"/>
  </xsl:template>

  <xsl:template match="dtb:strong">
    <xsl:apply-templates mode="bold"/>
  </xsl:template>

  <xsl:template name="handle_abbr">
    <xsl:param name="context" select="local-name()"/>
    <xsl:param name="content" select="."/>
    <xsl:variable name="braille_tables">
      <xsl:call-template name="getTable">
        <xsl:with-param name="context" select="$context"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="my:containsDot($content)">
        <xsl:variable name="temp">
          <!-- drop all whitespace -->
          <xsl:for-each select="tokenize(string($content), '\s+')">
            <xsl:value-of select="."/>
          </xsl:for-each>
        </xsl:variable>
        <xsl:value-of select="louis:translate(string($braille_tables), string($temp))"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="tokens" select="my:tokenizeByCase($content)"/>
        <xsl:variable name="temp">
          <xsl:for-each select="$tokens">
	    <xsl:variable name="i" select="position()"/>
            <!-- prepend more upper case sequences longer than one char with > -->
            <xsl:if
              test="((string-length(.) &gt; 1 or (position()=last())) and my:isUpper(substring(.,1,1))) or my:isNumber($tokens[$i+1])">
              <xsl:text>╦</xsl:text>
            </xsl:if>
            <!-- prepend single char upper case with $ (unless it is the last char then prepend with >) -->
            <xsl:if
              test="string-length(.) = 1 and my:isUpper(substring(.,1,1)) and not(position()=last()) and not(my:isNumber($tokens[$i+1]))">
              <xsl:text>╤</xsl:text>
            </xsl:if>
            <!-- prepend the first char with ' if it is lower case -->
            <xsl:if test="position()=1 and my:isLower(substring(.,1,1))">
              <xsl:text>╩</xsl:text>
            </xsl:if>
            <!-- prepend any lower case sequences that follow an upper case sequence with ' -->
            <xsl:if
              test="my:isLower(substring(.,1,1)) and string-length($tokens[$i - 1]) &gt; 1 and my:isUpper(substring($tokens[$i - 1],1,1))">
              <xsl:text>╩</xsl:text>
            </xsl:if>
            <xsl:value-of select="."/>
          </xsl:for-each>
        </xsl:variable>
        <xsl:value-of select="louis:translate(string($braille_tables), string($temp))"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="dtb:abbr[lang('de')]">
    <xsl:call-template name="handle_abbr"/>
  </xsl:template>

  <xsl:template match="dtb:abbr">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="dtb:div">
    <xsl:value-of select="concat('&#10;y DIVb_', @brl:class, '&#10;')"/>
    <xsl:apply-templates/>
    <xsl:value-of select="concat('&#10;y DIVe_', @brl:class, '&#10;')"/>
  </xsl:template>

  <xsl:template match="dtb:span[lang('de')]">
    <xsl:variable name="braille_tables">
      <xsl:call-template name="getTable"/>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="@brl:grade">
        <!-- announce explicit setting of the contraction -->
        <xsl:choose>
          <xsl:when test="$contraction = 2 and @brl:grade &lt; $contraction">
            <xsl:choose>
              <xsl:when test="count(tokenize(string(.), '(\s|/|-)+')) > 1">
                <!-- There are multiple words. Insert an announcement for a multiple word grade change -->
                <xsl:value-of select="louis:translate(string($braille_tables), '&#x255A;')"/>
                <xsl:apply-templates/>
                <!-- Announce the end of grade change -->
                <xsl:value-of select="louis:translate(string($braille_tables), '&#x255D;')"/>
              </xsl:when>
              <xsl:otherwise>
                <!-- Its a single word. Insert an announcement for a single word grade change -->
                <xsl:value-of select="louis:translate(string($braille_tables), '&#x2559;')"/>
                <xsl:apply-templates/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:otherwise>
            <xsl:apply-templates/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- Contraction hints -->

  <xsl:template match="brl:num[@role='ordinal' and lang('de')]">
    <xsl:variable name="braille_tables">
      <xsl:call-template name="getTable">
        <xsl:with-param name="context" select="'num_ordinal'"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="$downshift_ordinals = true()">
        <xsl:value-of select="louis:translate(string($braille_tables), string(translate(.,'.','')))"
        />
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="brl:num[@role='roman' and lang('de')]">
    <xsl:variable name="braille_tables">
      <xsl:call-template name="getTable">
        <xsl:with-param name="context" select="'abbr'"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="my:isUpper(substring(.,1,1))">
        <!-- we assume that if the first char is uppercase the rest is also uppercase -->
        <xsl:value-of select="louis:translate(string($braille_tables),concat('&#x2566;',string()))"
        />
      </xsl:when>
      <xsl:otherwise>
        <!-- presumably the roman number is in lower case -->
        <xsl:value-of select="louis:translate(string($braille_tables),concat('&#x2569;',string()))"
        />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="brl:num[@role='phone' and lang('de')]">
    <xsl:variable name="braille_tables">
      <xsl:call-template name="getTable"/>
    </xsl:variable>
    <!-- Replace ' ' and '/' with '.' -->
    <xsl:variable name="clean_number">
      <xsl:for-each select="tokenize(string(.), '(\s|/)+')">
        <xsl:value-of select="."/>
        <xsl:if test="not(position() = last())">.</xsl:if>
      </xsl:for-each>
    </xsl:variable>
    <xsl:value-of select="louis:translate(string($braille_tables),string($clean_number))"/>
  </xsl:template>

  <xsl:template match="brl:num[@role='fraction' and lang('de')]">
    <xsl:variable name="braille_tables">
      <xsl:call-template name="getTable"/>
    </xsl:variable>
    <xsl:variable name="downshift_braille_tables">
      <xsl:call-template name="getTable">
        <xsl:with-param name="context" select="'denominator'"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="numerator" select="(tokenize(string(.), '(\s|/)+'))[position()=1]"/>
    <xsl:variable name="denominator" select="(tokenize(string(.), '(\s|/)+'))[position()=2]"/>
    <xsl:value-of select="louis:translate(string($braille_tables), string($numerator))"/>
    <xsl:value-of select="louis:translate(string($downshift_braille_tables), string($denominator))"
    />
  </xsl:template>

  <xsl:template match="brl:num[@role='mixed' and lang('de')]">
    <xsl:variable name="braille_tables">
      <xsl:call-template name="getTable"/>
    </xsl:variable>
    <xsl:variable name="downshift_braille_tables">
      <xsl:call-template name="getTable">
        <xsl:with-param name="context" select="'denominator'"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="number" select="(tokenize(string(.), '(\s|/)+'))[position()=1]"/>
    <xsl:variable name="numerator" select="(tokenize(string(.), '(\s|/)+'))[position()=2]"/>
    <xsl:variable name="denominator" select="(tokenize(string(.), '(\s|/)+'))[position()=3]"/>
    <xsl:value-of select="louis:translate(string($braille_tables), string($number))"/>
    <xsl:value-of select="louis:translate(string($braille_tables), string($numerator))"/>
    <xsl:value-of select="louis:translate(string($downshift_braille_tables), string($denominator))"
    />
  </xsl:template>

  <xsl:template match="brl:num[@role='measure' and lang('de')]">
    <xsl:variable name="braille_tables">
      <xsl:call-template name="getTable"/>
    </xsl:variable>
    <!-- For all number-unit combinations, e.g. 1 kg, 10 km, etc. drop the space -->
    <xsl:variable name="measure"
      select="(tokenize(normalize-space(string(.)), ' '))[position()=last()]"/>
    <xsl:for-each select="tokenize(string(.), ' ')">
      <xsl:if test="not(position() = last())">
        <!-- FIXME: do not test for position but whether it is a number -->
        <xsl:value-of select="louis:translate(string($braille_tables), string(.))"/>
      </xsl:if>
    </xsl:for-each>
    <xsl:call-template name="handle_abbr">
      <xsl:with-param name="context" select="'abbr'"/>
      <xsl:with-param name="content" select="$measure"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="brl:num[@role='isbn' and lang('de')]">
    <xsl:variable name="braille_tables">
      <xsl:call-template name="getTable"/>
    </xsl:variable>
    <xsl:variable name="abbr_braille_tables">
      <xsl:call-template name="getTable">
        <xsl:with-param name="context" select="'abbr'"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="lastChar" select="substring(.,string-length(.),1)"/>
    <xsl:variable name="secondToLastChar" select="substring(.,string-length(.)-1,1)"/>
    <xsl:choose>
      <!-- If the isbn number ends in a capital letter then keep the
           dash, mark the letter with &#x2566; and translate the
           letter with abbr -->
      <xsl:when
        test="$secondToLastChar='-' and string(number($lastChar))='NaN' and my:isUpper($lastChar)">
        <xsl:variable name="clean_number">
          <xsl:for-each select="tokenize(substring(.,1,string-length(.)-2), '(\s|-)+')">
            <xsl:value-of select="string(.)"/>
            <xsl:if test="not(position() = last())">.</xsl:if>
          </xsl:for-each>
        </xsl:variable>
        <xsl:value-of select="louis:translate(string($braille_tables),string($clean_number))"/>
        <xsl:value-of select="louis:translate(string($braille_tables),$secondToLastChar)"/>
        <xsl:value-of
          select="louis:translate(string($abbr_braille_tables),concat('&#x2566;',$lastChar))"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="clean_number">
          <xsl:for-each select="tokenize(string(.), '(\s|-)+')">
            <xsl:value-of select="string(.)"/>
            <xsl:if test="not(position() = last())">.</xsl:if>
          </xsl:for-each>
        </xsl:variable>
        <xsl:value-of select="louis:translate(string($braille_tables),string($clean_number))"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="brl:name[lang('de')]">
    <xsl:variable name="braille_tables">
      <xsl:call-template name="getTable"/>
    </xsl:variable>
    <xsl:value-of select="louis:translate(string($braille_tables), string())"/>
  </xsl:template>

  <xsl:template match="brl:place[lang('de')]">
    <xsl:variable name="braille_tables">
      <xsl:call-template name="getTable"/>
    </xsl:variable>
    <xsl:value-of select="louis:translate(string($braille_tables),string())"/>
  </xsl:template>

  <xsl:template match="brl:v-form[lang('de')]">
    <xsl:variable name="braille_tables">
      <xsl:call-template name="getTable"/>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="$show_v_forms = true()">
        <xsl:value-of select="louis:translate(string($braille_tables), string())"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="brl:separator">
    <!-- ignore -->
  </xsl:template>

  <xsl:template match="brl:homograph">
    <!-- Join all text elements with a special marker (U+x00A6) and
	   send the whole string to liblouis -->
    <xsl:variable name="braille_tables">
      <xsl:call-template name="getTable"/>
    </xsl:variable>
    <xsl:variable name="text">
      <xsl:for-each select="text()">
        <!-- simply ignore the separator elements -->
        <xsl:value-of select="string(.)"/>
        <xsl:if test="not(position() = last())">¦</xsl:if>
      </xsl:for-each>
    </xsl:variable>
    <xsl:value-of select="louis:translate(string($braille_tables), string($text))"/>
  </xsl:template>

  <xsl:template match="brl:date[lang('de')]">
    <xsl:variable name="braille_tables">
      <xsl:call-template name="getTable"/>
    </xsl:variable>
    <xsl:variable name="day_braille_tables">
      <xsl:call-template name="getTable">
        <xsl:with-param name="context" select="'date_day'"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="month_braille_tables">
      <xsl:call-template name="getTable">
        <xsl:with-param name="context" select="'date_month'"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:for-each select="tokenize(string(@value), '-')">
      <!-- reverse the order, so we have day, month, year -->
      <xsl:sort select="position()" order="descending" data-type="number"/>
      <xsl:choose>
        <xsl:when test="position() = 1">
          <xsl:value-of
            select="louis:translate(string($day_braille_tables), format-number(. cast as xs:integer,'#'))"
          />
        </xsl:when>
        <xsl:when test="position() = 2">
          <xsl:value-of
            select="louis:translate(string($month_braille_tables), format-number(. cast as xs:integer,'#'))"
          />
        </xsl:when>
        <xsl:otherwise>
	  <xsl:if test="matches(string(.), '\d+')">
	    <xsl:value-of
		select="louis:translate(string($braille_tables), format-number(. cast as xs:integer,'#'))"/>
	  </xsl:if>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="brl:time[lang('de')]">
    <xsl:variable name="braille_tables">
      <xsl:call-template name="getTable"/>
    </xsl:variable>
    <xsl:variable name="time">
      <xsl:for-each select="tokenize(string(@value), ':')">
        <xsl:value-of select="format-number(. cast as xs:integer,'#')"/>
        <xsl:if test="not(position() = last())">.</xsl:if>
      </xsl:for-each>
    </xsl:variable>
    <xsl:value-of select="louis:translate(string($braille_tables), string($time))"/>
  </xsl:template>

  <xsl:template match="brl:volume[lang('de')]">
    <xsl:if test="@brl:grade = $contraction">
      <!-- Apply end notes -->
      <xsl:if test="$footnote_placement = 'end_vol'">
	<xsl:variable name="V" select="current()"/>
	<xsl:variable name="noterefs" select="$V/preceding::dtb:noteref[following::brl:volume[@brl:grade = $contraction][1] is $V]"/>
	<xsl:variable name="notes" select="for $noteref in $noterefs return //dtb:note[@id=translate($noteref/@idref,'#','')]"/>
	<xsl:if test="exists($notes)">
	  <xsl:text>&#10;y Notes&#10;</xsl:text>
	  <xsl:for-each select="$notes">
	    <xsl:apply-templates/>
	  </xsl:for-each>
	</xsl:if>
      </xsl:if>
      <xsl:text>&#10;y EndVol&#10;y BrlVol&#10;</xsl:text>
    </xsl:if>
  </xsl:template>

  <!-- Content selection -->
  <xsl:template match="brl:select[lang('de')]">
    <xsl:apply-templates select="brl:when-braille"/>
    <!-- Ignore the brl:otherwise element -->
  </xsl:template>

  <xsl:template match="brl:when-braille[lang('de')]">
    <xsl:apply-templates />
    <!-- Ignore the brl:otherwise element -->
  </xsl:template>

  <xsl:template match="brl:literal[lang('de')]">
    <xsl:if test="not(exists(@brl:grade)) or (exists(@brl:grade) and @brl:grade  = $contraction)">
      <xsl:value-of select="."/>
    </xsl:if>
  </xsl:template>

  <!-- Text nodes are translated with liblouis -->

  <!-- Handle comma after ordinals and after fraction-->
  <xsl:template
    match="text()[lang('de') and preceding::*[position()=1 and local-name()='num' and (@role='ordinal' or @role='fraction' or @ role='mixed')] and matches(string(), '^,')]" priority="100">
    <xsl:variable name="braille_tables">
      <xsl:call-template name="getTable"/>
    </xsl:variable>
    <xsl:value-of select="louis:translate(string($braille_tables), concat('&#x256C;',string()))"/>
  </xsl:template>

  <!-- Handle punctuation after a number and after ordinals -->
  <xsl:template
    match="text()[lang('de') and (my:ends-with-number(string(preceding::text()[1])) or preceding::*[position()=1 and local-name()='num' and @role='ordinal']) and my:starts-with-punctuation(string())]">
    <xsl:variable name="braille_tables">
      <xsl:call-template name="getTable"/>
    </xsl:variable>
    <xsl:value-of select="louis:translate(string($braille_tables), concat('&#x00B7;',string()))"/>
  </xsl:template>

  <!-- Handle text nodes ending with punctuation -->
  <xsl:template
    match="text()[lang('de') and my:ends-with-punctuation-word(string()) and my:starts-with-non-whitespace(string(following::text()[1]))]">
    <xsl:variable name="braille_tables">
      <xsl:call-template name="getTable"/>
    </xsl:variable>
    <xsl:value-of select="louis:translate(string($braille_tables), concat(string(),'¦¦'))"/>
  </xsl:template>

  <!-- Handle text nodes starting with punctuation -->
  <xsl:template
    match="text()[lang('de') and my:starts-with-punctuation-word(string()) and my:ends-with-non-whitespace(string(preceding::text()[1])) and not (my:ends-with-number(string(preceding::text()[1])) or preceding::*[position()=1 and local-name()='num' and @role='ordinal'])]">
    <xsl:variable name="braille_tables">
      <xsl:call-template name="getTable"/>
    </xsl:variable>
    <xsl:value-of select="louis:translate(string($braille_tables), concat('¦¦', string()))"/>
  </xsl:template>

  <!-- Handle text nodes starting and ending with punctuation -->
  <xsl:template
    match="text()[lang('de') and my:ends-with-punctuation-word(string()) and my:ends-with-punctuation-word(string()) and my:starts-with-non-whitespace(string(following::text()[1])) and my:ends-with-non-whitespace(string(preceding::text()[1])) and not (my:ends-with-number(string(preceding::text()[1])) or preceding::*[position()=1 and local-name()='num' and @role='ordinal'])]" priority="100">
    <xsl:variable name="braille_tables">
      <xsl:call-template name="getTable"/>
    </xsl:variable>
    <xsl:value-of select="louis:translate(string($braille_tables), concat('¦¦', string(),'¦¦'))"/>
  </xsl:template>

  <!-- Handle single word mixed emphasis -->
  <!-- mixed emphasis before-->
  <xsl:template
    match="text()[lang('de') and my:starts-with-word(string()) and my:ends-with-word(string(preceding::text()[1])) and preceding::*[position()=1 and local-name()='em']]">
    <xsl:variable name="braille_tables">
      <xsl:call-template name="getTable"/>
    </xsl:variable>
    <xsl:value-of select="louis:translate(string($braille_tables), concat('¦',string()))"/>
  </xsl:template>

  <!-- mixed emphasis after-->
  <xsl:template
    match="text()[lang('de') and my:ends-with-word(string()) and my:starts-with-word(string(following::text()[1])) and following::*[position()=1 and local-name()='em']]">
    <xsl:variable name="braille_tables">
      <xsl:call-template name="getTable"/>
    </xsl:variable>
    <xsl:value-of select="louis:translate(string($braille_tables), concat(string(),'¦'))"/>
  </xsl:template>

  <!-- handle 'ich' inside text node followed by chars that could be interpreted as numbers -->
  <xsl:template
    match="text()[lang('de') and (matches(string(), '^ich$', 'i') or matches(string(), '\Wich$', 'i')) and matches(string(following::text()[1]), '^[,;:?!)&#x00bb;&#x00ab;]')]">
    <xsl:variable name="braille_tables">
      <xsl:call-template name="getTable"/>
    </xsl:variable>
    <xsl:value-of select="louis:translate(string($braille_tables), concat(string(),'¦'))"/>
  </xsl:template>

  <xsl:template match="text()">
    <xsl:variable name="braille_tables">
      <xsl:call-template name="getTable"/>
    </xsl:variable>
    <xsl:value-of select="louis:translate(string($braille_tables), string())"/>
  </xsl:template>

  <xsl:template match="dtb:*">
    <xsl:message> *****<xsl:value-of select="name(..)"/>/{<xsl:value-of select="namespace-uri()"
        />}<xsl:value-of select="name()"/>****** </xsl:message>
  </xsl:template>

</xsl:stylesheet>
