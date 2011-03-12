<?xml version="1.0" encoding="utf-8" ?>
<!DOCTYPE xsl:stylesheet [
	<!ENTITY % version SYSTEM "../src/version.ent">
	%version;
]>
<xsl:stylesheet
	version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:x="http://www.w3.org/1999/XSL/TransformAlias"
>

	<xsl:output method="xml"
		indent="yes"
		omit-xml-declaration="no"
		cdata-section-elements="Design readme"
	/>

	<!-- Identity transform -->
	<xsl:template match="/">
		<xsl:apply-templates select="* | text() | comment() | processing-instruction()" />
	</xsl:template>
		
	<xsl:template match="* | text()">
		<xsl:copy>
			<xsl:copy-of select="@*" />
			<xsl:apply-templates select="* | text() | comment() | processing-instruction()" />
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="comment() | processing-instruction()">
		<xsl:copy-of select="." />
	</xsl:template>
	
	<xsl:template match="processing-instruction('umbraco-package')">
		<xsl:processing-instruction name="umbraco-package">
			<xsl:text>"&XMLDumpVersionHeader;"</xsl:text>
		</xsl:processing-instruction>
		<xsl:text>&#x0A;</xsl:text>
	</xsl:template>
	
</xsl:stylesheet>