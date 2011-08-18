<?xml version="1.0" encoding="utf-8" ?>
<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
	<!ENTITY hiddenBOOL "$hidden = 'yes' or $hidden = 'true' or $hidden = '1'">
	<!ENTITY sitemapBOOL "$sitemap = 'yes' or $sitemap = 'true' or $sitemap = '1'">
	<!ENTITY verboseBOOL "$verbose = 'yes' or $verbose = 'true' or $verbose = '1'">
	<!ENTITY xmldumpAllowed "xmldumpAllowed">
	
	<!ENTITY sitemapAttributes "@id | @nodeName | @urlName">
	<!ENTITY imageCropperAttributes "@url | @name">
	<!ENTITY relatedLinkAttributes "@title | @link">
	<!ENTITY documentAttributes "@isDoc | @level | @nodeTypeAlias">
	<!ENTITY propertyAttributes "@alias">
	
	<!ENTITY standardAttributes "&sitemapAttributes; | &documentAttributes; | &propertyAttributes; | &imageCropperAttributes; | &relatedLinkAttributes;">

	<!ENTITY % compatibility SYSTEM "compatibility.ent">
	%compatibility;

	<!ENTITY % version SYSTEM "version.ent">
	%version;
]>
<?umbraco-package This is a dummy for the packageVersion entity - see ../lib/freezeEntities.xslt ?>
<xsl:stylesheet
	version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:umb="urn:umbraco.library"
	extension-element-prefixes="umb"
>
	
	<xsl:output
		method="xml"
		indent="yes"
		omit-xml-declaration="yes"
	/>
	
<!--
	Umbraco supplies this parameter.
	The select attribute is used when no value is supplied from "outside" (i.e. local development)
-->
	<xsl:param name="currentPage" select="/root/&node;[1]" />
	
	<!-- Test if we can detect QueryString parameters -->
	<xsl:variable name="queryStringAvailable" select="function-available('&QueryString;')" />

	<!-- Grab the root node -->
	<xsl:variable name="root" select="$currentPage/ancestor::root" />
	
	<!-- Allowed for this node? -->
	<xsl:variable name="xmldumpAllowed" select="boolean($currentPage/ancestor-or-self::*[&xmldumpAllowed; = 1] | $currentPage/ancestor-or-self::node[data[@alias = '&xmldumpAllowed;'] = 1])" />
	
	<!-- Determine if using legacy or v4.5 XML Schema -->
	<xsl:variable name="isLegacyXML" select="boolean(not($root/*[@isDoc][1]))" />
	<xsl:variable name="isNewXML" select="not($isLegacyXML)" />
	
<!-- :: Configuration variables :: -->
<!--
	You can tailor the XML output to your needs by specifying some
	URL parameters - e.g. to check a specific node (by id), or you need to
	see all nodes of a specific Document Type.
	
	The following variables handle these.
-->

	<xsl:variable name="nodeId">
		<xsl:if test="$queryStringAvailable">
			<xsl:value-of select="&QueryString;('id')" />
		</xsl:if>
	</xsl:variable>

	<xsl:variable name="type">
		<xsl:if test="$queryStringAvailable">
			<xsl:value-of select="&QueryString;('type')" />
		</xsl:if>
	</xsl:variable>
	
	<xsl:variable name="mediaId">
		<xsl:if test="$queryStringAvailable">
			<xsl:value-of select="&QueryString;('media')" />
		</xsl:if>
	</xsl:variable>
	
	<xsl:variable name="property">
		<xsl:if test="$queryStringAvailable">
			<xsl:value-of select="&QueryString;('property')" />
		</xsl:if>
	</xsl:variable>
	
	<xsl:variable name="xpath">
		<xsl:if test="$queryStringAvailable">
			<xsl:value-of select="&QueryString;('xpath')" />
		</xsl:if>
	</xsl:variable>

	<xsl:variable name="hidden">
		<xsl:if test="$queryStringAvailable">
			<xsl:value-of select="&QueryString;('hidden')" />
		</xsl:if>
	</xsl:variable>
	<xsl:variable name="hiddenOnly" select="boolean(&hiddenBOOL;)" />
	
	<xsl:variable name="sitemap">
		<xsl:if test="$queryStringAvailable">
			<xsl:value-of select="&QueryString;('sitemap')" />
		</xsl:if>
	</xsl:variable>
	<xsl:variable name="navOnly" select="boolean(&sitemapBOOL;)" />
	
	<!-- Secret option - not ready for prime time yet :-) -->
	<xsl:variable name="memberId">
		<xsl:if test="$queryStringAvailable">
			<xsl:value-of select="&QueryString;('member')" />
		</xsl:if>
	</xsl:variable>

	<xsl:variable name="verbose">
		<xsl:if test="$queryStringAvailable">
			<xsl:value-of select="&QueryString;('verbose')" />
		</xsl:if>
	</xsl:variable>
	<xsl:variable name="verbosity" select="boolean(&verboseBOOL;)" />
	
	<xsl:variable name="processChildNodes" select="
		not(
			$hiddenOnly
			or number($nodeId)
			or normalize-space($type)
			or normalize-space($property)
			or normalize-space($xpath)
		) or $verbosity" />
	
<!-- :: Templates :: -->

	<xsl:template match="/">
		<!-- Start up the engines... -->
		<xsl:apply-templates select="macro[$xmldumpAllowed]" />
		
		<!-- ...or show them the door -->
		<xsl:apply-templates select="macro[not($xmldumpAllowed)]" mode="unauthorized" />
	</xsl:template>
	
	<xsl:template match="macro">
		<!-- Start by writing a 'usage' comment to the output  -->
		<xsl:call-template name="usage-comment" />
		
		<!-- Now decide what to output, determined by the supplied options (if any) -->
		<xsl:choose>
			<!-- Was a specific node requested by id? -->
			<xsl:when test="number($nodeId)">
				<xsl:apply-templates select="$root//&node;[@id = $nodeId]" />
			</xsl:when>
			
			<!-- Was an XPath specified? -->
			<xsl:when test="normalize-space($xpath)">
				<!-- We need to build an XPath we can use with the library method GetXmlNodeByXPath() -->
				<xsl:variable name="queryXPath">
					<xsl:choose>
						<!-- Convert shorthand './' (if present) to the equivalent of $currentPage -->
						<xsl:when test="starts-with($xpath, './')">
							<xsl:value-of select="concat('/root//*[@id = ', $currentPage/@id, ']', substring($xpath, 2))" />
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$xpath" />
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<!-- Next we create the printed XPath that you'll end up copying for your XSLT -->
				<xsl:variable name="umbXPath">
					<xsl:choose>
						<xsl:when test="starts-with($xpath, './')">
							<xsl:value-of select="concat('$currentPage', substring($xpath, 2))" />
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$queryXPath" />
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				
				<output select="{$umbXPath}">
					<xsl:apply-templates select="&GetXmlNodeByXPath;($queryXPath)" />
				</output>
			</xsl:when>
			
			<!-- Do we only want a specific property? -->
			<xsl:when test="normalize-space($property)">
				<output property="{$property}">
					<!-- Using the "Mutually Exclusive Hack" -->
					<xsl:apply-templates select="$root//&node;[data[@alias = $property]]" />
					<xsl:apply-templates select="$root//&node;[*[name() = $property]]" />
				</output>
			</xsl:when>
			
			<!-- Requested a DocumentType? -->
			<xsl:when test="normalize-space($type)">
				<output documentType="{$type}">
					<xsl:apply-templates select="$root//&node;[&docType; = $type]" />
				</output>
			</xsl:when>

			<!-- Specific Media id? -->
			<xsl:when test="number($mediaId)">
				<xsl:variable name="mediaNode" select="&GetMedia;($mediaId, true())" />
					<media>
						<xsl:apply-templates select="$mediaNode[not(error)]" />
					</media>
			</xsl:when>
			
			<!-- Only show sitemap-style nodes? -->
			<xsl:when test="$navOnly">
				<root id="-1">
					<xsl:apply-templates select="$root/&node;[1]" mode="sitemap" />
				</root>					
			</xsl:when>
			
			<!-- Member node? quirky, but let's try to get the current member... -->
			<xsl:when test="number($memberId)">
				<members>
					<xsl:copy-of select="&GetCurrentMember;()" />
				</members>
			</xsl:when>
			
			<!-- Show only hidden nodes? -->
			<xsl:when test="$hiddenOnly">
				<output>
					<xsl:attribute name="&umbracoNaviHide;">1</xsl:attribute>
					<xsl:apply-templates select="$root//&node;[&hidden;]" />
				</output>
			</xsl:when>
			
			<xsl:otherwise>
				<!-- Okay, no specific nodes selected - show tree from $currentPage -->
				<xsl:apply-templates select="$currentPage" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- Template for copying nodes -->
	<xsl:template match="*">
		<!-- Copy the current node (whatever it's called) -->
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
			
			<!-- Process the properties or their text nodes -->
			<xsl:choose>
				<xsl:when test="&isNewXMLParam;">
					<xsl:apply-templates select="*[not(@isDoc)] | self::*[not(@isDoc)]/text()" />
				</xsl:when>
				<xsl:when test="&isLegacyXMLParam;">
					<xsl:apply-templates select="data | self::data/text()" />
				</xsl:when>
			</xsl:choose>
			
			<!-- Only continue copying nested DocumentType elements if applicable -->
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
	
	<xsl:template match="&data;/text()">
		<xsl:value-of select="." />
	</xsl:template>
	
	<!-- Template for 'sitemap' mode -->
	<xsl:template match="&node;" mode="sitemap">
		<xsl:element name="{name()}">
			<xsl:copy-of select="&sitemapAttributes;" />
			<xsl:apply-templates select="&node;" mode="sitemap" />
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="&node;[&hidden;]" mode="sitemap" />
	
<!-- :: Utility templates :: -->
	<xsl:template name="usage-comment">
<xsl:comment xml:space="preserve">
	&XMLDumpVersionHeader;
	======================================================================================
	Options (QueryString parameters):
	- id		Grab a node by its id, e.g.: id=1080
	- type		Grab node(s) by their DocumentType, e.g.: type=GalleryItem
	- property	Find nodes that have a specific property, e.g.: property=metaDescription
	- media		View XML for media item, e.g.: media=1337
	- sitemap	Set to 'yes' to show navigation structure only (shows only "&sitemapAttributes;" and hides nodes with '&umbracoNaviHide;' checked)
	- hidden	Set to 'yes' to show all nodes with '&umbracoNaviHide;' checked.
	
	- verbose	Show all attributes of Document nodes (by default only shows "&standardAttributes;").
	======================================================================================
	Experimental Option (XPath knowledge required - typos may wreak havoc!):
	Note that you can't use variables (for now).
	Start with "./" to use $currentPage as context node.
	- xpath		Grab node(s) using an XPath, e.g.: xpath=/root//&node;[@nodeName = 'Home']

	(For all boolean options, the values 'yes', 'true' and '1' all work as expected)
</xsl:comment>
	</xsl:template>
	
	<xsl:template match="macro" mode="unauthorized">
		<output>
<xsl:comment xml:space="preserve">
	XMLDump is not allowed for this node
	====================================
	To enable, add a boolean property with the alias "&xmldumpAllowed;" on your top-level Document Type.
	Then go to the corresponding Content node and check that box. Hit "Save and Publish" to allow XMLDump.

	* Don't forget to uncheck the box again, prior to taking your site live! *

	&XMLDumpVersionHeader;
</xsl:comment>
		</output>
	</xsl:template>

</xsl:stylesheet>