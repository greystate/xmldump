if [[ ! -d dist ]]
	then mkdir dist
fi
if [[ ! -d package ]]
	then mkdir package
fi

xsltproc --novalid --output package/XMLDump.xslt lib/freezeEntities.xslt src/XMLDump.xslt 
cp src/package.xml package/package.xml

zip -j dist/XMLDump package/*
