if [[ ! -d dist ]]
	then mkdir dist
fi
if [[ ! -d package ]]
	then mkdir package
fi

xsltproc --novalid --output package/XMLDump.xslt lib/freezeEntities.xslt src/XMLDump.xslt 
xsltproc --novalid --xinclude --output package/package.xml lib/freezeEntities.xslt src/package.xml 

zip -j dist/XMLDump package/* -x \*.DS_Store

# coffee  -o package/ -c src/xmldump.coffee