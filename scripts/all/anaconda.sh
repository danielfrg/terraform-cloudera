#!/bin/bash

set -e
set -x

sudo mkdir /opt/anaconda
sudo chmod 777 /opt/anaconda

# curl -O https://repo.anaconda.com/miniconda/Miniconda2-4.3.31-Linux-x86_64.sh
# bash Miniconda*.sh -b -p /opt//anaconda/miniconda2
curl -O https://repo.anaconda.com/archive/Anaconda2-5.1.0-Linux-x86_64.sh
bash Anaconda*.sh -b -p /opt/anaconda/anaconda2

echo ". /opt/anaconda/anaconda2/etc/profile.d/conda.sh" >> ~/.bashrc
echo "conda activate base" >> ~/.bashrc

/opt/anaconda/anaconda2/bin/conda install -y -n base sparkmagic

#######################################
## This will be as the centos user
#######################################

mkdir -p ~/.sparkmagic/

# TODO use Livy server ip
cat >~/.sparkmagic/config.json <<EOL
{
  "kernel_python_credentials" : {
    "username": "",
    "password": "",
    "url": "http://localhost:8998",
    "auth": "None"
  },

  "kernel_scala_credentials" : {
    "username": "",
    "password": "",
    "url": "http://localhost:8998",
    "auth": "None"
  },
  "kernel_r_credentials": {
    "username": "",
    "password": "",
    "url": "http://localhost:8998"
  },

  "logging_config": {
    "version": 1,
    "formatters": {
      "magicsFormatter": { 
        "format": "%(asctime)s\t%(levelname)s\t%(message)s",
        "datefmt": ""
      }
    },
    "handlers": {
      "magicsHandler": { 
        "class": "hdijupyterutils.filehandler.MagicsFileHandler",
        "formatter": "magicsFormatter",
        "home_path": "~/.sparkmagic"
      }
    },
    "loggers": {
      "magicsLogger": { 
        "handlers": ["magicsHandler"],
        "level": "DEBUG",
        "propagate": 0
      }
    }
  },

  "wait_for_idle_timeout_seconds": 15,
  "livy_session_startup_timeout_seconds": 60,

  "fatal_error_suggestion": "The code failed because of a fatal error:\n\t{}.\n\nSome things to try:\na) Make sure Spark has enough available resources for Jupyter to create a Spark context.\nb) Contact your Jupyter administrator to make sure the Spark magics library is configured correctly.\nc) Restart the kernel.",

  "ignore_ssl_errors": false,

  "session_configs": {
    "driverMemory": "1000M",
    "executorCores": 2
  },

  "use_auto_viz": true,
  "coerce_dataframe": true,
  "max_results_sql": 2500,
  "pyspark_dataframe_encoding": "utf-8",
  
  "heartbeat_refresh_seconds": 30,
  "livy_server_heartbeat_timeout_seconds": 0,
  "heartbeat_retry_seconds": 10,

  "server_extension_default_kernel_name": "pysparkkernel",
  "custom_headers": {},
  
  "retry_policy": "configurable",
  "retry_seconds_to_sleep_list": [0.2, 0.5, 1, 3, 5],
  "configurable_retry_policy_max_retries": 8
}
EOL
