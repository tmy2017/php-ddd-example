#!/bin/sh
# phpstorm bookmark sync v0.2 zz-_23-_y22-0610-0004
# for phpstorm bookmark on gitpod - to be appended in the .bashrc by gitpod workspace custom images like tmy2017/gitpod-pstorm-with-php71-mysql8
# NOTICE: not to have double tabs! it will break terminal - seems to trigger auto complete - strange

# ONLY 1 TIME - after workspace start/restart, sync back to phpstorm
if [ ! -e /var/run/tmy-phpstorm-bookmark-sync.pid ]
then
        sudo touch /var/run/tmy-phpstorm-bookmark-sync.pid 2>/dev/null;
        cp -rf ${GITPOD_REPO_ROOT}/.gitpod/phpstormConfigWorkspaceForBookmarks/. /home/gitpod/.config/JetBrains/PhpStorm2021.3/workspace/ 2>/dev/null;
fi


# Main - copy out of phpstorm into workspace to persist phpstorm data
# should not need to worry multiple while - once terminal is exited, then the background process is gone as well zz-_23-_y22-0609-2328

# assume folder not created, for syncing back to have a folder.
#       Even if it did, it does not harm anything
mkdir -p ${GITPOD_REPO_ROOT}/.gitpod/phpstormConfigWorkspaceForBookmarks/

while :
do
        cp -rf /home/gitpod/.config/JetBrains/PhpStorm2021.3/workspace/. ${GITPOD_REPO_ROOT}/.gitpod/phpstormConfigWorkspaceForBookmarks/ 2>/dev/null;
        sleep 1;
done &