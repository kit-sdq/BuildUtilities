#!/bin/bash
# $1: name of the GitHub organization to deploy to
# $2: name of the updatesite project on GitHub
# $3: release version to deploy or none if nightly deployment

GITHUB_ORGANIZATION="$1"
UPDATESITE_PROJECT="$2"
EXPLICIT_RELEASE_VERSION=${3:-""}

mvn clean verify
export TRAVIS_PULL_REQUEST=false
export TRAVIS_BRANCH=master
export GITHUB_DEPLOY_TOKEN=git
../../travis-ci/deploy.sh p2-wrapper/jamopp-p2 . final $GITHUB_ORGANIZATION $UPDATESITE_PROJECT $EXPLICIT_RELEASE_VERSION