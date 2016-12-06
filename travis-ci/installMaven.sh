#!/bin/bash
# Installs a recent version of maven into /tmp and adds it to path  
#
# Add this to your .travis.yml:
#
#	before_install:
#   - git clone --depth 1 https://github.com/vitruv-tools/BuildUtilities.git /tmp/BuildUtils
#	- . /tmp/BuildUtilities/travis-ci/installMaven.sh
#	install: true

wget -P /tmp http://www.apache.org/dist/maven/maven-3/3.3.9/binaries/apache-maven-3.3.9-bin.zip 
unzip -d /tmp -qq /tmp/apache-maven-3.3.9-bin.zip 
export M2_HOME=/tmp/apache-maven-3.3.9 
chmod +x $M2_HOME/bin/mvn 
export PATH=$M2_HOME/bin:$PATH 
sed -i.bak -e 's|https://nexus.codehaus.org/snapshots/|https://oss.sonatype.org/content/repositories/codehaus-snapshots/|g' ~/.m2/settings.xml
