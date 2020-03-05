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
    xmlns:rp="http://schemas.openxmlformats.org/package/2006/relationships"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <!-- This is a step for XLSX hyperlink normalisation -->
    
    <xsl:output method="xml" indent="yes"/>
    
    
    <xsl:variable name="relationships" select="/sml:workbook/rp:Relationships"/>
    
    
    <xsl:template match="/">
        <xsl:apply-templates select="node()" mode="XLSX-UTIL_HYPERLINKS"/>
    </xsl:template>
    
    
    <xsl:template match="sml:worksheet" mode="XLSX-UTIL_HYPERLINKS">
        <xsl:variable name="hyperlinks" select="sml:hyperlinks"/>
        <xsl:choose>
            <xsl:when test="sml:hyperlinks">
                <xsl:copy copy-namespaces="no">
                    <xsl:copy-of select="@*"/>
                    <xsl:apply-templates select="node()" mode="XLSX-UTIL_HYPERLINKS">
                        <xsl:with-param name="hyperlinks" select="$hyperlinks" tunnel="yes"/>
                    </xsl:apply-templates>
                    
                </xsl:copy>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy-of select="."/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    
    <xsl:template match="sml:c[@t='inlineStr']" mode="XLSX-UTIL_HYPERLINKS">
        <xsl:param name="hyperlinks" tunnel="yes"/>
        <xsl:variable name="r" select="@r"/>
        <xsl:variable name="rid" select="$hyperlinks//sml:hyperlink[@ref=$r]/@r:id"/>
        <xsl:variable name="link" select="$relationships//rp:Relationship[@Id=$rid]/@Target"/>
        
        <xsl:choose>
            <xsl:when test="$link != ''">
                <xsl:copy copy-namespaces="no">
                    <xsl:copy-of select="@*"/>
                    <xsl:element name="v" namespace="http://schemas.openxmlformats.org/spreadsheetml/2006/main">
                        <xsl:value-of select="$link"/>
                    </xsl:element>
                </xsl:copy>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy-of select="."/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    
    <!-- ID transform -->
    <xsl:template match="node()" mode="XLSX-UTIL_HYPERLINKS">
        <xsl:copy copy-namespaces="no">
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates select="node()" mode="XLSX-UTIL_HYPERLINKS"/>
        </xsl:copy>
    </xsl:template>
    
</xsl:stylesheet>
