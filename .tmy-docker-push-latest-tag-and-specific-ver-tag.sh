#!/bin/sh
EPOCH_TIME=`date +%s`
# NOTE: command to build the dockerfile as reference
#   docker build -f .gitpod.gitpod-php71-mysql8-pstorm.Dockerfile -t tmy2017/gitpod-php71-mysql8-pstorm .
# TODO: make it dynamic by receiving command line argument
docker tag tmy2017/gitpod-php71-mysql8-pstorm tmy2017/gitpod-php71-mysql8-pstorm:ver-${EPOCH_TIME}
docker push tmy2017/gitpod-php71-mysql8-pstorm:latest
docker push tmy2017/gitpod-php71-mysql8-pstorm:ver-${EPOCH_TIME}
