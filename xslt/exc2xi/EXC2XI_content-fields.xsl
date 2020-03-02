<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    xmlns:fc="http://educations.com/XmlImport"
    xmlns:sg="http://www.sgmlguru/ns/xproc/steps"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <!-- This converts course content fields from exc to target XML -->
    
    <xsl:output method="xml" indent="yes"/>
    
    
    <xsl:template match="/">
        <xsl:apply-templates select="node()" mode="EXC2XI_CONTENT-FIELDS"/>
    </xsl:template>
    
    
    <xsl:template match="fc:course" mode="EXC2XI_CONTENT-FIELDS">
        <xsl:copy copy-namespaces="no">
            <xsl:copy-of select="@*"/>
            
            <xsl:element name="contentFields" namespace="http://educations.com/XmlImport">
                <xsl:apply-templates select="sg:course-field | sg:course-description | sg:provider-field" mode="EXC2XI_CONTENT-FIELDS"/>
            </xsl:element>
            
            <xsl:apply-templates select="node()[not(self::sg:course-field) and not(self::sg:provider-field) and not(self::sg:course-description)]" mode="EXC2XI_CONTENT-FIELDS"/>
        </xsl:copy>
    </xsl:template>
    
    
    <xsl:template match="sg:course-field | sg:provider-field | sg:course-description" mode="EXC2XI_CONTENT-FIELDS">
        <xsl:element name="field" namespace="http://educations.com/XmlImport">
            <xsl:attribute name="xsi:type" select="if (@source = 'pagebody') then ('default') else ('custom')"/>
            <xsl:attribute name="name" select="if (@source = 'pagebody') then ('description') else (@source)"/>
            
            <xsl:if test="normalize-space(text()) != ''">
                <xsl:text disable-output-escaping="yes">&lt;![CDATA[</xsl:text>
                <xsl:value-of select="text()" disable-output-escaping="yes"/>
                <xsl:text disable-output-escaping="yes">]]&gt;</xsl:text>
            </xsl:if>
            
        </xsl:element>
    </xsl:template>
    
    
    <!-- ID transform -->
    <xsl:template match="node()" mode="EXC2XI_CONTENT-FIELDS">
        <xsl:copy copy-namespaces="no">
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates select="node()" mode="EXC2XI_CONTENT-FIELDS"/>
        </xsl:copy>
    </xsl:template>
    
</xsl:stylesheet>
