#!/bin/sh

docker run \
  --rm \
  -p 8888:8888 \
  -v $PWD:/home/jovyan/work/ \
  insighttoolkit/pydata-carolinas-2016
