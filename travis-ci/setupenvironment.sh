# This script is supposed to set up the build environment at Travis-CI. It may install additional artifacts/tools or other versions of them, if necessary.

# For example, Travis-CI used Maven versions that were not compatible with Eclipse plugins, pomless builds etc., which forced us to install a different Maven version as follows:
# wget https://archive.apache.org/dist/maven/maven-3/3.6.0/binaries/apache-maven-3.6.0-bin.zip
# unzip -qq apache-maven-3.6.0-bin.zip
# export M2_HOME=$PWD/apache-maven-3.6.0
# export PATH=$M2_HOME/bin:$PATH
