#!/bin/sh

java \
	-cp lib/saxon9he.jar:lib/louis.jar:lib/jna.jar:liblouissaxonx.jar \
	org.liblouis.LouisTransform "$@"
