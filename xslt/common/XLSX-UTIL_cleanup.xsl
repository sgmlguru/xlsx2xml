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
    
    <!-- This is a cleanup step for XLSX -->
    
    <xsl:output method="xml" indent="yes"/>
    
    
    <xsl:template match="/">
        <xsl:apply-templates select="node()" mode="XLSX-UTIL_CLEANUP"/>
    </xsl:template>
    
    
    <!-- Remove workbook elements - these are not needed -->
    <xsl:template match="sml:fileVersion | sml:workbookPr | sml:bookViews | sml:extLst" mode="XLSX-UTIL_CLEANUP"/>
    
    
    <!-- Remove worksheet elements -->
    <xsl:template match="sml:sheetViews | sml:sheetFormatPr | sml:cols | sml:pageMargins | sml:pageSetup | sml:calcPr" mode="XLSX-UTIL_CLEANUP"/>
    
    
    <!-- Remove shared strings (they were normalised in the previous step) -->
    <xsl:template match="sml:sst" mode="XLSX-UTIL_CLEANUP"/>
    
    
    <!-- Remove -->
    <xsl:template match="mc:AlternateContent" mode="XLSX-UTIL_CLEANUP"/>
    
    
    <!-- Remove but add the ID as a PI -->
    <xsl:template match="xr:revisionPtr" mode="XLSX-UTIL_CLEANUP">
        <xsl:processing-instruction name="{name(@documentId)}" select="@documentId"/>
    </xsl:template>
    
    
    <!-- Keep all attributes as PIs -->
    <xsl:template match="sml:sheet | sml:dimension | sml:tableParts | sml:tablePart" mode="XLSX-UTIL_CLEANUP">
        <xsl:variable name="name" select="local-name(.)"/>
        <xsl:for-each select="@*">
            <xsl:processing-instruction name="{concat($name,'-',local-name(.))}" select="."/>
        </xsl:for-each>
        <xsl:apply-templates select="*" mode="XLSX-UTIL_CLEANUP"/>
    </xsl:template>
    
    
    <!-- ID transform -->
    <xsl:template match="node()" mode="XLSX-UTIL_CLEANUP">
        <xsl:copy copy-namespaces="no">
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates select="node()" mode="XLSX-UTIL_CLEANUP"/>
        </xsl:copy>
    </xsl:template>
    
</xsl:stylesheet>
