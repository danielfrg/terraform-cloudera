#!/bin/bash

set -e
set -x

sudo curl -o /opt/cloudera/csd/SPARK2_ON_YARN-2.1.0.cloudera2.jar https://archive.cloudera.com/spark2/csd/SPARK2_ON_YARN-2.1.0.cloudera2.jar
sudo chown cloudera-scm:cloudera-scm /opt/cloudera/csd/SPARK2_ON_YARN-2.1.0.cloudera2.jar
