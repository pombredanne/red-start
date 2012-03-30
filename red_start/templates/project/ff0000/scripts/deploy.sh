#!/bin/sh
set -e
#set -v #Uncomment to see each command as it is run

RSYNC=rsync
RAKE=rake
GIT=git

BASEDIR=$(dirname $0)

usage()
{
    echo "deploy.sh [-b --branch or --branch=] web1 web1 ..."
    exit $1
}

prep_static()
{
    $RAKE dev:compass
    $RAKE dev:uglify
    "$BASEDIR/../env/bin/python" "$BASEDIR/../project/manage.py" collectstatic --noinput
}

sync_server()
{
    server_address=`git remote -v | grep -P "$1\t" | awk -F/ '{print $3}' | head -n 1`;
    if [ -z $server_address ]; then
        echo "SERVER NOT UPDATED $1: No remote found"
    else
        if [ -z $3 ]; then
            $RSYNC -av --progress --delete "$BASEDIR/../collected-static/" $server_address:/srv/active/collected-static/
        fi
        $GIT push $1 $2
        echo "$1 was successfully updated with branch $2"
    fi
}

purge_cdn_cache()
{
    # Uncomment to clear edgecast static
    # "$BASEDIR/../env/bin/python" "$BASEDIR/../project/manage.py" purge-edgecast-cache
    echo ""
}

branch="master"
while :
do
    case $1 in
        -h | --help | -\?)
            usage 0
            ;;
        -s | --skip-static | -\?)
            skipstatic=1
            shift
            ;;
        -b | --branch)
            branch=$2
            shift 2
            ;;
         --branch=*)
            branch=${1#*=}
            shift
            ;;
        --) # End of all options
            shift
            break
            ;;
        -*)
            usage 1
            shift
            ;;
        *)  # no more options. Stop while loop
            break
            ;;
    esac
done

if [ -z "$@" ]; then
    usage 1
fi

if [ -z $skipstatic ]; then
    prep_static
fi

for var in "$@"
do
    sync_server $var $branch $skipstatic
done

if [ -z $skipstatic ]; then
    purge_cdn_cache
fi
