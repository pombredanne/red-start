#!/bin/sh
BASEDIR=$(dirname $0)/../

if [ -n "$1" ]; then
    SERVER=$1
else
    SERVER='0.0.0.0:8000'
fi

source $BASEDIR/env/bin/activate
$BASEDIR/project/manage.py testserver --noinput --traceback --addrport $SERVER development #Add additional fixtures here
