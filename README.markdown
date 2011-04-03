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
Umbraco website - just open your site in a web browser and go to one of the following URLs:

* http://yourwebsite.com/xmldump.aspx
* http://yourwebsite.com/?alttemplate=xmldump 

You can also view the XML for a specific page by doing the same thing, e.g.:

* http://yourwebsite.com/about/xmldump.aspx
* http://yourwebsite.com/about.aspx?alttemplate=xmldump 

If you're using Directory URLs you can omit the ".aspx" from the above examples.

XMLDump allows a set of options on the query string and conveniently displays what they are at the top of its output.

Revision History
----------------

* v0.8:	"Universal Binary" (compatible with both XML formats). Changed to use altTemplate syntax (e.g., to just get $currentPage). Added "activation" for security reasons
* v0.7:	Added options: xpath &amp; property
* v0.6:	Added options: media &amp; sitemap
* v0.5:	Initial version, supporting the options: node, type &amp; hidden


Chriztian Steinmeier, March 2011
(Initial version: November 2009)