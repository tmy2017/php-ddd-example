echo "!!!MUST have .tmy-xyz files in current directory, if not then this command is not useful!!!"
EPOCH_TIME=`date +%s`
# get latest (there is a gotcha! see below) image
#   NOTE: latest tag is dangerous, can easily overwrite local latest! https://github.com/moby/moby/issues/10291
docker pull tmy2017/gitpod-pm
# use this zzdocker zzrun zzMinus-zzDash-zzd to zzdetach so zzLater you can still zzdocker zzexec zzMinus-zzDash-zzit to zzDebug and zzobserve!
docker run -d -it --name temp-for-image-commit-${EPOCH_TIME} tmy2017/gitpod-pm bash
docker cp .tmy-persist-ide-settings-through-image-for-gitpod.sh  temp-for-image-commit-${EPOCH_TIME}:/usr/local/bin/tmy-persist-ide-settings-through-image-for-gitpod
docker cp .tmy-persist-custom-commands-through-image.sh  temp-for-image-commit-${EPOCH_TIME}:/usr/local/bin/tmy-persist-custom-commands-through-image
# also update the pstorm launch command for disabling ORG_JETBRAINS_PROJECTOR_SERVER_AUTO_KEYMAP
#   see https://youtrack.jetbrains.com/issue/PRJ-121#focus=Comments-27-5198388.0-0 and
#   https://jetbrains.github.io/projector-client/mkdocs/latest/ij_user_guide/server_customization/#list-of-parameters  
docker cp .tmy-pstorm-launch-GITPOD_REPO_ROOT.sh ${EPOCH_TIME}:/usr/local/bin/tmy-pstorm-launch-GITPOD_REPO_ROOT
docker commit temp-for-image-commit-${EPOCH_TIME} tmy2017/gitpod-pm
docker tag tmy2017/gitpod-pm tmy2017/gitpod-pm:ver-${EPOCH_TIME}
docker push tmy2017/gitpod-pm:ver-${EPOCH_TIME}
# also remember to update the latest! so that next time when docker pull latest really meaning latest
#   TODO: but better have a "moving-tag" instead of default "latest", since it is dangerous and confusing...
#   https://vsupalov.com/docker-latest-tag/, https://www.cloudsavvyit.com/10691/understanding-dockers-latest-tag/
docker push tmy2017/gitpod-pm:latest
echo "success - the newest image name with tag is: tmy2017/gitpod-pm:ver-${EPOCH_TIME}"
echo "please remember to update .gitpod.yml image name to ensure it has latest image"