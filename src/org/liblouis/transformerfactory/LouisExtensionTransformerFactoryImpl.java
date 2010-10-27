package org.liblouis.transformerfactory;

import org.liblouis.LouisExtensionFunctionDefinition;

import net.sf.saxon.Configuration;
import net.sf.saxon.TransformerFactoryImpl;
import net.sf.saxon.trans.XPathException;

public class LouisExtensionTransformerFactoryImpl extends TransformerFactoryImpl {
	public LouisExtensionTransformerFactoryImpl(){
		addExtension();
	}
	public LouisExtensionTransformerFactoryImpl(final Configuration config){
		super(config);
		addExtension();
	}
	
	private void addExtension(){
		try {
			getConfiguration().registerExtensionFunction(
					new LouisExtensionFunctionDefinition());
		} catch (final XPathException e) {
			throw new RuntimeException("failed adding extension:",e);
		}		
	}
}
