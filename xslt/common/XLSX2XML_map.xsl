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
    
    <!-- Extract first row n sheet to get terminology -->
    
    <xsl:output method="xml" indent="yes"/>
    
    
    <!-- Get first row -->
    <xsl:template match="sml:row" mode="XLSX2XML_MAP">
        <providermap id="tokenize(base-uri(.),'/')[last()]">
            <xsl:apply-templates select="*" mode="XLSX2XML_MAP"/>
        </providermap>
    </xsl:template>
    
    
    <xsl:template match="sml:c" mode="XLSX2XML_MAP">
        <xsl:variable name="source" select="sml:v/text()"/>
        <item coord="{replace(@r,'^([A-Z]+)[0-9]+$','$1')}" source="{$source}">
            <xsl:call-template name="target">
                <xsl:with-param name="source" select="$source"/>
            </xsl:call-template>
            <xsl:value-of select="sml:v"/>
        </item>
    </xsl:template>
    
    
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
                    <xsl:value-of select="'location/place'"/>
                </xsl:when>
                <xsl:when test="$source='Faculty'">
                    <xsl:value-of select="'provider-field'"/>
                </xsl:when>
                <xsl:when test="$source='Sector'">
                    <xsl:value-of select="'provider-field'"/>
                </xsl:when>
                <xsl:when test="$source='MIS Subject category'">
                    <xsl:value-of select="'categories/category'"/>
                </xsl:when>
                <xsl:when test="$source='Findcourses category 1'">
                    <xsl:value-of select="'categories/category'"/>
                </xsl:when>
                <xsl:when test="$source='Findcourses category 2'">
                    <xsl:value-of select="'categories/category'"/>
                </xsl:when>
                <xsl:when test="$source='WebsiteCourseTitle'">
                    <xsl:value-of select="'course/@name'"/>
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
                    <xsl:value-of select="'course/link'"/>
                </xsl:when>
                <xsl:when test="$source='QualificationType'">
                    <xsl:value-of select="'course-field'"/>
                </xsl:when>
                <xsl:when test="$source='PageSummary'">
                    <xsl:value-of select="'course-field'"/>
                </xsl:when>
                <xsl:when test="$source='pagebody'">
                    <xsl:value-of select="'course-field'"/>
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
