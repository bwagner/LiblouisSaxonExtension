package org.liblouis;

import net.sf.saxon.Transform;
import net.sf.saxon.trans.XPathException;

public class LouisTransform extends Transform {

	private void addExtension() {
		try {
			getConfiguration().registerExtensionFunction(
					new LouisExtensionFunctionDefinition());
		} catch (final XPathException e) {
			throw new RuntimeException("failed adding extension:", e);
		}
	}

	@Override
	public void setFactoryConfiguration(boolean schemaAware, String className)
			throws RuntimeException {
		super.setFactoryConfiguration(schemaAware, className);
		addExtension();
	}

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		new LouisTransform().doTransform(args, "java org.liblouis.LouisTransform");
	}

}
