#!/bin/sh
EPOCH_TIME=`date +%s`
docker run --name temp-for-image-commit-${EPOCH_TIME} tmy2017/gitpod-pm /bin/sh -c "mkdir -p .local/share/JetBrains"
# NOTE: docker cp has no glob pattern! https://github.com/moby/moby/issues/7710
# NOTICE: copy files and directories inherently looks different - directories is whole folder
#	hence second parameter looks asymmetric
#	can also use /. in the second parameter, but feel very specific to docker hence not using
#	Official info https://docs.docker.com/engine/reference/commandline/cp/#extended-description
# NOTICE2: also seems not able to use tilde - must use absolute path to refer home path
docker cp /home/gitpod/.projector/ temp-for-image-commit-${EPOCH_TIME}:/home/gitpod/
docker cp /home/gitpod/.config/JetBrains/ temp-for-image-commit-${EPOCH_TIME}:/home/gitpod/.config/
docker cp /home/gitpod/.local/share/JetBrains/ temp-for-image-commit-${EPOCH_TIME}:/home/gitpod/.local/share/
docker commit temp-for-image-commit-${EPOCH_TIME} tmy2017/gitpod-pm
docker tag tmy2017/gitpod-pm tmy2017/gitpod-pm:ver-${EPOCH_TIME}
docker login
docker push tmy2017/gitpod-pm:ver-${EPOCH_TIME}
echo "success - the newest image name with tag is: tmy2017/gitpod-pm:ver-${EPOCH_TIME}"