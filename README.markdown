# XMLDump for Umbraco

If you’ve been developing XSLT for Umbraco, you’ve probably already done your share
of <code>&lt;textarea&gt;&lt;xsl:copy-of select="." /&gt;&lt;/textarea&gt;</code> to examine the XML you’re transforming...
let’s get rid of that habit and do something much better.

With this simple package you’ll have instant access to all
published nodes, selectable by id or document type - many browsers support viewing XML
in a nice color-coded fashion, so now you can let IE6 do the only thing it’s good at and
leave it open on your secondary screen :-)

## Files Installed

The package installs a Template and an XSLT Macro - the files are:

	~/masterpages/XMLDump.master
	~/xslt/XMLDump.xslt

How To Use
----------

### A Note On Security

Because installing XMLDump will allow **anyone** to see the entire data structure of your site, I've decided
to require an extra step that makes you, the developer, responsible for switching the feature on and off.
Here's how that works:

XMLDump will look for a property called `xmldumpAllowed` recursively upwards from the
start node selected for viewing (see below) and only if that property is set, it will render the XML. So you
need to add a boolean (true/false) property to your "website" Document Type and subsequently check that box on
the corresponding content node before XMLDump will render anything.

### Viewing the XML

After you've successfully installed the package, you can use the altTemplate syntax to view the underlying XML of your
Umbraco website - just open your site in a web browser and go to the following URL:

	http://yourwebsite.com/xmldump

Or, if you're not using Directory URLs:

	http://yourwebsite.com/xmldump.aspx

You can also view the XML for a specific page by doing the same thing, e.g.:

	http://yourwebsite.com/about/xmldump


Options
-------

XMLDump allows a set of options on the query string and conveniently displays what they are at the top of its output. Currently, the options are:

### id

To see a specific page's XML you can just specify its nodeId to the `id` option, regardless of the page you're currently viewing:

	http://yourwebsite.com/about/xmldump?id=1234
	
### verbose

To keep the XML viewable, XMLDump will hide some of the attributes of a Document, e.g. @writerName, @createdDate etc. To view the complete XML you specify the `verbose` option:

	http://yourwebsite.com/xmldump?id=1234&verbose=yes
	
(aliased as simply `v` for convenience)

### type

If you want to see all nodes of a specific Document Type, use the `type` option:

	http://yourwebsite.com/xmldump?type=NewsItem
	
### media

The XML for media items isn't stored in the Umbraco XML cache, but you can see what a particular items' XML contains, using the `media` parameter:

	http://yourwebsite.com/xmldump?media=1337

### prop

If you need to find Documents that have a specific property, use the `prop` option:

	http://yourwebsite.com/xmldump?prop=googleAnalyticsCode

(This is aliased as `property` - so you can use whichever suits you.)

### hidden

Use this to see all the Documents that have the `umbracoNaviHide` property set to 1:

	http://yourwebsite.com/xmldump?hidden=yes

### sitemap

If you need a quick overview of the site, use the `sitemap` option:

	http://yourwebsite.com/xmldump?sitemap=yes

### xpath

For those times where you need to do some hardcore scrutiny on the XML you can specify an XPath expression, e.g.:

	http://yourwebsite.com/about/xmldump?xpath=ancestor-or-self::*[analyticsCode]

Revision History
----------------

* v0.9: Lots of refactoring. Added options `search` &amp; `mntp`, changed some logic in `xpath` option.
* v0.8:	"Universal Binary" (compatible with both XML formats). Changed to use altTemplate syntax (e.g., to just get $currentPage). Added activation for security reasons
* v0.7:	Added options: `xpath` &amp; `property`
* v0.6:	Added options: `media` &amp; `sitemap`
* v0.5:	Initial version, supporting the options: `node`, `type` &amp; `hidden`


Chriztian Steinmeier, March 2011
(Initial version: November 2009)