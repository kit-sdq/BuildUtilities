# Deploys the project update site to the Vitruv update site repository
# Parameters:
# $1: The name of the (sub) update site
# $2: The path to the update site project in this repository (e.g. releng/edu.kit.ipd.sdq.commons.updatesite)
# $3: The name of the folder into which the update site was generated (e.g. repository or final)
# $4: The name of the GitHub organization (e.g. kit-sdq)
# $5: The name of the update site project on GitHub

SUB_UPDATESITE_NAME="$1"
GENERATED_UPDATESITE_PATH="$2"
GENERATED_UPDATESITE_FOLDER="$3"
GITHUB_ORGANIZATION_NAME="$4"
UPDATESITE_PROJECT="$5"
VERSION_SUFFIX=""
EXPLICIT_DEPLOY_RELEASE_VERSION=${6:-false}

GITHUB_PROJECT_PATH="@github.com/$GITHUB_ORGANIZATION_NAME/$UPDATESITE_PROJECT.git"
GITHUB_PAGES_PATH="$GITHUB_ORGANIZATION_NAME.github.io/$UPDATESITE_PROJECT/"
DEPLOYMENT_FOLDER="nightly"
echo "Build $TRAVIS_JOB_NUMBER"
echo "Git: $TRAVIS_COMMIT [$TRAVIS_BRANCH]"

if [ $TRAVIS_PULL_REQUEST != 'false' ]
then
	echo "Not deploying commit because it is a pull request"
	exit
fi

CURRENT_TAG=$(git name-rev --name-only --tags HEAD)
if [ $CURRENT_TAG == 'undefined' ]
then
	if [ $TRAVIS_BRANCH != 'master' ]
	then
		echo "Not deploying other branches than master"
		exit
	fi
	echo "Promoting an untagged build on $GITHUB_PAGES_PATH$DEPLOYMENT_FOLDER"
elif [[ $CURRENT_TAG == releases/* ]]; then
	LAST_TAG=$(git describe --abbrev=0 --tags)
	DEPLOYMENT_FOLDER="release"
	VERSION_SUFFIX="/${LAST_TAG:9}" # Extracts the version from "releases/VERSION" tag
	echo "Promoting the release $LAST_TAG on $GITHUB_PAGES_PATH$DEPLOYMENT_FOLDER"
fi

if [ $EXPLICIT_DEPLOY_RELEASE_VERSION != "false" ]; then
	DEPLOYMENT_FOLDER="release"
	VERSION_SUFFIX="/$EXPLICIT_DEPLOY_RELEASE_VERSION"
	echo "Promoting the release $EXPLICIT_DEPLOY_RELEASE_VERSION on $GITHUB_PAGES_PATH$DEPLOYMENT_FOLDER"
fi

cd $2/target
if [ -d $UPDATESITE_PROJECT ]
then
	rm -r $UPDATESITE_PROJECT
fi
if [ -d $SUB_UPDATESITE_NAME ]
then
	rm -r $SUB_UPDATESITE_NAME
fi
mkdir -p $SUB_UPDATESITE_NAME
mv $GENERATED_UPDATESITE_FOLDER/* $SUB_UPDATESITE_NAME$VERSION_SUFFIX
git clone https://$GITHUB_DEPLOY_TOKEN$GITHUB_PROJECT_PATH --quiet
if [ -d $UPDATESITE_PROJECT/$DEPLOYMENT_FOLDER/$SUB_UPDATESITE_NAME$VERSION_SUFFIX ]
then
	rm -r $UPDATESITE_PROJECT/$DEPLOYMENT_FOLDER/$SUB_UPDATESITE_NAME$VERSION_SUFFIX
	echo "An old version of the repository has been found and removed"
fi
echo "Creating the repository"
mkdir -p $UPDATESITE_PROJECT/$DEPLOYMENT_FOLDER
cp -r $SUB_UPDATESITE_NAME $UPDATESITE_PROJECT/$DEPLOYMENT_FOLDER/
echo "Repository created"
cd $UPDATESITE_PROJECT/$DEPLOYMENT_FOLDER
git config user.email "travis-ci"
git config user.name "Travis-CI"
git add -A
git commit -m "Promoting a new $DEPLOYMENT_FOLDER build for $SUB_UPDATESITE_NAME"
git push origin master
echo "Build promoted"

