<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    xmlns:fc="http://educations.com/XmlImport"
    xmlns:sg="http://www.sgmlguru/ns/xproc/steps"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <!-- This dedupes courses -->
    
    <xsl:output method="xml" indent="yes"/>
    
    
    <xsl:template match="/">
        <xsl:apply-templates select="node()" mode="EXC2XI_XI-DEDUPE"/>
    </xsl:template>
    
    
    <xsl:template match="fc:courses" mode="EXC2XI_XI-DEDUPE">
        <xsl:copy copy-namespaces="no">
            <xsl:copy-of select="@*"/>
            
            <xsl:for-each-group select="fc:course" group-by="@uniqueIdentifier">
                <xsl:variable name="id" select="@uniqueIdentifier"/>
                <xsl:copy copy-namespaces="no">
                    <xsl:copy-of select="@*"/>
                    <xsl:apply-templates select="current-group()[1]/fc:contentFields" mode="EXC2XI_XI-DEDUPE"/>
                    <xsl:apply-templates select="current-group()[1]/fc:events" mode="EXC2XI_XI-DEDUPE-local">
                        <xsl:with-param name="id" select="$id"/>
                    </xsl:apply-templates>
                    <xsl:apply-templates select="current-group()[1]/fc:categories" mode="EXC2XI_XI-DEDUPE"/>
                    <xsl:apply-templates select="current-group()[1]/fc:duration" mode="EXC2XI_XI-DEDUPE"/>
                    <xsl:apply-templates select="current-group()[1]/fc:link" mode="EXC2XI_XI-DEDUPE"/>
                </xsl:copy>
            </xsl:for-each-group>
        </xsl:copy>
    </xsl:template>
    
    
    <xsl:template match="fc:events" mode="EXC2XI_XI-DEDUPE-local">
        <xsl:param name="id"/>
        <xsl:variable name="current" select="." as="item()"/>
        
        <xsl:comment>
            <xsl:value-of select="'Duplicate course ID, differing events'"/>
        </xsl:comment>
        <xsl:copy copy-namespaces="no">
            <xsl:copy-of select="@*"/>
            <!--<xsl:copy-of select="node()" copy-namespaces="no"/>-->
            <xsl:apply-templates select="fc:event | following::fc:course[@uniqueIdentifier = $id]//fc:event" mode="EXC2XI_XI-DEDUPE">
                <xsl:with-param name="id" select="$id"/>
            </xsl:apply-templates>
        </xsl:copy>
    </xsl:template>
    
    
    <xsl:template match="fc:event" mode="EXC2XI_XI-DEDUPE">
        <xsl:param name="id"/>
        
        <!-- Count preceding-sibling events, and preceding events in a course with a matching course ID -->
        <xsl:variable name="count-events" select="count(preceding::fc:course[@uniqueIdentifier = $id]//fc:event) + count(preceding-sibling::fc:event) + 1"/>
        
        <xsl:copy copy-namespaces="no">
            <xsl:copy-of select="@* except @uniqueIdentifier"/>
            
            <xsl:attribute name="unique-identifier" select="concat(@uniqueIdentifier,'-',$count-events)"/>
            
            <xsl:apply-templates select="node()" mode="EXC2XI_XI-DEDUPE"/>
        </xsl:copy>
    </xsl:template>
    
    
    <!-- ID transform -->
    <xsl:template match="node()" mode="EXC2XI_XI-DEDUPE">
        <xsl:copy copy-namespaces="no">
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates select="node()" mode="EXC2XI_XI-DEDUPE"/>
        </xsl:copy>
    </xsl:template>
    
</xsl:stylesheet>
