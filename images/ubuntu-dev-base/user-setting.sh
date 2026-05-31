#!/bin/bash

USER=${USER:-"yoshwata"}
USER_ID=${UID:-1000}
GROUP=${GROUP:-"yoshwata"}
GROUP_ID=${GID:-1000}

echo "Starting with USER : $USER"
echo "Starting with UID : $USER_ID"
echo "Starting with GROUP : $GROUP"
echo "Starting with GID : $GROUP_ID"

# Avoid duplicate identity entries (e.g. ubuntu and yoshwata sharing uid=1000).
existing_user_with_uid=$(awk -F: -v uid="$USER_ID" '$3==uid {print $1; exit}' /etc/passwd)
if [ -n "$existing_user_with_uid" ] && [ "$existing_user_with_uid" != "$USER" ]; then
	echo "Removing conflicting user $existing_user_with_uid with uid $USER_ID"
	sudo userdel -r "$existing_user_with_uid" 2>/dev/null || sudo userdel "$existing_user_with_uid" || true
fi

existing_group_with_gid=$(awk -F: -v gid="$GROUP_ID" '$3==gid {print $1; exit}' /etc/group)
if [ -n "$existing_group_with_gid" ] && [ "$existing_group_with_gid" != "$GROUP" ]; then
	echo "Removing conflicting group $existing_group_with_gid with gid $GROUP_ID"
	sudo groupdel "$existing_group_with_gid" || true
fi

sudo groupmod -g "$GROUP_ID" "$GROUP"
sudo usermod -u "$USER_ID" -g "$GROUP_ID" "$USER"

