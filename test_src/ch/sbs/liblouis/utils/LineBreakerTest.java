package ch.sbs.liblouis.utils;

import static org.junit.Assert.*;

import org.junit.Test;
import ch.sbs.liblouis.utils.LineBreaker;


public class LineBreakerTest {
	@Test
	public void testSimple(){
			// 12345678901234567890
		final String input = ""
			+ "123 567 901234 678";
		
		final String expected = ""
			+ "123 567\n"
			+ "901234\n"
			+ "678";
		assertEquals(expected, LineBreaker.format(input, "", 10));
	}
	
	@Test
	public void testCondense(){
			// 12345678901234567890
		final String input = ""
			+ "123 567    901234 678";
		
		final String expected = ""
			+ "123 567\n"
			+ "901234\n"
			+ "678";
		assertEquals(expected, LineBreaker.format(input, "", 10));
	}
	
	@Test
	public void testPreserveNewline(){
			// 12345678901234567890
		final String input = ""
			+ "123\n567    901234 678";
		
		final String expected = ""
			+ "123\n"
			+ "567\n"
			+ "901234\n"
			+ "678";
		assertEquals(expected, LineBreaker.format(input, "", 10));
	}
	
	@Test(expected=RuntimeException.class)
	public void testIndentIdentity(){
		LineBreaker.formatSbs("b\nb", 10);
	}
	
	@Test
	public void testIndent(){
			// 12345678901234567890
		final String input = ""
			+ " 123 567    901234 678";
		
		final String expected = ""
			+ " 123 567\n"
			+ " 901234\n"
			+ " 678";
		
		assertEquals(expected, LineBreaker.formatSbs(input, 10));
	}
	
	@Test
	public void testIndent2(){
			// 12345678901234567890
		final String input = ""
			+ " 123 567    901234 678\n";
		
		final String expected = ""
			+ " 123 567\n"
			+ " 901234\n"
			+ " 678\n";
		
		assertEquals(expected, LineBreaker.formatSbs(input, 10));
	}
}
