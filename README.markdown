# XMLDump for Umbraco

If you’ve been developing XSLT for Umbraco, you’ve probably already done your share
of <code>&lt;textarea&gt;&lt;xsl:copy-of select="." /&gt;&lt;/textarea&gt;</code> to examine the XML you’re transforming...
let’s get rid of that habit and do something much better.

With this simple package you’ll have instant access to all
published nodes, selectable by id or document type - many browsers support viewing XML
in a nice color-coded fashion, so now you can let IE6 do the only thing it’s good at and
leave it open on your secondary screen :-)

## Files Installed

The package installs a Template, an XSLT Macro and a Config - the files are:

	~/masterpages/XMLDump.master
	~/xslt/XMLDump.xslt
	~/config/XMLDump.config

How To Use
----------

### A Note On Security

Because installing XMLDump will allow **anyone** to see the entire data structure of your site, I've decided
to require an extra step that makes you, the developer, responsible for switching the feature on and off.
You can do that in two different ways:

1. XMLDump will look for a property called `xmldumpAllowedIPs` recursively upwards from the start node selected for viewing (see below) and if that property contains the IP address of the current request (the REMOTE_ADDR server variable), it will render the XML. So you need to add a textstring property to your "website" Document Type and subsequently fill in your IP address on the corresponding content node before XMLDump will render anything.

2. As of version 0.9.3 you can also add the IP address(es) to the `XMLDump.config` file in the `config` folder - there should be an empty `<xmldumpAllowedIPs>` element in there which you can fill in.

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

To keep the XML viewable, XMLDump will hide some of the attributes of a Document, e.g. `@writerName`, `@createdDate` etc. To view the complete XML you specify the `verbose` option:

	http://yourwebsite.com/xmldump?id=1234&verbose=yes
	
(aliased as simply `v` for convenience)

### type

If you want to see all nodes of a specific Document Type, use the `type` option:

	http://yourwebsite.com/xmldump?type=NewsItem
	
### media

The XML for media items isn't stored in the Umbraco XML cache, but you can see what a particular item's XML contains, using the `media` parameter:

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
	
(If you don't start with a forward slash the expression will use `$currentPage` as context node, otherwise you'll need to specify a complete XPath)

### search

If you're looking for a specific piece of information, you can perform a search through the complete tree using the `search` option:

	http://yourwebsite.com/xmldump?search=Contact
	
The search is performed case-insensitive on `@nodeName` and all properties)

### mntp

The `mntp` option is specific to using some of the [uComponents][1] datatypes, specifically "Multi-Node Tree Picker", "XPath CheckBox List" and "CheckBox Tree" - if you set this flag, XMLDump will render a simple representation of the actual node that's referenced, instead of only showing the Id. Best to use on specific pages e.g:

	http://yourwebsite.com/projects/year2011/xmldump?mntp=yes

or:

	http://yourwebsite.com/xmldump/?id=8220&mntp=yes



[1]:http://ucomponents.codeplex.com
 
Revision History
----------------

* v0.9.4: Updated to use new build script
* v0.9.3: Add config file for the `xmldumpAllowedIPs` key
* v0.9.2: Support XPath CheckBox List and CheckBox Tree with the `mntp` option too. Add count of matched nodes to output for `xpath` option
* v0.9.1: Bugfix release
* v0.9:   Lots of refactoring. Added options `search` &amp; `mntp`, changed some logic in `xpath` option
* v0.8:	  "Universal Binary" (compatible with both XML formats). Changed to use altTemplate syntax (e.g., to just get $currentPage). Added activation for security reasons
* v0.7:	  Added options: `xpath` &amp; `property`
* v0.6:	  Added options: `media` &amp; `sitemap`
* v0.5:	  Initial version, supporting the options: `node`, `type` &amp; `hidden`


Chriztian Steinmeier, April 2014
(Initial version: November 2009)