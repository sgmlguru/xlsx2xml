<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships"
    xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006"
    xmlns:x15="http://schemas.microsoft.com/office/spreadsheetml/2010/11/main"
    xmlns:xr="http://schemas.microsoft.com/office/spreadsheetml/2014/revision"
    xmlns:xr6="http://schemas.microsoft.com/office/spreadsheetml/2016/revision6"
    xmlns:xr10="http://schemas.microsoft.com/office/spreadsheetml/2016/revision10"
    xmlns:xr2="http://schemas.microsoft.com/office/spreadsheetml/2015/revision2"
    xmlns:sml="http://schemas.openxmlformats.org/spreadsheetml/2006/main"
    xmlns:fc="http://educations.com/XmlImport"
    xmlns:sg="http://www.sgmlguru/ns/xproc/steps"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <!-- This converts spreadsheet dates in ECMA-376 format to human-readable dates -->
    
    <xsl:output method="xml" indent="yes"/>
    
    
    <xsl:template match="/">
        <xsl:apply-templates select="node()" mode="XLSX2XML_DATES"/>
    </xsl:template>
    
    
    <xsl:template match="fc:course" mode="XLSX2XML_DATES">
        <xsl:variable name="date-fields">
            <fields>
                <xsl:apply-templates select="preceding-sibling::providermap/item[matches(@target,'^(duration-start)$')] | preceding-sibling::providermap/item[matches(@target,'^(duration-end)$')]" mode="XLSX2XML_DATES"/>
            </fields>
        </xsl:variable>
        <xsl:copy copy-namespaces="no">
            <xsl:copy-of select="providermap"/>
            <xsl:apply-templates select="sml:c" mode="XLSX2XML_DATES">
                <xsl:with-param name="date-fields" select="$date-fields"/>
            </xsl:apply-templates>
        </xsl:copy>
    </xsl:template>
    
    
    <xsl:template match="sml:c" mode="XLSX2XML_DATES">
        <xsl:param name="date-fields"/>
        <xsl:variable name="match-strings" select="$date-fields//item/@coord" as="item()*"/>
        <xsl:variable name="value" select="sml:v/text()"/>
        <xsl:variable name="r" select="@r" as="xs:string"/>
        <xsl:variable name="c" select="." as="item()"/>
            
        <!-- Get position of a matched lookup item - this corresponds to a start or end date -->
        <xsl:variable name="match-position">
            <xsl:for-each select="$date-fields//item">
                <xsl:variable name="coord" select="@coord"/>
                <xsl:variable name="target" select="@target"/>
                <xsl:choose>
                    <xsl:when test="matches($r,concat($coord,'[0-9]+$'))">
                        <xsl:value-of select="position()"/>
                    </xsl:when>
                </xsl:choose>
            </xsl:for-each>
        </xsl:variable>
        
        <!-- Convert to @target-named element if there is a match, otherwise keep the <c> -->
        <xsl:choose>
            <xsl:when test="$match-position != ''">
                <xsl:element name="{$date-fields//item[position() = number($match-position)]/@target}" namespace="http://www.sgmlguru/ns/xproc/steps">
                    <xsl:copy-of select="@*"/>
                    <xsl:value-of select="sg:todate($value)"/>
                </xsl:element>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy copy-namespaces="no">
                    <xsl:copy-of select="@*"/>
                    <xsl:value-of select="$value"/>
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
            
    </xsl:template>
    
    
    <!-- ID transform -->
    <xsl:template match="node()" mode="XLSX2XML_DATES">
        <xsl:copy copy-namespaces="no">
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates select="node()" mode="XLSX2XML_DATES"/>
        </xsl:copy>
    </xsl:template>
    
    
    <!-- Convert ECMA-376 value to date (Excel dates start from 1900-01-01) -->
    <xsl:function name="sg:todate" as="xs:dateTime">
        <xsl:param name="days" as="xs:double"/>
        <xsl:sequence select="xs:dateTime('1900-01-01T00:00:00') + xs:dayTimeDuration(concat('P',xs:integer($days),'D'))"/>
    </xsl:function>
    
</xsl:stylesheet>
