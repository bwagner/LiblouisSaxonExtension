package ch.sbs.liblouis.utils;

import static org.junit.Assert.*;

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
