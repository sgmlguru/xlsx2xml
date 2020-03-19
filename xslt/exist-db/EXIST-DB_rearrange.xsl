<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships"
    xmlns:rs="http://schemas.openxmlformats.org/package/2006/relationships"
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
    
    <!-- This rearranges eXist XLSX unzip output to match the expected pipeline input structure.
         The eXist output wraps everything in a <wrap> element but the XProc extracted output does not. -->
    
    <xsl:output method="xml" indent="yes"/>
    
    
    <xsl:template match="/">
        <xsl:apply-templates select="node()" mode="EXIST-DB_REARRANGE"/>
    </xsl:template>
    
    
    <xsl:template match="wrap" mode="EXIST-DB_REARRANGE">
        <xsl:variable name="move-these" select="(sml:sst,rs:Relationships)"/>
        <xsl:variable name="sheet" select="sml:worksheet"/>
        <xsl:apply-templates select="sml:workbook" mode="EXIST-DB_REARRANGE">
            <xsl:with-param name="move-these" select="$move-these"/>
            <xsl:with-param name="sheet" select="$sheet" tunnel="yes"/>
        </xsl:apply-templates>
    </xsl:template>
    
    
    <xsl:template match="sml:workbook" mode="EXIST-DB_REARRANGE">
        <xsl:param name="move-these"/>
        <xsl:copy>
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates select="node()" mode="EXIST-DB_REARRANGE"/>
            <xsl:copy-of select="$move-these"/>
        </xsl:copy>
    </xsl:template>
    
    
    <xsl:template match="sml:sheets" mode="EXIST-DB_REARRANGE">
        <xsl:param name="sheet" tunnel="yes"/>
        <xsl:copy>
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates select="node()" mode="EXIST-DB_REARRANGE"/>
            <xsl:copy-of select="$sheet"/>
        </xsl:copy>
    </xsl:template>
    
    
    <!-- ID transform -->
    <xsl:template match="node()" mode="EXIST-DB_REARRANGE">
        <xsl:copy>
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates select="node()" mode="EXIST-DB_REARRANGE"/>
        </xsl:copy>
    </xsl:template>
    
</xsl:stylesheet>
