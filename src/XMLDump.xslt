<?xml version="1.0" encoding="utf-8" ?>
<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
	<!ENTITY sitemapAttributes "@id | @nodeName | @urlName">
	<!ENTITY standardAttributes "@id | @nodeName | @level | @urlName | @nodeTypeAlias | @alias">
	<!ENTITY packageVersion "0.7">

	<!ENTITY % compatibility SYSTEM "compatibility.ent">
	%compatibility;
	
]>
<xsl:stylesheet
	version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:umb="urn:umbraco.library"
	exclude-result-prefixes="umb"
>
	
	<xsl:output
		method="xml"
		indent="yes"
		omit-xml-declaration="yes"
		cdata-section-elements="data"
	/>
	
<!--
	Umbraco supplies this parameter.
	The select attribute is used when no value is supplied from "outside" (i.e. local development)
-->
	<xsl:param name="currentPage" select="/root/&node;[1]/&node;[1]" />
	
	<!-- Test if we can detect QueryString parameters -->
	<xsl:variable name="queryStringAvailable" select="function-available('umb:RequestQueryString')" />

	<!-- Grab the root node -->
	<xsl:variable name="root" select="$currentPage/ancestor::root" />
	
<!-- :: Configuration variables :: -->
<!--
	You can tailor the XML output to your needs by specifying some
	URL parameters - e.g. to check a specific node (by id), or you need to
	see all nodes of a specific Document Type.
	
	The following variables handle these.
-->

	<xsl:variable name="nodeId">
		<xsl:if test="$queryStringAvailable">
			<xsl:value-of select="umb:RequestQueryString('node')" />
		</xsl:if>
	</xsl:variable>

	<xsl:variable name="type">
		<xsl:if test="$queryStringAvailable">
			<xsl:value-of select="umb:RequestQueryString('type')" />
		</xsl:if>
	</xsl:variable>
	
	<xsl:variable name="mediaId">
		<xsl:if test="$queryStringAvailable">
			<xsl:value-of select="umb:RequestQueryString('media')" />
		</xsl:if>
	</xsl:variable>
	
	<xsl:variable name="property">
		<xsl:if test="$queryStringAvailable">
			<xsl:value-of select="umb:RequestQueryString('property')" />
		</xsl:if>
	</xsl:variable>
	
	<xsl:variable name="xpath">
		<xsl:if test="$queryStringAvailable">
			<xsl:value-of select="umb:RequestQueryString('xpath')" />
		</xsl:if>
	</xsl:variable>

	<xsl:variable name="hidden">
		<xsl:if test="$queryStringAvailable">
			<xsl:value-of select="umb:RequestQueryString('hidden')" />
		</xsl:if>
	</xsl:variable>
	<xsl:variable name="hiddenOnly" select="boolean($hidden = 'yes' or $hidden = 'true' or $hidden = '1')" />
	
	<xsl:variable name="sitemap">
		<xsl:if test="$queryStringAvailable">
			<xsl:value-of select="umb:RequestQueryString('sitemap')" />
		</xsl:if>
	</xsl:variable>
	<xsl:variable name="navOnly" select="boolean($sitemap = 'yes' or $sitemap = 'true' or $sitemap = '1')" />
	
	<!-- Secret option - not ready for prime time yet :-) -->
	<xsl:variable name="memberId">
		<xsl:if test="$queryStringAvailable">
			<xsl:value-of select="umb:RequestQueryString('member')" />
		</xsl:if>
	</xsl:variable>

	<xsl:variable name="verbose">
		<xsl:if test="$queryStringAvailable">
			<xsl:value-of select="umb:RequestQueryString('verbose')" />
		</xsl:if>
	</xsl:variable>
	<xsl:variable name="verbosity" select="boolean($verbose = 'yes' or $verbose = 'true' or $verbose = '1')" />

	<xsl:variable name="processChildNodes" select="not($hiddenOnly or number($nodeId) or normalize-space($type) or normalize-space($property) or normalize-space($xpath))" />

<!-- :: Templates :: -->
	
	<xsl:template match="/">
		<!-- Start by writing a 'usage' comment to the output  -->
<xsl:comment xml:space="preserve">
	XML Dump for Umbraco (v&packageVersion;)
	======================================================================================
	Options (QueryString parameters):
	- node		Grab a node by its id, e.g.: node=1080
	- type		Grab node(s) by their DocumentType (nodeTypeAlias), e.g.: type=GalleryItem
	- property	Find nodes that have a <![CDATA[<data>]]> node with the specific alias, e.g.: property=metaDescription
	- media		View XML for media item, e.g.: media=1337
	- sitemap	Set to 'yes' to show navigation structure only (shows only "&sitemapAttributes;" and hides nodes with '&umbracoNaviHide;' checked)
	- hidden	Set to 'yes' to show all nodes with '&umbracoNaviHide;' checked.
	
	- verbose	Show all attributes of <![CDATA[<node>]]> elements (by default only shows "&standardAttributes;").
	======================================================================================
	Experimental Option (XPath knowledge required - typos may wreak havoc!):
	Note that you can't use variables (for now).
	- xpath		Grab node(s) using an XPath, e.g.: xpath=/root//node[@nodeName = 'Home']

	(For all boolean options, the values 'yes', 'true' and '1' all work as expected)
</xsl:comment>
		<!-- Now decide what to output, determined by the supplied options (if any) -->
		<xsl:choose>
			<xsl:when test="number($nodeId)">
				<xsl:apply-templates select="$root//&node;[@id = $nodeId]" />
			</xsl:when>
			
			<xsl:when test="normalize-space($xpath)">
				<!-- <xsl:variable name="queryXPath">
					<xsl:choose>
						<xsl:when test="starts-with($xpath, './')">
							<xsl:value-of select="concat('/root//node[@id = ', $currentPage/@id, ']', substring($xpath, 2))" />
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$xpath" />
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<nodes select="{$queryXPath}">
					<xsl:apply-templates select="umb:GetXmlNodeByXPath($queryXPath)" />
				</nodes> -->
				<nodes select="{$xpath}">
					<xsl:apply-templates select="umb:GetXmlNodeByXPath($xpath)" />
				</nodes>
			</xsl:when>
			
			<xsl:when test="normalize-space($property)">
				<nodes property="{$property}">
					<xsl:apply-templates select="$root//&node;[data[@alias = $property]]" />
				</nodes>
			</xsl:when>
			
			<xsl:when test="normalize-space($type)">
				<nodes nodeTypeAlias="{$type}">
					<xsl:apply-templates select="$root//&node;[&docType; = $type]" />
				</nodes>
			</xsl:when>

			<xsl:when test="number($mediaId)">
				<xsl:variable name="mediaNode" select="umb:GetMedia($mediaId, false())" />
					<media>
						<xsl:if test="not($mediaNode[error])">
							<xsl:apply-templates select="$mediaNode" />
						</xsl:if>
					</media>					
			</xsl:when>

			<xsl:when test="$navOnly">
				<root id="-1">
					<xsl:apply-templates select="$root/&node;[1]" mode="sitemap" />
				</root>					
			</xsl:when>

			<xsl:when test="number($memberId)">
				<members>
					<xsl:copy-of select="umb:GetCurrentMember()" />
				</members>
			</xsl:when>
			
			<xsl:when test="$hiddenOnly">
				<nodes>
					<xsl:attribute name="&umbracoNaviHide;">1</xsl:attribute>
					<xsl:apply-templates select="$root//&node;[&hidden;]" />					
				</nodes>
			</xsl:when>
			
			<xsl:otherwise>
				<!-- Okay, no specific nodes selected - show complete tree -->
				<xsl:apply-templates select="$root" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- Template for copying nodes -->
	<xsl:template match="*">
		<!-- Copy the current node ('node' or 'data') -->
		<xsl:copy>
			<xsl:choose>
				<xsl:when test="$verbosity">
					<!-- Copy all attributes verbatim -->
					<xsl:copy-of select="@*" />
				</xsl:when>
				<xsl:otherwise>
					<!-- Copy only predefined defaults -->
					<xsl:copy-of select="&standardAttributes;" />
				</xsl:otherwise>
			</xsl:choose>
			
			<!-- Process the data elements or their text nodes -->
			<xsl:apply-templates select="&data; | text()" />
			
			<!-- Only continue copying nested 'node' elements if applicable -->
			<xsl:choose>
				<xsl:when test="$processChildNodes">
					<xsl:apply-templates select="&node;" />
				</xsl:when>
				<xsl:otherwise>
					<xsl:if test="&node;">
						<xsl:variable name="nodecount" select="count(&node;)" />
	<xsl:comment xml:space="preserve"> (<xsl:value-of select="$nodecount" /> element<xsl:if test="$nodecount &gt; 1">s</xsl:if> below this)</xsl:comment>
					</xsl:if>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="&node;" mode="sitemap">
		<node>
			<xsl:copy-of select="&sitemapAttributes;" />
			<xsl:apply-templates select="&node;" mode="sitemap" />
		</node>
	</xsl:template>
	
	<xsl:template match="&node;[&hidden;]" mode="sitemap" />

</xsl:stylesheet>