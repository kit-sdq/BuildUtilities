#!/bin/bash

mvn clean verify
export TRAVIS_PULL_REQUEST=false
export GITHUB_DEPLOY_TOKEN=git
../travis-ci/deployNightly.sh jamopp-p2 . final