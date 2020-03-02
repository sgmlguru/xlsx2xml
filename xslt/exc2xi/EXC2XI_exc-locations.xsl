<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    xmlns:fc="http://educations.com/XmlImport"
    xmlns:sg="http://www.sgmlguru/ns/xproc/steps"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <!-- This converts location elements in locations from exc to target XML -->
    
    <xsl:output method="xml" indent="yes"/>
    
    
    <xsl:template match="/">
        <xsl:apply-templates select="node()" mode="EXC2XI_EXC-LOCATIONS"/>
    </xsl:template>
    
    
    <xsl:template match="fc:location[parent::fc:locations]" mode="EXC2XI_EXC-LOCATIONS">
        <xsl:variable name="place" select="sg:location-place" as="xs:string"/>
        <xsl:variable name="count">
            <xsl:value-of select="count(preceding-sibling::fc:location[sg:location-place/text() = $place]) + 1"/>
        </xsl:variable>
        <xsl:element name="location" namespace="http://educations.com/XmlImport">
            <xsl:attribute name="name" select="sg:location-description"/>
            <xsl:attribute name="uniqueIdentifier">
                <xsl:value-of select="concat(translate($place,' &amp;',''),'-',$count)"/>
            </xsl:attribute>
            
            <xsl:element name="place" namespace="http://educations.com/XmlImport">
                <xsl:value-of select="$place"/>
            </xsl:element>
            <xsl:element name="description" namespace="http://educations.com/XmlImport">
                <xsl:value-of select="sg:location-description"/>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    
    
    <!-- ID transform -->
    <xsl:template match="node()" mode="EXC2XI_EXC-LOCATIONS">
        <xsl:copy copy-namespaces="no">
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates select="node()" mode="EXC2XI_EXC-LOCATIONS"/>
        </xsl:copy>
    </xsl:template>
    
</xsl:stylesheet>
