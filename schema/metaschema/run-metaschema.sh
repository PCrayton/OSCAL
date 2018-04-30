# Converts OSCAL into XPath's JSON XML syntax, then converts that to JSON

METASCHEMAXML=$1

# munge input file name: oscal-catalog-metaschema.xml becomes oscal-catalog-schema
TRIMNAME=$(sed 's/-metaschema//' <<< $METASCHEMAXML)
BASENAME=$(sed 's/.xml//'  <<< $TRIMNAME)

OSCALDIR=../..
LIBDIR=$OSCALDIR/build/metaschema

XSDRESULT=$OSCALDIR/schema/xml/$BASENAME-schema.xsd
JSCRESULT=$OSCALDIR/schema/json/$BASENAME-schema.json
DOCRESULT=$OSCALDIR/schema/metaschema/$BASENAME-docs.md
XMLJSXSLT=$OSCALDIR/lib/XML-JSON/$BASENAME-xml-converter.xsl
JSXMLXSLT=$OSCALDIR/lib/XML-JSON/$BASENAME-json-converter.xsl

# This could be a call to maven, gradle or functional equivalent
SAXON="/home/wendell/Saxon/saxon9he.jar"
# Saxon CL documented here: http://www.saxonica.com/documentation9.5/using-xsl/commandline.html

# Each call produces a separate schema
JAVACALLX="java -jar $SAXON -s:$METASCHEMAXML -o:$XSDRESULT -xsl:$LIBDIR/produce-xsd.xsl"
JAVACALLJ="java -jar $SAXON -s:$METASCHEMAXML -o:$JSCRESULT -xsl:$LIBDIR/produce-json-schema.xsl"
JAVADOCMS="java -jar $SAXON -s:$METASCHEMAXML -o:$DOCRESULT -xsl:$LIBDIR/metaschema-docs-md.xsl"
JAVAXMLJS="java -jar $SAXON -s:$METASCHEMAXML -o:$XMLJSXSLT -xsl:$LIBDIR/produce-xml-converter.xsl"
JAVAJSXML="java -jar $SAXON -s:$METASCHEMAXML -o:$JSXMLXSLT -xsl:$LIBDIR/produce-json-converter.xsl"

# Now ...
echo
echo Producing JSON and XML schemas and tools from $METASCHEMAXML ...
echo

cp -u $LIBDIR/OSCAL/oscal-prose-module.xsd $OSCALDIR/schema/xml
echo / Updated OSCAL prose XSD module

$JAVACALLJ
echo / Made JSON Schema ______________ $JSCRESULT

$JAVACALLX
echo / Made XSD ______________________ $XSDRESULT

$JAVADOCMS
echo / Made markdown documentation ___ $DOCRESULT

$JAVAXMLJS
echo / Made XML-to-JSON converter ____ $XMLJSXSLT
$JAVAJSXML
echo / Made JSON-to-XML converter ____ $JSXMLXSLT
echo
