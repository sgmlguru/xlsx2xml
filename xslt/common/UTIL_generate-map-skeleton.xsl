<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    xmlns:sg="http://www.sgmlguru/ns/xproc/steps"
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
    
    <!-- Extract first non-empty row in sheet (assumed to be column headings) to get terminology and populate the lookup -->
    
    <xsl:import href="XLSX-UTIL_normalisation.xsl"/>
    
    <xsl:output method="xml" indent="yes"/>
    
    
    <xsl:variable name="normalised-docx">
        <xsl:apply-templates select="/*" mode="XLSX-UTIL_NORMALISATION"/>
    </xsl:variable>
    
    
    <xsl:variable name="id" select="substring-before(tokenize(base-uri(/),'/')[last()],'.xml')"/>
    
    
    <xsl:template match="/">
        
        <!--<xsl:copy-of select="$normalised-docx"></xsl:copy-of>-->
        
        <xsl:apply-templates select="$normalised-docx//sml:row[sml:c][1]" mode="UTIL_GENERATE-MAP-SKELETON"/>
    </xsl:template>
    
    
    <!-- Get first row -->
    <xsl:template match="sml:row" mode="UTIL_GENERATE-MAP-SKELETON">
        <xsl:element name="provider" namespace="http://www.sgmlguru/ns/xproc/steps">
            <xsl:attribute name="id" select="$id"/>
            <xsl:apply-templates select="*" mode="UTIL_GENERATE-MAP-SKELETON"/>
        </xsl:element>
    </xsl:template>
    
    
    <xsl:template match="sml:c" mode="UTIL_GENERATE-MAP-SKELETON">
        <xsl:variable name="source" select="sml:v/text()"/>
        
        <xsl:element name="item" namespace="http://www.sgmlguru/ns/xproc/steps">
            <xsl:attribute name="coord" select="replace(@r,'^([A-Z]+)[0-9]+$','$1')"/>
            <xsl:attribute name="source" select="$source"/>
            <xsl:attribute name="target"/>
            <xsl:value-of select="$source"/>
        </xsl:element>
    </xsl:template>
    
    
</xsl:stylesheet>
