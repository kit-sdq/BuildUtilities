wget https://archive.apache.org/dist/maven/maven-3/3.6.0/binaries/apache-maven-3.6.0-bin.zip
unzip -qq apache-maven-3.6.0-bin.zip
export M2_HOME=$PWD/apache-maven-3.6.0
export PATH=$M2_HOME/bin:$PATH