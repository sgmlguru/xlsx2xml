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
    
    <!-- Extract first row n sheet to get terminology -->
    
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
    
    
    <!-- FIXME: Rewrite this into config file lookup -->
    <xsl:template name="target">
        <xsl:param name="source"/>
        <xsl:attribute name="target">
            <xsl:choose>
                <xsl:when test="$source='Course Code'">
                    <xsl:value-of select="'course-uniqueIdentifier'"/>
                </xsl:when>
                <xsl:when test="$source='StartDate'">
                    <xsl:value-of select="'duration-start'"/>
                </xsl:when>
                <xsl:when test="$source='EndDate'">
                    <xsl:value-of select="'duration-end'"/>
                </xsl:when>
                <xsl:when test="$source='Site_Desc'">
                    <xsl:value-of select="'location-description'"/>
                </xsl:when>
                <xsl:when test="$source='LocationDesc'">
                    <xsl:value-of select="'location-place'"/>
                </xsl:when>
                <xsl:when test="$source='Faculty'">
                    <xsl:value-of select="'provider-field'"/>
                </xsl:when>
                <xsl:when test="$source='Sector'">
                    <xsl:value-of select="'provider-field'"/>
                </xsl:when>
                <xsl:when test="$source='MIS Subject category'">
                    <xsl:value-of select="'categories-categoryMIS'"/>
                </xsl:when>
                <xsl:when test="$source='Findcourses category 1'">
                    <xsl:value-of select="'categories-category1'"/>
                </xsl:when>
                <xsl:when test="$source='Findcourses category 2'">
                    <xsl:value-of select="'categories-category2'"/>
                </xsl:when>
                <xsl:when test="$source='WebsiteCourseTitle'">
                    <xsl:value-of select="'course-name'"/>
                </xsl:when>
                <xsl:when test="$source='Length_Days'">
                    <xsl:value-of select="'duration-days'"/>
                </xsl:when>
                <xsl:when test="$source='Length_Weeks'">
                    <xsl:value-of select="'duration-weeks'"/>
                </xsl:when>
                <xsl:when test="$source='Length_Years'">
                    <xsl:value-of select="'duration-years'"/>
                </xsl:when>
                <xsl:when test="$source='Times'">
                    <xsl:value-of select="'course-field'"/>
                </xsl:when>
                <xsl:when test="$source='Mode'">
                    <xsl:value-of select="'event-pace'"/>
                </xsl:when>
                <xsl:when test="$source='16free8'">
                    <xsl:value-of select="'event-price'"/>
                </xsl:when>
                <xsl:when test="$source='Adult'">
                    <xsl:value-of select="'event-price'"/>
                </xsl:when>
                <xsl:when test="$source='Web address to the course'">
                    <xsl:value-of select="'course-link'"/>
                </xsl:when>
                <xsl:when test="$source='QualificationType'">
                    <xsl:value-of select="'qualification-type'"/>
                </xsl:when>
                <xsl:when test="$source='PageSummary'">
                    <xsl:value-of select="'course-field'"/>
                </xsl:when>
                <xsl:when test="$source='pagebody'">
                    <xsl:value-of select="'course-description'"/>
                </xsl:when>
                <xsl:when test="$source='WhatIllLearn'">
                    <xsl:value-of select="'course-field'"/>
                </xsl:when>
                <xsl:when test="$source='HowIllLearn'">
                    <xsl:value-of select="'course-field'"/>
                </xsl:when>
                <xsl:when test="$source='HowIllBeAssessed'">
                    <xsl:value-of select="'course-field'"/>
                </xsl:when>
                <xsl:when test="$source='EntryRequirements'">
                    <xsl:value-of select="'course-field'"/>
                </xsl:when>
                <xsl:when test="$source='HowToApply'">
                    <xsl:value-of select="'course-field'"/>
                </xsl:when>
            </xsl:choose>
        </xsl:attribute>
    </xsl:template>
    
</xsl:stylesheet>
