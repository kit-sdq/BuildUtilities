#!/bin/bash
#
# Removes the qualifier and snapshot tags and commits the repository as a release version, and increases the version number to a new development version afterwards
# $1: Path to project
# $2: Current version
# $3: New version

if [ $# -lt 3 ]; then
	echo "Not enough arguments given. We need the project directory, the release and next development version number."
	exit 1
fi

DIR=$1
RELEASE_VERSION=$2
RELEASE_VERSION_BRANCH="tmp/Release$RELEASE_VERSION"
DEV_VERSION=$3
DEV_VERSION_BRANCH="tmp/Dev$DEV_VERSION"

SDQ_NIGHTLY_SITE="kit-sdq.github.io/updatesite/nightly"
SDQ_RELEASE_SITE="kit-sdq.github.io/updatesite/release"
VITRUV_NIGHTLY_SITE="vitruv-tools.github.io/updatesite/nightly"
VITRUV_RELEASE_SITE="vitruv-tools.github.io/updatesite/release"

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

set -e
cd $DIR
git branch -D "$RELEASE_VERSION_BRANCH" 2> /dev/null || true
git branch -D "$DEV_VERSION_BRANCH" 2> /dev/null || true

if [ $(git status -s | wc -l) -ne 0 ]; then
	echo "You have to have a clean working copy."
	exit 2
fi

BRANCH=$(git rev-parse --abbrev-ref HEAD)

echo "Operating on branch: $BRANCH"
echo "Release version:     $RELEASE_VERSION"
echo "Development version: $DEV_VERSION"

# Upgrade to new development version and commit it in branch
git checkout -b "$DEV_VERSION_BRANCH"
set -x
sh $SCRIPT_DIR/change_version.sh $DIR $RELEASE_VERSION $DEV_VERSION false
git commit -am "[Release Process] Set development version to $DEV_VERSION"
# Disable failing on error to be able to reset directory afterwards
set +x
set +e
mvn clean verify
MVN_RESULT=$?
if [[ "$MVN_RESULT" -ne 0 ]] ; then
  echo "Could not successfully perform build for development version"
  git checkout master
  git branch -D "$DEV_VERSION_BRANCH"
  exit $MVN_RESULT
fi
set -e
DEV_VERSION_COMMIT=$(git rev-parse HEAD)

# Upgrade to release version, exchange nightly dependencies with release dependencies and commit it in branch
git checkout $BRANCH
git checkout -b "$RELEASE_VERSION_BRANCH"
set -x
sh $SCRIPT_DIR/change_version.sh $DIR $RELEASE_VERSION $RELEASE_VERSION true
git grep -l $VITRUV_NIGHTLY_SITE | xargs -r sed -i "" "s|$VITRUV_NIGHTLY_SITE/framework|$VITRUV_RELEASE_SITE/framework|g"
git grep -l $VITRUV_NIGHTLY_SITE | xargs -r sed -i "" "s|$VITRUV_NIGHTLY_SITE/domains|$VITRUV_RELEASE_SITE/domains|g"
# We should only use KIT-SDQ releases, if not, enable the subsequent line
# git grep -l $SDQ_NIGHTLY_SITE | xargs -r sed -i "" "s|$SDQ_NIGHTLY_SITE|$SDQ_RELEASE_SITE|g"
git commit -am "[Release Process] Set release version to $RELEASE_VERSION"
# Disable failing on error to be able to reset directory afterwards
set +x
set +e
mvn clean verify
MVN_RESULT=$?
if [[ "$MVN_RESULT" -ne 0 ]] ; then
  echo "Could not successfully perform build for release version"
  git checkout master
  git branch -D "$DEV_VERSION_BRANCH"
  git branch -D "$RELEASE_VERSION_BRANCH"
  exit $MVN_RESULT
fi
set -e

# Merge release in master, add release tag and pick development version on top (no merge, as it produces another merge commit due to concurrent version modifications in both branches)
git checkout $BRANCH
set -x
git merge "$RELEASE_VERSION_BRANCH"
git branch -D "$RELEASE_VERSION_BRANCH"
git tag "releases/$RELEASE_VERSION"
git cherry-pick --strategy=recursive -X theirs $DEV_VERSION_COMMIT
git branch -D "$DEV_VERSION_BRANCH"
git clean -f
# Reset release dependencies to nightly dependencies
git grep -l $VITRUV_RELEASE_SITE | xargs -r sed -i "" "s|$VITRUV_RELEASE_SITE/framework|$VITRUV_NIGHTLY_SITE/framework|g"
git grep -l $VITRUV_RELEASE_SITE | xargs -r sed -i "" "s|$VITRUV_RELEASE_SITE/domains|$VITRUV_NIGHTLY_SITE/domains|g"
# We should only use KIT-SDQ releases, if not, enable the subsequent line
# git grep -l $SDQ_RELEASE_SITE | xargs -r sed -i "" "s|$SDQ_RELEASE_SITE|$SDQ_NIGHTLY_SITE|g"
git commit -a --amend --no-edit
set +x

echo "Changes have not been pushed or deployed yet but only have been verified.
In order to push the two commits and the release tag, invoking a release deployment for the tag by Travis, do:
  * git push
  * git push --tags"
