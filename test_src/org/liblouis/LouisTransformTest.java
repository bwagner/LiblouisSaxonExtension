package org.liblouis;

import static org.junit.Assert.*;

import java.io.ByteArrayOutputStream;
import java.io.PrintStream;

import org.junit.Test;

/**
 * One-shot redirection of stdout into a String.
 * 
 */
class SysOutSaver {
	
	public interface Hook {
		void hook();
	}

	/**
	 * @param hook hook to be called and capturing its output
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
				final String[] args = new String[] {
						"-xsl:xsl/dtbook2sbsform.xsl",
						"-s:resources/dtbook/dtbook.xml", };

				new LouisTransform().doTransform(args,
						"java org.liblouis.LouisTransform");
			}

		});

		final String expected = " ,! qk br{n fox jumps ov} ! lazy dog4";
		assertTrue(sysout.indexOf(expected) != -1);
	}

	@Test
	public void testSetparam() {

		final String sysout = SysOutSaver.process(new SysOutSaver.Hook() {
			@Override
			public void hook() {
				final String[] args = new String[] {
						"-xsl:xsl/dtbook2sbsform.xsl",
						"-s:resources/dtbook/dtbook.xml", "contraction=1",
						"cells_per_line=30", "hyphenation=true",
						"show_original_page_numbers=false",
						"detailed_accented_characters=foo" };

				new LouisTransform().doTransform(args,
						"java org.liblouis.LouisTransform");
			}

		});

		assertTrue(sysout.indexOf("cells_per_line:30") != -1);
		assertTrue(sysout.indexOf("hyphenation:true") != -1);
		assertTrue(sysout.indexOf("show_original_page_numbers:false") != -1);
		assertTrue(sysout.indexOf("detailed_accented_characters:foo") != -1);
	}
}
