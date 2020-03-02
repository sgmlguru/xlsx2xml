<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    xmlns:fc="http://educations.com/XmlImport"
    xmlns:sg="http://www.sgmlguru/ns/xproc/steps"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <!-- This converts categories from exc to target XML -->
    
    <xsl:output method="xml" indent="yes"/>
    
    
    <xsl:template match="/">
        <xsl:apply-templates select="node()" mode="EXC2XI_CATEGORIES"/>
    </xsl:template>
    
    
    <xsl:template match="fc:course" mode="EXC2XI_CATEGORIES">
        <xsl:copy copy-namespaces="no">
            <xsl:copy-of select="@*"/>
            <xsl:copy-of select="fc:contentFields" copy-namespaces="no"/>
            
            <xsl:element name="categories" namespace="http://educations.com/XmlImport">
                <xsl:apply-templates select="sg:categories-categoryMIS|sg:categories-category1|sg:categories-category2" mode="EXC2XI_CATEGORIES"/>
            </xsl:element>
            
            <xsl:copy-of select="node()[not(self::fc:contentFields) and not(self::sg:categories-categoryMIS) and not(self::sg:categories-category1) and not(self::sg:categories-category2)]" copy-namespaces="no"/>
        </xsl:copy>
    </xsl:template>
    
    
    <xsl:template match="sg:categories-categoryMIS|sg:categories-category1|sg:categories-category2" mode="EXC2XI_CATEGORIES">
        <xsl:processing-instruction name="category-type" select="substring-after(name(.),'categor')"/>
        <xsl:element name="category" namespace="http://educations.com/XmlImport">
            <xsl:attribute name="name" select="normalize-space(text())"/>
        </xsl:element>
    </xsl:template>
    
    
    <!-- ID transform -->
    <xsl:template match="node()" mode="EXC2XI_CATEGORIES">
        <xsl:copy copy-namespaces="no">
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates select="node()" mode="EXC2XI_CATEGORIES"/>
        </xsl:copy>
    </xsl:template>
    
</xsl:stylesheet>
