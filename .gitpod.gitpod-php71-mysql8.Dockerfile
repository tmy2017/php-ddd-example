# NOTICE: 
#   1) this mysql image seems to only install mysql 8
#   2) !!! it uses .bashrc to check `mysqld` running or not, hence `mysqladmin shutdown` can only stop mysqld until next terminal is started
#       INFO: https://github.com/gitpod-io/workspace-images/blob/master/mysql/mysql-bashrc-launch.sh#L3
FROM gitpod/workspace-mysql

### START: PHP v7.1 ###
# thanks to corneliusludmann - https://community.gitpod.io/t/downgrade-default-php-v7-4-3-to-7-1-3-or-7-2/3099/4?u=tkgc 
#   also on workspace-full https://github.com/gitpod-io/workspace-images/blob/master/full/Dockerfile#L26 
USER root

# NOTICE: above is NOT `USER gitpod` hence the mysqld.pid problem will not occur. Therefore below is NOT needed
#   Ref: https://github.com/tmy2017/php-ddd-example/blob/main/.gitpod.gitpod-pstorm-with-php71-mysql8.Dockerfile#L5
# RUN rm -rf /var/run/mysqld/mysqld.pid

# must install php-dev so xdebug can install successfully below
# XDebug version is chosen by the Ubuntu Package Maintainer - ex: for php7.1 below is still XDebug 2
# NOTE: !!! -y for add-apt-repository very surprisingly NOT needed when it's in Dockerfile RUN directive
#   but when running in .gitpod.yml as before or init task, then MUST have -y
RUN add-apt-repository ppa:ondrej/php -y && \
    install-packages php7.1 php7.1-xdebug php7.1-mysql php7.1-intl php7.1-mbstring php7.1-curl && \
    update-alternatives --set php /usr/bin/php7.1

### START: XDebug 
# thanks to https://github.com/apolopena/Gitpod-PHP-Debug/blob/master/.gitpod.Dockerfile

RUN touch /var/log/xdebug.log \
    && chmod 666 /var/log/xdebug.log

# NOTE: Below is php version dependent (php.ini file path), so remember to change below if using another php version 
RUN bash -c "echo -e 'xdebug.remote_host = 127.0.0.1\nxdebug.remote_port = 9000\nxdebug.remote_log = /var/log/xdebug.log\nxdebug.remote_enable = 1\nxdebug.remote_autostart = 1\n' >> /etc/php/7.1/cli/php.ini" \
    bash -c "echo -e 'xdebug.remote_host = 127.0.0.1\nxdebug.remote_port = 9000\nxdebug.remote_log = /var/log/xdebug.log\nxdebug.remote_enable = 1\nxdebug.remote_autostart = 1\n' >> /etc/php/7.1/apache2/php.ini"

### END: XDebug 

# Install latest composer
#   since `apt-get install composer` seems to ONLY install version 1, so must do below
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
RUN php -r "if (hash_file('sha384', 'composer-setup.php') === '906a84df04cea2aa72f40b5f787e49f22d4c2f19492ac310e8cba5b96ac8b64115ac402c8cd292b8a03482574915d1a8') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
# very useful command! credit: https://github.com/shaal/DrupalPod/blob/main/.gitpod/images/Dockerfile#L29 
# NOTE: force install v1 since this cakephp 3 is in composer v1 era. If use composer v2 and install, will see:
#   "Loading "cakephp/plugin-installer" which is a legacy composer-installer built for Composer 1.x, it is likely to cause issues as you are running Composer 2.x.
#   and cake server will see `Plugin Migrations could not be found. in [/workspace/bookmarker-tutorial/vendor/cakephp/cakephp/src/Core/Plugin.php, line 149]`
RUN sudo php composer-setup.php --1 --install-dir /usr/bin --filename composer
RUN php -r "unlink('composer-setup.php');"
### END: PHP v7.2 ###

# the /workspace inside container is owned by root hence running this container manually there will be error
#   due to mysql folder can not be created. But when run by real GitPod then it is owned by gitpod.
#   This little command to increase parity and resolve error
RUN chown gitpod:gitpod /workspace/

# seems must change back to gitpod for the following phpstorm part to work - ex: .projector folder permission to be NOT root
USER gitpod

# Install ddev
RUN brew install drud/ddev/ddev
