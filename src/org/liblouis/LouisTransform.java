package org.liblouis;

import net.sf.saxon.Transform;
import net.sf.saxon.trans.XPathException;


/**
	* Copyright (C) 2010 Swiss Library for the Blind, Visually Impaired and Print Disabled
	*
	* This file is part of LiblouisSaxonExtension.
	* 	
	* LiblouisSaxonExtension is free software: you can redistribute it
	* and/or modify it under the terms of the GNU Lesser General Public
	* License as published by the Free Software Foundation, either
	* version 3 of the License, or (at your option) any later version.
	* 	
	* This program is distributed in the hope that it will be useful,
	* but WITHOUT ANY WARRANTY; without even the implied warranty of
	* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
	* Lesser General Public License for more details.
	* 	
	* You should have received a copy of the GNU Lesser General Public
	* License along with this program. If not, see
	* <http://www.gnu.org/licenses/>.
	*/

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
