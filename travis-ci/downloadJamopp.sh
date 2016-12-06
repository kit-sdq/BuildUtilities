wget -P /tmp http://update.jamopp.org/trunk/plugins/org.emftext.language.java_1.4.1.v201610152108.jar
mv /tmp/org.emftext.language.java_1.4.1.v201610152108.jar /tmp/org.emftext.language.java_1.4.1.jar
mvn install:install-file -Dfile=/tmp/org.emftext.language.java_1.4.1.jar -DgroupId=org.emftext -DartifactId=org.emftext.language.java -Dversion=1.4.1 -Dpackaging=jar