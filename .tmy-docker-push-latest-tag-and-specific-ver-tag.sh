#!/bin/sh
EPOCH_TIME=`date +%s`

# TODO: make it dynamic by receiving command line argument
docker tag tmy2017/gitpod-php71-mysql8-pstorm tmy2017/gitpod-php71-mysql8-pstorm:ver-${EPOCH_TIME}
docker push tmy2017/gitpod-php71-mysql8-pstorm:ver-${EPOCH_TIME}
docker push tmy2017/gitpod-php71-mysql8-pstorm:latest
