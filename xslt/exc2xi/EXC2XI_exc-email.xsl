<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    xmlns:fc="http://educations.com/XmlImport"
    xmlns:sg="http://www.sgmlguru/ns/xproc/steps"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <!-- This generates receiver email info -->
    
    <xsl:output method="xml" indent="yes"/>
    
    
    <xsl:template match="/">
        <xsl:apply-templates select="node()" mode="EXC2XI_EXC-EMAIL"/>
    </xsl:template>
    
    
    <xsl:template match="fc:course" mode="EXC2XI_EXC-EMAIL">
        <xsl:copy copy-namespaces="no">
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates select="node()[not(self::sg:email-receiver)]" mode="EXC2XI_EXC-EMAIL"/>
            
            <xsl:element name="informationRequestSettings" namespace="http://educations.com/XmlImport">
                <xsl:element name="emailReceivers" namespace="http://educations.com/XmlImport">
                    <xsl:apply-templates select="sg:email-receiver" mode="EXC2XI_EXC-EMAIL"/>
                </xsl:element>
            </xsl:element>
        </xsl:copy>
    </xsl:template>
    
    
    <xsl:template match="sg:email-receiver" mode="EXC2XI_EXC-EMAIL">
        <xsl:element name="receiver" namespace="http://educations.com/XmlImport">
            <xsl:attribute name="email" select="text()"/>
        </xsl:element>
    </xsl:template>
    
    
    <!-- ID transform -->
    <xsl:template match="node()" mode="EXC2XI_EXC-EMAIL">
        <xsl:copy copy-namespaces="no">
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates select="node()" mode="EXC2XI_EXC-EMAIL"/>
        </xsl:copy>
    </xsl:template>
    
</xsl:stylesheet>
