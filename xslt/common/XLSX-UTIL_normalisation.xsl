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
    
    <!-- This is a step for XLSX shared strings normalisation -->
    
    <xsl:output method="xml" indent="yes"/>
    
    
    <xsl:variable name="sst" select="/sml:workbook/sml:sst"/>
    
    
    <xsl:template match="/">
        <xsl:apply-templates select="node()" mode="XLSX-UTIL_NORMALISATION"/>
    </xsl:template>
    
    
    <xsl:template match="sml:workbook" mode="XLSX-UTIL_NORMALISATION">
        <xsl:copy copy-namespaces="no">
            <xsl:copy-of select="@*"/>
            <xsl:attribute name="provider" select="substring-before(tokenize(base-uri(/*),'/')[last()],'.xml')"/>
            <xsl:apply-templates select="node()" mode="XLSX-UTIL_NORMALISATION"/>
        </xsl:copy>
    </xsl:template>
    
    
    <!-- Look up shared strings -->
    <xsl:template match="sml:c[@t='s']" mode="XLSX-UTIL_NORMALISATION">
        <xsl:variable name="string-no" select="number(sml:v/text()) + 1"/>
        <xsl:copy copy-namespaces="no">
            <xsl:copy-of select="@*"/>
            <xsl:element name="v" namespace="http://schemas.openxmlformats.org/spreadsheetml/2006/main">
                <xsl:copy-of select="$sst//sml:si[position() = $string-no]/sml:t/text()" copy-namespaces="no"/>
            </xsl:element>
        </xsl:copy>
    </xsl:template>
    
    
    <!-- Inline string -->
    <xsl:template match="sml:c[@t='inlineStr']" mode="XLSX-UTIL_NORMALISATION">
        <xsl:copy copy-namespaces="no">
            <xsl:copy-of select="@*"/>
            <xsl:element name="v" namespace="http://schemas.openxmlformats.org/spreadsheetml/2006/main">
                <xsl:value-of select=".//sml:t/text()"/>
            </xsl:element>
        </xsl:copy>
    </xsl:template>
    
    
    <!-- ID transform -->
    <xsl:template match="node()" mode="XLSX-UTIL_NORMALISATION">
        <xsl:copy copy-namespaces="no">
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates select="node()" mode="XLSX-UTIL_NORMALISATION"/>
        </xsl:copy>
    </xsl:template>
    
</xsl:stylesheet>
