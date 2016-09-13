#!/bin/bash

script_dir="`cd $(dirname $0); pwd`"
docker build -t insighttoolkit/pydata-carolinas-2016 $script_dir
