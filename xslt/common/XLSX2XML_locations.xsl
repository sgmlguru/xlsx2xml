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
    
    <!-- This extracts location data to a locations wrapper and converts the location info to temp elements in both locations and courses -->
    
    <xsl:output method="xml" indent="yes"/>
    
    
    <xsl:template match="/">
        <xsl:apply-templates select="node()" mode="XLSX2XML_LOCATIONS"/>
    </xsl:template>
    
    
    <xsl:template match="fc:courses" mode="XLSX2XML_LOCATIONS">
        
        <xsl:variable name="location-fields">
            <fields>
                <xsl:apply-templates
                    select="sg:provider/sg:item[matches(@target,'^(location-place)$')] | sg:provider/sg:item[matches(@target,'^(location-description)$')]"
                    mode="XLSX2XML_LOCATIONS"/>
            </fields>
        </xsl:variable>
        
        <!-- Read the locations from every course to a variable -->
        <xsl:variable name="locations">
            <xsl:element name="locations" namespace="http://educations.com/XmlImport">
                <xsl:apply-templates select="fc:course" mode="XLSX2XML_LOCATIONS-local">
                    <xsl:with-param name="location-fields" select="$location-fields"/>
                    <!-- Are we adding location info to the locations wrapper? -->
                    <xsl:with-param name="location-wrapper" select="'true'" tunnel="yes"/>
                </xsl:apply-templates>
            </xsl:element>
        </xsl:variable>
        
        <!-- Get unique locations, with distinct place/description combinations -->
        <xsl:variable name="unique-locations">
            <xsl:element name="locations" namespace="http://educations.com/XmlImport">
                <xsl:for-each-group select="$locations//fc:location" group-by="sg:location-place">
                    
                    <xsl:variable name="place">
                        <xsl:element name="location-place" namespace="http://www.sgmlguru/ns/xproc/steps">
                            <xsl:value-of select="current-grouping-key()"/>
                        </xsl:element>
                    </xsl:variable>
                    <xsl:for-each-group select="current-group()" group-by="sg:location-description">
                        <xsl:element name="location" namespace="http://educations.com/XmlImport">
                            <xsl:copy-of select="$place"/>
                            <xsl:element name="location-description" namespace="http://www.sgmlguru/ns/xproc/steps">
                                <xsl:value-of select="current-grouping-key()"/>
                            </xsl:element>
                        </xsl:element>
                    </xsl:for-each-group>
                </xsl:for-each-group>
            </xsl:element>
        </xsl:variable>
        
        <!-- Courses with the location info converted to temp elements in sg namespace -->
        <xsl:copy copy-namespaces="no">
            <xsl:copy-of select="sg:provider"/>
            
            <xsl:apply-templates select="fc:course" mode="XLSX2XML_LOCATIONS">
                <xsl:with-param name="location-fields" select="$location-fields"/>
                <!-- Are we adding location info to the locations wrapper? -->
                <xsl:with-param name="location-wrapper" select="'false'" tunnel="yes"/>
            </xsl:apply-templates>
            
        </xsl:copy>
        
        <!-- Unique locations with temp elements for place and description in sg namespace -->
        <xsl:element name="locations" namespace="http://educations.com/XmlImport">
            <xsl:apply-templates select="$unique-locations//fc:location" mode="XLSX2XML_LOCATIONS">
                <xsl:sort select="sg:location-place"/>
                <xsl:sort select="sg:location-description"/>
            </xsl:apply-templates>
        </xsl:element>
    </xsl:template>
    
    
    <!-- Extract location info from courses to the locations wrapper -->
    <xsl:template match="fc:course" mode="XLSX2XML_LOCATIONS-local">
        <xsl:param name="location-fields"/>
        <xsl:param name="location-wrapper" tunnel="yes"/>
        
        <xsl:element name="location" namespace="http://educations.com/XmlImport">
            <xsl:apply-templates select="sml:c" mode="XLSX2XML_LOCATIONS">
                <xsl:with-param name="location-fields" select="$location-fields"/>
            </xsl:apply-templates>
        </xsl:element>
    </xsl:template>
    
    
    <!-- Courses with converted temp location elements -->
    <xsl:template match="fc:course" mode="XLSX2XML_LOCATIONS">
        <xsl:param name="location-fields"/>
        <xsl:param name="location-wrapper" tunnel="yes"/>
        
        <xsl:copy copy-namespaces="no">
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates select="*" mode="XLSX2XML_LOCATIONS">
                <xsl:with-param name="location-fields" select="$location-fields"/>
            </xsl:apply-templates>
        </xsl:copy>
    </xsl:template>
    
    
    <!-- XLSX cell processing both for courses and for locations -->
    <xsl:template match="sml:c" mode="XLSX2XML_LOCATIONS">
        <xsl:param name="location-fields"/>
        <xsl:param name="location-wrapper" tunnel="yes"/>
        
        <!-- The cell value -->
        <xsl:variable name="value" select="text()"/>
        
        <!-- The cell coordinate -->
        <xsl:variable name="r" select="@r" as="xs:string"/>
        
        <!-- Get position of a matched lookup item in the variable so we can use the item for conversion -->
        <xsl:variable name="match-position">
            <xsl:for-each select="$location-fields//sg:item">
                <xsl:variable name="coord" select="@coord"/>
                <xsl:variable name="target" select="@target"/>
                <xsl:choose>
                    <xsl:when test="matches($r,concat($coord,'[0-9]+$'))">
                        <xsl:value-of select="position()"/>
                    </xsl:when>
                </xsl:choose>
            </xsl:for-each>
        </xsl:variable>
        
        <!-- Conditionally use the item position when processing the cell -->
        <xsl:choose>
            <!-- Matched lookup item for BOTH locations and courses -->
            <xsl:when test="$match-position != ''">
                <xsl:element name="{$location-fields//sg:item[position() = number($match-position)]/@target}" namespace="http://www.sgmlguru/ns/xproc/steps">
                    <xsl:value-of select="$value"/>
                </xsl:element>
            </xsl:when>
            
            <!-- We need to remove anything that isn't matched when extracting location info to the locations wrapper -->
            <xsl:when test="$location-wrapper='true'"/>
            
            <!-- All other cases are for courses and copied over -->
            <xsl:otherwise>
                <xsl:copy copy-namespaces="no">
                    <xsl:copy-of select="@*"/>
                    <xsl:value-of select="$value"/>
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
            
    </xsl:template>
    
    
    <!-- ID transform -->
    <xsl:template match="node()" mode="XLSX2XML_LOCATIONS">
        <xsl:copy copy-namespaces="yes">
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates select="node()" mode="XLSX2XML_LOCATIONS"/>
        </xsl:copy>
    </xsl:template>
    
</xsl:stylesheet>
