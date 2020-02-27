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
    
    <!-- This does the top structures for the output -->
    
    <!-- Generate mapping of cordinates -->
    <xsl:import href="XLSX2XML_map.xsl"/>
    
    <xsl:output method="xml" indent="yes"/>
    
    
    <xsl:template match="/">
        <xsl:apply-templates select="node()" mode="XLSX2XML_STRUCTURE"/>
    </xsl:template>
    
    
    <xsl:template match="sml:workbook" mode="XLSX2XML_STRUCTURE">
        <xsl:element name="import" namespace="http://educations.com/XmlImport">
            <xsl:apply-templates select="node()" mode="XLSX2XML_STRUCTURE"/>
        </xsl:element>
    </xsl:template>
    
    
    <xsl:template match="sml:sheets" mode="XLSX2XML_STRUCTURE">
        <xsl:apply-templates select="node()" mode="XLSX2XML_STRUCTURE"/>
    </xsl:template>
    
    
    <xsl:template match="sml:worksheet" mode="XLSX2XML_STRUCTURE">
        <xsl:element name="provider" namespace="http://educations.com/XmlImport">
            <xsl:apply-templates select="node()" mode="XLSX2XML_STRUCTURE"/>
        </xsl:element>
    </xsl:template>
    
    
    <xsl:template match="sml:sheetData" mode="XLSX2XML_STRUCTURE">
        <xsl:element name="courses" namespace="http://educations.com/XmlImport">
            
            <!-- Create a lookup -->
            <xsl:apply-templates select="sml:row[1]" mode="XLSX2XML_MAP"/>
            
            <!-- Rows 2 and on - copy for now -->
            <xsl:apply-templates select="node()" mode="XLSX2XML_STRUCTURE"/>
        </xsl:element>
    </xsl:template>
    
    
    <!-- Delete first row since that's now a lookup -->
    <xsl:template match="sml:row[1]" mode="XLSX2XML_STRUCTURE"/>
    
    
    <!-- ID transform -->
    <xsl:template match="node()" mode="XLSX2XML_STRUCTURE">
        <xsl:copy copy-namespaces="no">
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates select="node()" mode="XLSX2XML_STRUCTURE"/>
        </xsl:copy>
    </xsl:template>
    
</xsl:stylesheet>
