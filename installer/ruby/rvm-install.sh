#!/bin/sh
set -e

if test -x "$(command -v rvm)"; then
    echo "[Info] rvm already exists."
    exit
fi

case "$(uname -s)" in
    Darwin)
        if ! test -x "$(command -v gpg)"; then
            brew install gnupg
        fi
        command curl -sSL https://rvm.io/mpapis.asc | gpg --import -
        \curl -sSL https://get.rvm.io | bash -s stable --ruby
        ;;
    Linux)
        if ! test -x "$(command -v gpg2)"; then
            if test -x "$(command -v apt-get)"; then
                sudo apt-get update
                sudo apt-get -y install gnupg2
            elif test -x "$(command -v yum)"; then
                echo "[Error] script is not finished."
                exit 1
            else
                echo "[Error] No package management tools found."
                exit 1
            fi
        fi
        gpg2 --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
        \curl -sSL https://get.rvm.io | bash -s stable
        ;;
    *)
        echo "Unsupported OS is found."
        exit 1
        ;;
esac
