#!/bin/sh
EPOCH_TIME=`date +%s`
# get latest (there is a gotcha! see below) image
#   NOTE: latest tag is dangerous, can easily overwrite local latest! https://github.com/moby/moby/issues/10291
docker pull tmy2017/gitpod-pstorm-with-php71-mysql8

# keep container running for updating files, then later commit 
#   NOTE: even in detach mode -it is MUST for shell
docker run -d -it --name temp-for-image-commit-${EPOCH_TIME} tmy2017/gitpod-pstorm-with-php71-mysql8 bash

# prepare folders in case it does not exist
docker exec temp-for-image-commit-${EPOCH_TIME} /bin/sh -c "mkdir -p .local/share/JetBrains"

# NOTE: docker cp has no glob pattern! https://github.com/moby/moby/issues/7710
# NOTICE: 
# 1) copy files and directories inherently looks different - directories is whole folder
#	hence second parameter looks asymmetric
#	can also use /. in the second parameter, but feel very specific to docker hence not using
#	Official info https://docs.docker.com/engine/reference/commandline/cp/#extended-description
# 2) also seems not able to use tilde - must use absolute path to refer home path
docker cp /home/gitpod/.projector/ temp-for-image-commit-${EPOCH_TIME}:/home/gitpod/
docker cp /home/gitpod/.config/JetBrains/ temp-for-image-commit-${EPOCH_TIME}:/home/gitpod/.config/
docker cp /home/gitpod/.local/share/JetBrains/ temp-for-image-commit-${EPOCH_TIME}:/home/gitpod/.local/share/
# 3) !!! nasty-bug! MUST delete the mysqld.pid BEFORE docker commit, so mysqld next time when docker run will auto start again
docker exec temp-for-image-commit-${EPOCH_TIME} /bin/sh -c "rm -rf /var/run/mysqld/mysqld.pid"
### License related - START
# Now trial expires, start to provide real license, but still need to persist IDE settings hence need the following

# do NOT persist .java since after trial expires and real license provided, this could contain license info
#   so to skip the license agreement
#   docker cp /home/gitpod/.java temp-for-image-commit-${EPOCH_TIME}:/home/gitpod/.java

# delete license related info in .config folder
#   use -f to skip error
docker exec temp-for-image-commit-${EPOCH_TIME} /bin/sh -c "rm -f /home/gitpod/.config/JetBrains/PhpStorm2021.3/phpstorm.key"
docker exec temp-for-image-commit-${EPOCH_TIME} /bin/sh -c "rm -f /home/gitpod/.config/JetBrains/PhpStorm2021.3/plugin_PCWMP.license"
# remove past trial license left .java/.userPrefs data - if any
docker exec temp-for-image-commit-${EPOCH_TIME} /bin/sh -c "rm -rf /home/gitpod/.java/.userPrefs/jetbrains/"

### License related - END

### Push to repo -START
docker login

# Remember to update the latest! so that next time when docker pull latest really meaning latest
#   TODO: but better have a "moving-tag" instead of default "latest", since it is dangerous and confusing...
#   https://vsupalov.com/docker-latest-tag/, https://www.cloudsavvyit.com/10691/understanding-dockers-latest-tag/
docker commit temp-for-image-commit-${EPOCH_TIME} tmy2017/gitpod-pstorm-with-php71-mysql8
docker push tmy2017/gitpod-pstorm-with-php71-mysql8:latest

# Use specific tag so to avoid gitpod caching docker registry image
docker tag tmy2017/gitpod-pstorm-with-php71-mysql8 tmy2017/gitpod-pstorm-with-php71-mysql8:ver-${EPOCH_TIME}
docker push tmy2017/gitpod-pstorm-with-php71-mysql8:ver-${EPOCH_TIME}
### Push to repo - END

echo "success - the newest image name with tag is: tmy2017/gitpod-pstorm-with-php71-mysql8:ver-${EPOCH_TIME}"
echo "please remember to update .gitpod.yml image name to ensure it has latest image"
