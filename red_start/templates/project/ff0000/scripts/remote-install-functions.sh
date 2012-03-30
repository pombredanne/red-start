#!/bin/sh

set -e

secure_ssh() {
    # Change disable root and password
    # logins in /etc/ssh/sshd_config
    sudo sed -ie "s/^PermitRootLogin.*/PermitRootLogin no/g" /etc/ssh/sshd_config
    sudo sed -ie "s/^PasswordAuthentication.*/PasswordAuthentication no/g" /etc/ssh/sshd_config
    svcadm restart ssh
}

nginx_setup() {

    # Setup log rotation with logadm
    # Uncomment nginx
    sudo pkg_add nginx
    sudo sed -ie "s/^#nginx\(.*\)/nginx\1/g" /etc/logadm.conf
    sudo logadm

    sudo ln -sf /srv/active/deploy/nginx/nginx.conf /opt/local/etc/nginx/nginx.conf

    sudo mkdir -p /var/www/cache-tmp
    sudo mkdir -p /var/www/cache
    sudo chown -R www:www /var/www
}

git_init() {
    # New bare repo for project
    sudo pkg_add scmgit
    git init --bare project-git
}

path_setup() {
    sudo mkdir -p /srv/active
    sudo chown -R admin /srv
}

app_server_install() {
    secure_ssh
    nginx_setup

    # Packages
    sudo pkg_add python27
    sudo pkg_add py27-mysqldb
    sudo pkg_add py27-setuptools
    sudo easy_install-2.7 pip
    sudo pip install virtualenv

    #Setup files
    path_setup
    sudo mkdir -p /var/log/gunicorn
    sudo chown -R www:www /var/log/gunicorn

    # Add django
    sudo logadm -C 3 -p1d -c -w /var/log/gunicorn/django.log -z 1

    git_init
}

app_server_post_push_install()
{
    sh /srv/active/scripts/setup.sh production

    # Setup gunicorn
    svccfg import /srv/active/deploy/gunicorn/gunicorn.xml
    svcadm enable gunicorn
    svcadm enable nginx
}

lb_server_install()
{
    secure_ssh
    nginx_setup
    path_setup
    git_init
    GIT_CONFIG=~/project-git/config git config core.sparsecheckout true
    echo "deploy/" >> ~/project-git/info/sparse-checkout
}

lb_server_start()
{
    svcadm enable nginx
}

$@
