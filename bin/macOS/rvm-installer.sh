#!/bin/sh

set -e

brew install gnupg

command curl -sSL https://rvm.io/mpapis.asc | gpg --import -

\curl -sSL https://get.rvm.io | bash -s stable --ruby
