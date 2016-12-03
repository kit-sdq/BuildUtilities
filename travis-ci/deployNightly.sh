echo "Build $TRAVIS_JOB_NUMBER"
echo "Git: $TRAVIS_COMMIT [$TRAVIS_BRANCH]"
if [ $TRAVIS_PULL_REQUEST == 'false' ]
then
    echo "Promoting an untagged build on vitruv-tools.github.io/p2/nightly"
    cd releng/tools.vitruv.updatesite/target
    git clone https://$GITHUB_DEPLOY_TOKEN@github.com/vitruv-tools/p2.git -b gh-pages --quiet
    if [ -d p2/nightly/framework ]
    then
        rm -r p2/nightly/framework
        echo "An old version of the nightly repository has been found and removed"
    fi
    echo "Creating the nighly repository"
    cp -r repository p2/nightly/
	ls p2/nightly
    mv p2/nightly/repository p2/nightly/framework
    echo "Nightly repository created"
    ls p2/nightly/framework
    cd p2/nightly
    git config user.email "vitruv.tools@gmail.com"
    git config user.name "Vitruv Tools"
    git remote rm origin
    git remote add origin https://$GITHUB_DEPLOY_TOKEN@github.com/vitruv-tools/p2.git
    git add -A
    git commit -m "Promoting a new nightly build for https://github.com/vitruv-tools/Vitruv/commit/$TRAVIS_COMMIT [$TRAVIS_BRANCH]"
    git push origin gh-pages
    echo "Build promoted."
fi