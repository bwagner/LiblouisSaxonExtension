package org.liblouis;

import static org.junit.Assert.assertEquals;

import java.io.ByteArrayOutputStream;
import java.io.PrintStream;

import org.junit.Test;

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

/**
 * One-shot redirection of stdout into a String.
 * 
 */
class SysOutSaver {

	public interface Hook {
		void hook();
	}

	/**
	 * @param hook
	 *            hook to be called and capturing its output
	 * @return Hook's stdout captured in a string
	 */
	public static String process(final Hook hook) {
		return new SysOutSaver().processInternal(hook);
	}

	/**
	 * prevent instantiation
	 */
	private SysOutSaver() {

	}

	private String processInternal(final Hook hook) {
		System.setOut(new PrintStream(byteArrayOutputStream));
		hook.hook();
		System.setOut(saveOut);
		return byteArrayOutputStream.toString();
	}

	private final ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream();
	private final PrintStream saveOut = System.out;

}

public class LouisTransformTest {

	@Test
	public void testTransform() {

		final String sysout = SysOutSaver.process(new SysOutSaver.Hook() {
			@Override
			public void hook() {
				final String[] args = new String[] { "-xsl:resources/test.xsl",
						"-s:resources/test.xml", };

				new LouisTransform().doTransform(args,
						"java org.liblouis.LouisTransform");
			}

		});

		final String expected = ",! qk br{n fox jumps ov} ! lazy dog4";
		assertEquals(expected, sysout);
	}

}
