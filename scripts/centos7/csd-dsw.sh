#!/bin/bash

set -e
set -x

sudo curl -o /opt/cloudera/csd/CLOUDERA_DATA_SCIENCE_WORKBENCH-1.3.0.jar https://archive.cloudera.com/cdsw/1/csd/CLOUDERA_DATA_SCIENCE_WORKBENCH-1.3.0.jar
sudo chown cloudera-scm:cloudera-scm /opt/cloudera/csd/CLOUDERA_DATA_SCIENCE_WORKBENCH-1.3.0.jar
