#!/bin/sh

java \
	-classpath bin:lib/saxon9he.jar:lib/louis.jar:lib/jna.jar \
	org.liblouis.MyTransform "$@"
