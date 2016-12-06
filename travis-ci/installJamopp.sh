#!/bin/bash
# Installs the JaMoPP nightly build
#
# Add this to your .travis.yml:
#
#	before_install:
#   - git clone --depth 1 https://github.com/vitruv-tools/BuildUtilities.git /tmp/BuildUtils
#	- . /tmp/BuildUtilities/travis-ci/installJamopp.sh
#	install: true
#

wget -P /tmp http://update.jamopp.org/trunk/plugins/org.emftext.language.java_1.4.1.v201610152108.jar
mv /tmp/org.emftext.language.java_1.4.1.v201610152108.jar /tmp/org.emftext.language.java_1.4.1.jar
mvn install:install-file -Dfile=/tmp/org.emftext.language.java_1.4.1.jar -DgroupId=org.emftext -DartifactId=org.emftext.language.java -Dversion=1.4.1 -Dpackaging=jar