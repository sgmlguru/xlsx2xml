<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    xmlns:fc="http://educations.com/XmlImport"
    xmlns:sg="http://www.sgmlguru/ns/xproc/steps"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <!-- This does some cleanup -->
    
    <xsl:output method="xml" indent="yes"/>
    
    
    <xsl:template match="/">
        <xsl:apply-templates select="node()" mode="EXC2XI_XI-CLEANUP"/>
    </xsl:template>
    
    
    <!-- Remove the lookup -->
    <xsl:template match="providermap" mode="EXC2XI_XI-CLEANUP"/>
    
    
    <!-- ID transform -->
    <xsl:template match="node()" mode="EXC2XI_XI-CLEANUP">
        <xsl:copy copy-namespaces="no">
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates select="node()" mode="EXC2XI_XI-CLEANUP"/>
        </xsl:copy>
    </xsl:template>
    
</xsl:stylesheet>
