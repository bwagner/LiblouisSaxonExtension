package org.liblouis;

import net.sf.saxon.expr.XPathContext;
import net.sf.saxon.functions.ExtensionFunctionCall;
import net.sf.saxon.functions.ExtensionFunctionDefinition;
import net.sf.saxon.om.EmptyIterator;
import net.sf.saxon.om.SequenceIterator;
import net.sf.saxon.om.SingletonIterator;
import net.sf.saxon.om.StructuredQName;
import net.sf.saxon.trans.XPathException;
import net.sf.saxon.value.SequenceType;
import net.sf.saxon.value.StringValue;

import org.liblouis.Louis;

public class LouisExtensionFunctionDefinition extends
		ExtensionFunctionDefinition {

	private static final StructuredQName funcname = new StructuredQName("louis",
			"http://liblouis.org/liblouis", "translate");

	@Override
	public StructuredQName getFunctionQName() {
		return funcname;
	}

	@Override
	public int getMinimumNumberOfArguments() {
		return 2;
	}

	@Override
	public int getMaximumNumberOfArguments() {
		return 2;
	}

	@Override
	public SequenceType[] getArgumentTypes() {
		return new SequenceType[] { SequenceType.SINGLE_STRING,
				SequenceType.SINGLE_STRING };
	}

	@Override
	public SequenceType getResultType(SequenceType[] suppliedArgumentTypes) {
		return SequenceType.SINGLE_STRING;
	}

	@Override
	public ExtensionFunctionCall makeCallExpression() {
		return new ExtensionFunctionCall() {

			@Override
			public SequenceIterator call(SequenceIterator[] arguments,
					XPathContext context) throws XPathException {

				final StringValue table = (StringValue) arguments[0].next();
				if (null == table) {
					return EmptyIterator.getInstance();
				}

				final StringValue toTranslate = (StringValue) arguments[1]
						.next();
				if (null == toTranslate) {
					return EmptyIterator.getInstance();
				}

				return SingletonIterator.makeIterator(new StringValue(Louis
						.translate(table.getStringValue(),
								toTranslate.getStringValue())));
			}

			private static final long serialVersionUID = 1L;
		};
	}

	private static final long serialVersionUID = 1L;
}
