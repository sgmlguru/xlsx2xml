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
    
    
    <xsl:output method="xml" indent="yes"/>
    
    
    <xsl:template match="/">
        <xsl:apply-templates select="node()" mode="XLSX2XML_FIELDS"/>
    </xsl:template>
    
    
    <xsl:template match="fc:course" mode="XLSX2XML_FIELDS">
        <xsl:variable name="fields">
            <fields>
                <xsl:apply-templates select="preceding-sibling::providermap/item[matches(@target,'^(course-field|course-description|provider-field|course-uniqueIdentifier|categories-categoryMIS|categories-category1|categories-category2|course-name|duration-days|duration-weeks|duration-years|event-pace|event-price|course-link|qualification-type)$')]" mode="XLSX2XML_FIELDS"/>
            </fields>
        </xsl:variable>
        <xsl:copy copy-namespaces="no">
            <xsl:copy-of select="providermap"/>
            <xsl:apply-templates select="*" mode="XLSX2XML_FIELDS">
                <xsl:with-param name="fields" select="$fields"/>
            </xsl:apply-templates>
        </xsl:copy>
    </xsl:template>
    
    
    <xsl:template match="sml:c" mode="XLSX2XML_FIELDS">
        <xsl:param name="fields"/>
        
        <xsl:variable name="value" select="text()"/>
        <xsl:variable name="r" select="@r" as="xs:string"/>
        <xsl:variable name="c" select="." as="item()"/>
        
        <!-- Get position of a matched lookup item - this corresponds to a start or end date -->
        <xsl:variable name="match-position">
            <xsl:for-each select="$fields//item">
                <xsl:variable name="coord" select="@coord"/>
                <xsl:variable name="target" select="@target"/>
                <xsl:choose>
                    <xsl:when test="matches($r,concat('^',$coord,'[0-9]+$'))">
                        <xsl:value-of select="position()"/>
                    </xsl:when>
                </xsl:choose>
            </xsl:for-each>
        </xsl:variable>
        
        <!-- Convert to @target-named element if there is a match, otherwise keep the <c> -->
        <xsl:choose>
            <xsl:when test="$match-position != ''">
                <xsl:variable
                    name="name"
                    select="if ($fields//item[position() = number($match-position)]/@target != '')
                            then ($fields//item[position() = number($match-position)]/@target)
                            else ('unknown')"/>
                
                <xsl:element name="{$name}" namespace="http://www.sgmlguru/ns/xproc/steps">
                    <xsl:copy-of select="@*"/>
                    <xsl:attribute name="source" select="$fields//item[position() = number($match-position)]/@source"/>
                    <xsl:value-of select="$value"/>
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
    <xsl:template match="node()" mode="XLSX2XML_FIELDS">
        <xsl:copy copy-namespaces="no">
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates select="node()" mode="XLSX2XML_FIELDS"/>
        </xsl:copy>
    </xsl:template>
    
</xsl:stylesheet>
