package ch.sbs.liblouis.utils;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;

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

public class LineBreaker {

	private static final int STD_WIDTH = 80;

	/**
	 * Simplistic left-alignment formatting of text. Lines are wrapped at
	 * whitespaces. If a sequence of non-whitespaces exceeds the desired width,
	 * the resulting line will simply be too long. Consecutive whitespaces will
	 * be condensed into a single blank.
	 * formatSbs-variant throws a RuntimeException when a newline is encountered
	 * within the string, since this is not supported.
	 * 
	 * TODO: If the string contains newlines these will not be taken into
	 * account, i.e. we want to maintain the newline-formatting of the source.
	 * BUT: when encountering a newline, the currentCol needs to be updated.
	 * Otherwise a line will be broken at unexpected places because the
	 * algorithm believes we're still on the same line and reaching the width.
	 * 
	 * @param input
	 *            The text to be formatted.
	 * @param width
	 *            The width
	 * @return The formatted text.
	 */
	public static String format(final String input, final String indent,
			int width) {
		final StringBuilder result = new StringBuilder();
		// the regex could be \s, but I want to preserve newlines
		// so I have to exclude them from the pattern.
		// http://download.oracle.com/javase/1.4.2/docs/api/java/util/regex/Pattern.html#predef
		final String[] chunks = input.split("[ \\t\\x0B\\f\\r]+");
		int currentCol = 0;
		for (final String chunk : chunks) {
			if (indent.length() + currentCol + chunk.length() + 1 > width) {
				removeLastChar(result);
				result.append("\n");
				result.append(indent);
				currentCol = indent.length();
			}
			result.append(chunk);
			result.append(" ");
			currentCol += chunk.length() + 1;
		}
		if(result.length() > 0){
			removeLastChar(result);
		}
		return result.toString();
	}

	private static void removeLastChar(final StringBuilder result) {
		result.deleteCharAt(result.length() - 1);
	}

	/**
	 * @param input
	 * @return
	 */
	public static String formatSbs(final String input) {
		return formatSbs(input, STD_WIDTH);
	}

	/**
	 * We're calling this routine from a loop that reads from stdin (see main
	 * method) line by line, thus we never have a newline in our string, except 
	 * at the very end.
	 * @param input
	 * @return
	 */
	public static String formatSbs(final String input, int width) {
		final int idxOfNewline;
		if ((idxOfNewline = input.lastIndexOf("\n")) != input.length() - 1
				&& idxOfNewline != -1) {
			throw new RuntimeException("newline within input not "
					+ "supported. Occurs at idx:" + idxOfNewline + " in "
					+ input + " length " + input.length());
		}
		return input.startsWith(" ") ? format(input, " ", width) : input;
	}

	public static void main(final String[] args) {
		try {
			final BufferedReader in = new BufferedReader(new InputStreamReader(
					System.in));
			String line;
			if (args.length == 0) {
				while ((line = in.readLine()) != null) {
					System.out.println(formatSbs(line));
				}
			} else {
				int width = STD_WIDTH;
				if (args.length > 0) {
					width = Integer.parseInt(args[0]);
				}
				while ((line = in.readLine()) != null) {
					System.out.println(formatSbs(line, width));
				}
			}
		} catch (final IOException e) {
			throw new RuntimeException(e);
		}
	}

}
