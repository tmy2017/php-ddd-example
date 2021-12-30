#!/bin/sh
EPOCH_TIME=`date +%s`
# NOTE: command to build the dockerfile as reference
#   docker build -f .gitpod.gitpod-pstorm-with-php71-mysql8.Dockerfile -t tmy2017/gitpod-pstorm-with-php71-mysql8 .
# TODO: make it dynamic by receiving command line argument
docker tag tmy2017/gitpod-pstorm-with-php71-mysql8 tmy2017/gitpod-pstorm-with-php71-mysql8:ver-${EPOCH_TIME}
docker push tmy2017/gitpod-pstorm-with-php71-mysql8:latest
docker push tmy2017/gitpod-pstorm-with-php71-mysql8:ver-${EPOCH_TIME}
