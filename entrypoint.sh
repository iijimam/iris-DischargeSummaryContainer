#!/bin/bash

set -m

/iris-main "$@" &

/usr/irissys/dev/Cloud/ICM/waitISC.sh

cd /opt/try/Flask

${PYTHON_PATH} -m gunicorn --bind "0.0.0.0:5000" app:app &

fg %1