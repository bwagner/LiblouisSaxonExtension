SAXON=lib/saxon9he.jar
LOUIS=lib/jna.jar:lib/louis.jar
LOUIS_TRANSFORM_FACTORY=-Djavax.xml.transform.TransformerFactory=org.liblouis.transformerfactory.LouisExtensionTransformerFactoryImpl
LOUIS_SAXON_EXT=bin
UTFX=.:utfx_lib/avalon.jar:utfx_lib/batik.jar:utfx_lib/fop.jar:utfx_lib/JimiProClasses.zip:utfx_lib/junit.jar:utfx_lib/log4j-1.2.8.jar:utfx_lib/resolver.jar:utfx_lib/utfxPatched.jar:utfx_lib/xalan.jar:utfx_lib/xercesImpl.jar:utfx_lib/xercesSamples.jar:utfx_lib/xml-apis.jar
UTFX_TEST=-Dutfx.test.file=test_xsl/dtbook2sbsform_test.xml

java \
	$LOUIS_TRANSFORM_FACTORY \
	$UTFX_TEST \
	-cp $SAXON:$LOUIS:$LOUIS_SAXON_EXT:$UTFX \
	 utfx.runner.TestRunner utfx.framework.XSLTRegressionTest
