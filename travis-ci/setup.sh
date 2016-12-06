#!/bin/bash
# Sets up the build environment for Travis CI.
#
# Add this to your .travis.yml:
#
#	before_install:
#   - git clone --depth 1 https://github.com/vitruv-tools/BuildUtilities.git /tmp/BuildUtils
#	- . /tmp/BuildUtilities/travis-ci/setup.sh
#	install: true
#

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

. $DIR/installMaven.sh

export PATH=$DIR:$PATH
