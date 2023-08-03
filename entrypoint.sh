#!/bin/bash

uidchange=""
gidchange=""

orig_username="holoocean"
orig_groupname="holoocean"
username="$orig_username"
groupname="$orig_groupname"
home_dir="/home/$orig_username"

userchange=""
groupchange=""

if [ "${HOST_USER_ID:-}" != "" ]
then
    echo "UID changed to: $HOST_USER_ID";
    uidchange="-u ${HOST_USER_ID}"
fi

if [ "${HOST_USER_NAME:-}" != "" ]
then
    echo "User name changed to: $HOST_USER_NAME"
    userchange="-l $HOST_USER_NAME" 
    if [ "${KEEP_HOME_DIR:-}" != "true" ]
    then
        home_dir="/home/$HOST_USER_NAME"
        userchange="$userchange -d $home_dir --move-home"
    fi
    username="$HOST_USER_NAME"
fi

if [ "${HOST_GROUP_ID:-}" != "" ]
then
    echo "GID changed to: $HOST_GROUP_ID"
    gidchange="-g ${HOST_GROUP_ID}"
fi

if [ "${HOST_GROUP_NAME:-}" != "" ]
then
    echo "Group name changed to: $HOST_GROUP_NAME"
    groupchange="--new-name $HOST_GROUP_NAME"
    groupname="$HOST_GROUP_NAME"
fi

if [ "$gidchange" != "" ] || [ "$groupchange" != "" ]
then
    groupmod $gidchange $groupchange $orig_groupname
fi

if [ "$uidchange" != "" ] || [ "$gidchange" != "" ] || [ "$userchange" != "" ]; then
    usermod $uidchange $gidchange $userchange $orig_username
    chown -R $username:$groupname $home_dir
fi

if [ "$orig_username" != "$username" ]
then
    sed -i "s/$orig_username/$username/g" /etc/sudoers >/dev/null 2>&1
fi

if [ "${TZ:-}" != "" ]
then
    echo "${TZ}" > /etc/timezone
fi

if [ "${ADD_TO_HOSTS:-}" != "" ]
then
    echo "${ADD_TO_HOSTS}" > /etc/hosts
fi

exec sudo -E -H -u $username $@
