FROM tmy2017/gitpod-php71-mysql8
# seems must change back to gitpod for the following phpstorm part to work - ex: .projector folder permission to be NOT root
USER gitpod

# NOTICE: seems above `USER gitpod` really triggered `mysqld --daemonize` from gitpod/workspace-mysql, hence the `mysql-bashrc-launch.sh`
#   is broken. What a story... Hence all images depend on above MUST rm the pid so to have expected result: mysqld only starts when login
#   https://github.com/gitpod-io/workspace-images/blob/master/mysql/mysql-bashrc-launch.sh#L14
RUN rm -rf /var/run/mysqld/mysqld.pid

# thanks to Shaal - DrupalPod: https://github.com/shaal/DrupalPod/blob/main/.gitpod/images/Dockerfile#L5
RUN sudo apt-get -qq update
# Install required libraries for Projector + PhpStorm
RUN sudo apt-get -qq install -y patchutils python3 python3-pip libxext6 libxrender1 libxtst6 libfreetype6 libxi6 telnet netcat
# Install Projector
RUN pip3 install projector-installer

# strange syntax - main command projector must first accept GPL license or it would get stuck in docker build
#   then the sub command ide autoinstall 
# Install PhpStorm 
#   as of (9-Dec-2021T10-37+0100) `projector find` informs 2021.2 is tested version
#   more info on command - https://github.com/JetBrains/projector-installer/blob/master/COMMANDS.md#ide-commands
RUN projector --accept-license ide autoinstall --config-name PhpStormByIdeAutoinstall-2021.2 --ide-name "PhpStorm 2021.2" --port 19999