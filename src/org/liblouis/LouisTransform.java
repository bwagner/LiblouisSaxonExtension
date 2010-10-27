package org.liblouis;

import net.sf.saxon.Configuration;
import net.sf.saxon.Transform;
import net.sf.saxon.trans.XPathException;

public class LouisTransform extends Transform {
	
	private void addExtension(){
		try {
			getConfiguration().registerExtensionFunction(
					new LouisExtensionFunctionDefinition());
		} catch (final XPathException e) {
			throw new RuntimeException("failed adding extension:",e);
		}		
	}
	
	private void configStuff(){
		config = Configuration.newConfiguration();
		config.setVersionWarning(true);
        try {
            setFactoryConfiguration(false, null);
        } catch (final Exception err) {
            err.printStackTrace();
            System.err.println(err.getMessage());
            System.exit(2);
        }
	}
	/**
	 * @param args
	 */
	public static void main(String[] args) {
		LouisTransform myt = new LouisTransform();
		myt.configStuff();
		myt.addExtension();
		myt.doTransform(args, "java org.liblouis.LouisTransform");
	}

}
