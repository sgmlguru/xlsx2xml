<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    xmlns:fc="http://educations.com/XmlImport"
    xmlns:sg="http://www.sgmlguru/ns/xproc/steps"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <!-- This converts course content from exc to target XML -->
    
    <xsl:output method="xml" indent="yes"/>
    
    
    <xsl:template match="/">
        <xsl:apply-templates select="node()" mode="EXC2XI_COURSE"/>
    </xsl:template>
    
    
    <xsl:template match="fc:course" mode="EXC2XI_COURSE">
        <xsl:variable name="name" select="normalize-space(sg:course-name)"/>
        <xsl:variable name="id" select="if (sg:course-uniqueIdentifier) then (sg:course-uniqueIdentifier) else ($name)"/>
        
        <xsl:copy copy-namespaces="no">
            <xsl:attribute name="uniqueIdentifier" select="$id"/>
            <xsl:attribute name="name" select="$name"/>
            <xsl:attribute name="courseType" select="normalize-space(sg:qualification-type)"/>
            
            <xsl:apply-templates select="node()" mode="EXC2XI_COURSE"/>
        </xsl:copy>
    </xsl:template>
    
    
    <xsl:template match="sg:course-uniqueIdentifier | sg:course-name | sg:qualification-type" mode="EXC2XI_COURSE"/>
    
    
    <!-- ID transform -->
    <xsl:template match="node()" mode="EXC2XI_COURSE">
        <xsl:copy copy-namespaces="no">
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates select="node()" mode="EXC2XI_COURSE"/>
        </xsl:copy>
    </xsl:template>
    
</xsl:stylesheet>
