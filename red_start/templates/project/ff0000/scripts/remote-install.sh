#!/bin/sh
set -e

BASEDIR=$(dirname $0)

usage() {
    echo "remote-install.sh [--hook or --hook=] [--type or --type=] remote-name user@host-or-ip"
    exit $1
}

hook="$BASEDIR/../deploy/git/post-receive"
remote_script="$BASEDIR/remote-install-functions.sh"
type="app"
while :
do
    case $1 in
        -h | --help | -\?)
            usage 0
            ;;
        --hook)
            hook=$2
            shift 2
            ;;
        --hook=*)
            hook=${1#*=}
            shift
            ;;
        --type)
            type=$2
            shift 2
            ;;
        --type=*)
            type=${1#*=}
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

if [ $# -ne 2 ]; then
    usage 1
fi

repo_name=$1
host=$2
case $type in
    "app")
        pre_args="app_server_install"
        post_args="app_server_post_push_install"
        ;;
    "lb")
        pre_args="lb_server_install"
        post_args="lb_server_start"
        ;;
    *)
        echo "Invalid type $type"
        exit 1
        ;;
esac

ssh $host 'cat | sh /dev/stdin' "$pre_args" < $remote_script
chmod +x $hook
scp -p $hook "$host:~/project-git/hooks/post-receive"
git remote add $repo_name "ssh://$host/~/project-git"
git push $repo_name master
ssh $host 'cat | sh /dev/stdin' "$post_args" < $remote_script
