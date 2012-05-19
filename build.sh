# Create the dist directory if needed
if [[ ! -d dist ]]
	then mkdir dist
fi
# Likewise, create the package dir
if [[ ! -d package ]]
	then mkdir package
fi

# Transform the development XSLT into the release file
xsltproc --novalid --output package/XMLDump.xslt lib/freezeEntities.xslt src/XMLDump.xslt

# Transform the package.xml file, pulling in the README
xsltproc --novalid --xinclude --output package/package.xml lib/freezeEntities.xslt src/package.xml 

# Build the ZIP file 
zip -j dist/XMLDump package/* -x \*.DS_Store

# Copy the release XSLT into the dist dir for upgraders
cp package/XMLDump.xslt dist/XMLDump.xslt

# This is a future enhancement in the works ...
# coffee  -o package/ -c src/xmldump.coffee