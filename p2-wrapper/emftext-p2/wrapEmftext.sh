#!/bin/bash
# $1: name of the GitHub organization to deploy to
# $2: name of the updatesite project on GitHub

mvn clean verify
export TRAVIS_PULL_REQUEST=false
export TRAVIS_BRANCH=master
export GITHUB_DEPLOY_TOKEN=git
../../travis-ci/deploy.sh p2-wrapper/emftext-p2 . final "$1" "$2"