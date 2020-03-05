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
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <!-- This removes empty sheet rows -->
    
    <xsl:output method="xml" indent="yes"/>
    
    
    <xsl:template match="/">
        <xsl:apply-templates select="node()" mode="XLSX-UTIL_REMOVE-EMPTY"/>
    </xsl:template>
    
    
    <!-- Remove empty rows -->
    <xsl:template match="sml:row[not(node())]" mode="XLSX-UTIL_REMOVE-EMPTY"/>
    
    
    <!-- ID transform -->
    <xsl:template match="node()" mode="XLSX-UTIL_REMOVE-EMPTY">
        <xsl:copy copy-namespaces="no">
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates select="node()" mode="XLSX-UTIL_REMOVE-EMPTY"/>
        </xsl:copy>
    </xsl:template>
    
</xsl:stylesheet>
