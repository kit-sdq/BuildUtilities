#!/bin/bash

mvn clean verify
export TRAVIS_PULL_REQUEST=false
export TRAVIS_BRANCH=master
export GITHUB_DEPLOY_TOKEN=git
../travis-ci/deploy.sh jamopp-p2 . final