#!/bin/bash

set -e
set -x

sudo yum install -y unzip
curl -O http://mirrors.advancedhosters.com/apache/incubator/livy/0.5.0-incubating/livy-0.5.0-incubating-bin.zip
unzip livy-0.5.0-incubating-bin.zip
