#!/bin/bash

set -eu

PROGNAME="$0"
my_dir="$(dirname $(readlink -f $0))"
if echo "$my_dir" | grep -E '/holoocean_tools(/.*)?' >/dev/null 2>&1
then
    HOLOOCEAN_DIR="$(echo "$my_dir" | sed -E 's#/holoocean_tools(/.*)?$##')"
else
    echo "Unable to detect HoloOcean base folder: $my_dir"
    exit 1
fi

SKIP_TOOLS=false
GET_UNREAL=false
GET_HOLOOCEAN=false
SWITCH_BRANCH=false
RESET_BRANCH=false
BASE_URL="https://github.com/migeran"

function help() {
    echo "Usage: $PROGNAME [--switch-branch] [--reset] [--skip-tools] [--base-url <url>] [--dev-build]"
}

# checkout <url> <local_path> <branch>
function checkout() {
    url="$1"
    local_path="$2"
    branch="$3"
    checkout_path="$HOLOOCEAN_DIR/$local_path"
    if [ ! -d "$checkout_path" ]
    then
        mkdir -p "$checkout_path"
    fi
    cd "$checkout_path"
    if [ ! -d .git ]
    then
        echo "Cloning $url:$branch -> $checkout_path"

        git clone "$url" -b "$branch" .
    else
        echo "Updating $checkout_path"
        git fetch
        if [ "$RESET_BRANCH" = "true" ]
        then
            echo "    Resetting current branch"
            git reset --hard
        fi
        if [ "$SWITCH_BRANCH" = "true" ]
        then
            echo "    Switching to branch $branch"
            git checkout $branch
        fi
        git pull
    fi
    if [ -f .gitmodules ]
    then
        echo "Updating submodules at $checkout_path"
        git submodule update --init --recursive
    fi
}

while [ "${1:-}" != "" ]
do
    case "$1" in
        --base-url)
            shift
            BASE_URL="$1"
            ;;
        --skip-tools)
            SKIP_TOOLS=true
            ;;
        --switch-branch)
            SWITCH_BRANCH=true
            ;;
        --reset)
            RESET_BRANCH=true
            ;;
        --dev-build)
            GET_UNREAL=true
            GET_HOLOOCEAN=true
            ;;
        *)
            help
            exit 1
    esac
    shift
done

if ! $SKIP_TOOLS
then
    checkout $BASE_URL/holoocean_tools.git holoocean_tools main
fi
checkout $BASE_URL/holoocean_ros.git holoocean_ros main

if $GET_UNREAL
then
    checkout git@github.com:EpicGames/UnrealEngine.git UnrealEngine 4.27
fi
if $GET_HOLOOCEAN
then
    checkout https://bitbucket.org/frostlab/holoocean.git holoocean develop
fi
