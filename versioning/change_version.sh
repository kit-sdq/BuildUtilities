#!/bin/Bash
#
# Increases the version of Maven (POM) and Eclipse (Manifest, features and update sites) artifacts of the given project.
# $1: Path to project
# $2: Current version
# $3: New version
# $4: "true", if new version shall be a release version (without .qualifier/-SNAPSHOT suffix), "false" otherwise

if [ $# -lt 4 ]; then
	echo "Not enough arguments given. We need the project directory, the current and new version number and whether the new version is a release or not."
	exit 1
fi

PROJECT=$1
CURRENT_VERSION=$2
NEW_VERSION=$3
IS_RELEASE=$4

MANIFEST_VERSION_SUFFIX=".qualifier"
POM_VERSION_SUFFIX="-SNAPSHOT"

cd $PROJECT
git grep -l "$CURRENT_VERSION$MANIFEST_VERSION_SUFFIX" | xargs sed -i "s/$CURRENT_VERSION$MANIFEST_VERSION_SUFFIX/$NEW_VERSION$MANIFEST_VERSION_SUFFIX/g"
git grep -l "$CURRENT_VERSION$POM_VERSION_SUFFIX" | xargs sed -i "s/$CURRENT_VERSION$POM_VERSION_SUFFIX/$NEW_VERSION$POM_VERSION_SUFFIX/g"
if [ $IS_RELEASE == "true" ]; then
	git grep -l "$NEW_VERSION$MANIFEST_VERSION_SUFFIX" | xargs sed -i "s/$NEW_VERSION$MANIFEST_VERSION_SUFFIX/$NEW_VERSION/g"
	git grep -l "$NEW_VERSION$POM_VERSION_SUFFIX" | xargs sed -i "s/$NEW_VERSION$POM_VERSION_SUFFIX/$NEW_VERSION/g"
fi