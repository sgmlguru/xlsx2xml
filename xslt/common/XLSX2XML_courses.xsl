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
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <!-- This cobverts spreadsheet rows 2 and onwards to course elements -->
    
    <xsl:output method="xml" indent="yes"/>
    
    
    <xsl:template match="/">
        <xsl:apply-templates select="node()" mode="XLSX2XML_COURSES"/>
    </xsl:template>
    
    
    <xsl:template match="sml:row" mode="XLSX2XML_COURSES">
        <xsl:element name="course" namespace="http://educations.com/XmlImport">
            <xsl:apply-templates select="node()" mode="XLSX2XML_COURSES"/>
        </xsl:element>
    </xsl:template>
    
    
    <!-- ID transform -->
    <xsl:template match="node()" mode="XLSX2XML_COURSES">
        <xsl:copy copy-namespaces="no">
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates select="node()" mode="XLSX2XML_COURSES"/>
        </xsl:copy>
    </xsl:template>
    
</xsl:stylesheet>
