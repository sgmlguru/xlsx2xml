<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    xmlns:fc="http://educations.com/XmlImport"
    xmlns:sg="http://www.sgmlguru/ns/xproc/steps"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <!-- This generates event info -->
    
    <xsl:output method="xml" indent="yes"/>
    
    
    <xsl:variable name="locations" select="//fc:locations"/>
    
    
    <xsl:template match="/">
        <xsl:apply-templates select="node()" mode="EXC2XI_EXC-EVENTS"/>
    </xsl:template>
    
    
    <xsl:template match="fc:course" mode="EXC2XI_EXC-EVENTS">
        <xsl:variable name="id" select="@uniqueIdentifier"/>
        <xsl:variable name="place" select="sg:location-place"/>
        <xsl:variable name="description" select="sg:location-description"/>
        <xsl:variable name="start-date" select="substring-before(sg:duration-start/text(),'T')"/>
        <xsl:variable name="end-date" select="substring-before(sg:duration-end/text(),'T')"/>
        
        <xsl:copy copy-namespaces="no">
            <xsl:copy-of select="@*"/>
            
            <xsl:copy-of select="fc:contentFields" copy-namespaces="no"/>
            
            <xsl:element name="events" namespace="http://educations.com/XmlImport">
                <xsl:variable name="location-id" select="$locations//fc:location[fc:place=$place and fc:description=$description]/@uniqueIdentifier"/>
                
                <xsl:for-each select="(sg:event-price)[matches(text(),'^free$','i') or number(text())]">
                    <xsl:variable name="current" select="."/>
                    <xsl:element name="event" namespace="http://educations.com/XmlImport">
                        <xsl:attribute
                            name="uniqueIdentifier"
                            select="concat($id,'-',count((preceding-sibling::sg:event-price)[matches(text(),'^free$','i') or number(text())]) + 1)"/>
                        
                        <!-- FIXME: Need logic to determine xsi:type properly -->
                        <xsl:if test="$location-id != ''">
                            <xsl:attribute name="locationUID" select="$location-id"/>
                            <xsl:attribute name="xsi:type" select="'LocationEvent'"/>
                        </xsl:if>
                        
                        <!-- FIXME: Need logic to determine delivery method (open class, online, etc) -->
                        <xsl:attribute name="deliveryMethod" select="'Open class'"/>
                        
                        <xsl:processing-instruction name="source">
                            <xsl:value-of select="@source"/>
                        </xsl:processing-instruction>
                        
                        <!-- FIXME: Currently no way to determine currency or VAT details -->
                        <xsl:element name="price" namespace="http://educations.com/XmlImport">
                            <xsl:attribute name="price" select="if ($current='free') then (0) else (number($current))"/>
                        </xsl:element>
                        
                        <!-- FIXME: Needs proper logic -->
                        <xsl:element name="start" namespace="http://educations.com/XmlImport">
                            <xsl:if test="$start-date != ''">
                                <xsl:attribute name="xsi:type" select="'Fixed'"/>
                                <xsl:attribute name="startDate" select="$start-date"/>
                                <xsl:if test="$end-date !='' and $start-date != $end-date">
                                    <xsl:attribute name="endDate" select="$end-date"/>
                                </xsl:if>
                            </xsl:if>
                        </xsl:element>
                    </xsl:element>
                </xsl:for-each>
            </xsl:element>
            
            <xsl:apply-templates select="node()[not(self::fc:contentFields)]" mode="EXC2XI_EXC-EVENTS"/>
        </xsl:copy>
    </xsl:template>
    
    
    <!-- Remove these as they've now been referenced in event elements -->
    <xsl:template match="sg:location-description | sg:location-place" mode="EXC2XI_EXC-EVENTS"/>
    
    
    <!-- Remove these but leave behind PIs -->
    <xsl:template match="sg:event-price|sg:duration-start|sg:duration-end" mode="EXC2XI_EXC-EVENTS">
        <xsl:processing-instruction name="{name(.)}">
            <xsl:for-each select="@*">
                <xsl:value-of select="name(.)"/>
                <xsl:text>=</xsl:text>
                <xsl:value-of select="."/>
                <xsl:if test="position()!=last()">
                    <xsl:text> </xsl:text>
                </xsl:if>
            </xsl:for-each>
            <xsl:if test=".!=''">
                <xsl:text> content=</xsl:text>
                <xsl:value-of select="text()"/>
            </xsl:if>
        </xsl:processing-instruction>
    </xsl:template>
    
    
    <!-- ID transform -->
    <xsl:template match="node()" mode="EXC2XI_EXC-EVENTS">
        <xsl:copy copy-namespaces="no">
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates select="node()" mode="EXC2XI_EXC-EVENTS"/>
        </xsl:copy>
    </xsl:template>
    
</xsl:stylesheet>
