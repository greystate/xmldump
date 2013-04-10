# Create the dist directory if needed
if [[ ! -d dist ]]
	then mkdir dist
fi
# Likewise, create the package dir
if [[ ! -d package ]]
	then mkdir package
fi

# Get the current version
VERSION=`grep -o ' packageVersion \"\(.*\)\"' src/version.ent | awk '{print $2}' | sed 's/"//g'`

# Make sure to use the PRODUCTION entities
UMBOFF="RELEASE \"IGNORE\""
UMBON="RELEASE \"INCLUDE\""

TMOFF="TESTING \"IGNORE\""
TMON="TESTING \"INCLUDE\""

sed -i "" "s/$UMBOFF/$UMBON/" src/compatibility.ent
sed -i "" "s/$TMON/$TMOFF/" src/compatibility.ent


# Transform the development XSLT into the release file
xsltproc --novalid --output package/XMLDump.xslt lib/freezeEntities.xslt src/XMLDump.xslt

# Transform the package.xml file, pulling in the README
xsltproc --novalid --xinclude --output package/package.xml lib/freezeEntities.xslt src/package.xml 

# Build the ZIP file 
zip -j "dist/XMLDump-$VERSION.zip" package/* -x \*.DS_Store

# Copy the release XSLT into the dist dir for upgraders
cp package/XMLDump.xslt dist/XMLDump.xslt

# Go back to DEVELOPMENT entities again
sed -i "" "s/$UMBON/$UMBOFF/" src/compatibility.ent
sed -i "" "s/$TMOFF/$TMON/" src/compatibility.ent

# This is a future enhancement in the works ...
# coffee  -o package/ -c src/xmldump.coffee