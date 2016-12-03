echo "Build $TRAVIS_JOB_NUMBER"
echo "Git: $TRAVIS_COMMIT [$TRAVIS_BRANCH]"
if [ $TRAVIS_PULL_REQUEST == 'false' ]
then
    echo "Promoting an untagged build on dartdesigner.github.io/p2/nightly"
    cd releng/tools.vitruv.updatesite/target
    git clone https://$GITHUB_TOKEN@github.com/vitruv-tools/p2.git -b gh-pages --quiet
    if [ -d p2/nightly ]
    then
        rm -r p2/nightly
        echo "An old version of the nightly repository has been found and removed"
    fi
    echo "Creating the nighly repository"
    cp -r repository p2/
    mv p2/repository p2/nightly
    echo "Nightly repository created"
    ls p2/nightly
    cd p2
    git config user.email "vitruv.tools@gmail.com"
    git config user.name "Vitruv Tools"
#   git remote rm origin
#   git remote add origin https://dartdesigner:$GITHUB_TOKEN@github.com/dartdesigner/p2.git
    git add -A
    git commit -m "Promoting a new nightly build for https://github.com/vitruv-tools/Vitruv/commit/$TRAVIS_COMMIT [$TRAVIS_BRANCH]"
    git push origin gh-pages --quiet &>/dev/null
    echo "Build promoted."
fi