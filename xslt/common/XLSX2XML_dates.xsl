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
    
    <!-- This con   verts spreadsheet dates in ECMA-376 format to human-readable dates -->
    
    <xsl:output method="xml" indent="yes"/>
    
    
    <xsl:template match="/">
        <xsl:apply-templates select="node()" mode="XLSX2XML_DATES"/>
    </xsl:template>
    
    
    <xsl:template match="fc:course" mode="XLSX2XML_DATES">
        <xsl:variable name="date-fields">
            <fields>
                <xsl:copy-of select="providermap/item[matches(@target,'^(duration-start|duration-end)$')]"/>
            </fields>
        </xsl:variable>
        <xsl:copy copy-namespaces="no">
            <xsl:apply-templates select="node()" mode="XLSX2XML_DATES"/>
        </xsl:copy>
    </xsl:template>
    
    
    <!-- ID transform -->
    <xsl:template match="node()" mode="XLSX2XML_DATES">
        <xsl:copy copy-namespaces="no">
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates select="node()" mode="XLSX2XML_DATES"/>
        </xsl:copy>
    </xsl:template>
    
    
    <xsl:function name="sg:todate" as="xs:dateTime">
        <xsl:param name="days" as="xs:double"/>
        <xsl:sequence select="xs:dateTime('1900-01-01T00:00:00') + xs:dayTimeDuration(concat('P',xs:integer($days),'D'))"/>
    </xsl:function>
    
</xsl:stylesheet>
