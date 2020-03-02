<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    xmlns:fc="http://educations.com/XmlImport"
    xmlns:sg="http://www.sgmlguru/ns/xproc/steps"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <!-- This generates duration info -->
    
    <xsl:output method="xml" indent="yes"/>
    
    
    <xsl:template match="/">
        <xsl:apply-templates select="node()" mode="EXC2XI_EXC-DURATION"/>
    </xsl:template>
    
    
    <xsl:template match="fc:course" mode="EXC2XI_EXC-DURATION">
        <xsl:copy copy-namespaces="no">
            <xsl:copy-of select="@*" copy-namespaces="no"/>
            <xsl:apply-templates select="node()" mode="EXC2XI_EXC-DURATION"/>
        </xsl:copy>
    </xsl:template>
    
    
    <xsl:template match="(sg:duration-years | sg:duration-weeks | sg:duration-days)[. != '' and . != 0]" mode="EXC2XI_EXC-DURATION">
        <xsl:variable name="name" select="local-name(.)"/>
        <xsl:variable name="unit" select="substring-after($name,'-')"/>
        <xsl:variable name="value" select="xs:decimal(number(text()))" as="xs:decimal"/>
        <xsl:element name="duration" namespace="http://educations.com/XmlImport">
            
            <xsl:if test="parent::*/sg:event-pace != ''">
                <xsl:attribute name="text" select="parent::*/sg:event-pace/text()"/>
            </xsl:if>
            
            <xsl:element name="specific" namespace="http://educations.com/XmlImport">
                <xsl:attribute name="unit" select="$unit"/>
                <xsl:attribute name="value" select="$value"/>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    
    
    <!-- Remove if value is 0 -->
    <xsl:template match="(sg:duration-years | sg:duration-weeks | sg:duration-days)[.=0]" mode="EXC2XI_EXC-DURATION"/>
    
    
    <!-- ID transform -->
    <xsl:template match="node()" mode="EXC2XI_EXC-DURATION">
        <xsl:copy copy-namespaces="no">
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates select="node()" mode="EXC2XI_EXC-DURATION"/>
        </xsl:copy>
    </xsl:template>
    
</xsl:stylesheet>
