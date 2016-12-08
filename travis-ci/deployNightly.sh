# Deploys the project update site to the Vitruv update site repository
# Parameters:
# $1: The name of the update site (gets aggregated to the aggregate Vitruv site)
# $2: The path to the update site project in this repository (e.g. releng/tools.vitruv.updatesite)
# $3: The name of the folder into which the update site was generated (e.g. repository or final)

echo "Build $TRAVIS_JOB_NUMBER"
echo "Git: $TRAVIS_COMMIT [$TRAVIS_BRANCH]"
if [ $TRAVIS_PULL_REQUEST == 'false' ]
then
    echo "Promoting an untagged build on vitruv-tools.github.io/p2/nightly"
    cd $2/target
    git clone https://$GITHUB_DEPLOY_TOKEN@github.com/vitruv-tools/p2.git -b gh-pages --quiet
    if [ -d p2/nightly/$1 ]
    then
        rm -r p2/nightly/$1
        echo "An old version of the nightly repository has been found and removed"
    fi
    echo "Creating the nighly repository"
    cp -r $3 p2/nightly/
	ls p2/nightly
    mv p2/nightly/$3 p2/nightly/$1
    echo "Nightly repository created"
    ls p2/nightly/$1
    cd p2/nightly
    git config user.email "vitruv.tools@gmail.com"
    git config user.name "Vitruv Tools"
    git add -A
    git commit -m "Promoting a new nightly build"
    git push origin gh-pages
    echo "Build promoted"
fi