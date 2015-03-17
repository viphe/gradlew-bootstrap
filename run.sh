#!/usr/bin/env bash

set -e

function print_error {
    >&2 echo $*
}

function fetch_version {
    echo $gradle_version_ref | grep [0-9]
    if [ echo $gradle_version_ref | grep [0-9] ]; then
        gradle_version=$gradle_version_ref
        gradle_download_url="https://services.gradle.org/distributions-snapshots/gradle-${gradle_version}-bin.zip"
    else
        gradle_version_info=`curl -sSL "http://services.gradle.org/versions/$gradle_version_ref"`
        gradle_version=`echo $gradle_version_info | sed -e "s/.*\"version\" *: *\"\([^\"]*\)\".*/\1/"`
        gradle_download_url=`echo $gradle_version_info | sed -e "s/.*\"downloadUrl\" *: *\"\([^\"]*\)\".*/\1/" | sed -e 's/\\\\//g'`
    fi


    if [ "$gradle_version" == "" ]; then
        print_error "unknown gradle reference or version: $gradle_version_ref" 
        return 1
    fi

    if [ "$gradle_download_url" == "" ]; then
        print_error "gradle $gradle_version_ref => $gradle_version cannot be downloaded" 
        return 1
    fi
}

function get_and_unpack {
    echo "downloading gradle ($gradle_version_ref => $gradle_version) from $gradle_download_url"
    curl -L $gradle_download_url -o gradle.zip
    unzip -q gradle.zip
    unpack_dir=gradle-$gradle_version 
}

function create_wrapper {
    echo "creating gradle wrapper"
    $unpack_dir/bin/gradle wrapper
}

function clean_tmp_files {
    rm -rf $unpack_dir
}

if [ $# == 0 ]; then
    gradle_version_ref=current
else
    gradle_version_ref=$1
    shift
fi

fetch_version || exit $?
get_and_unpack
create_wrapper
clean_tmp_files
