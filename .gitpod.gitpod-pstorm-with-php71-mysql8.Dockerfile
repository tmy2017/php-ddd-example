# use latest tag explicitly to signal the previous image data must carry on to this new one 
FROM tmy2017/gitpod-pstorm-with-php71-mysql8:latest as prev-img-custom-cmds-and-pstorm-settings
FROM tmy2017/gitpod-php71-mysql8:latest
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

# copy previous image to this one 
RUN mkdir -p .local/share/JetBrains
# clean up folders which might be created by above projector install
RUN rm -rf /home/gitpod/.config/JetBrains \
    rm -rf /home/gitpod/.local/share/Jetbrains \ 
    rm -rf /home/gitpod/.projector \
    rm -rf /home/gitpod/.java/.userPrefs/jetbrains
COPY --from=prev-img-custom-cmds-and-pstorm-settings /home/gitpod/.config/JetBrains/ /home/gitpod/.config/
COPY --from=prev-img-custom-cmds-and-pstorm-settings /home/gitpod/.local/share/JetBrains/ /home/gitpod/.local/share/
COPY --from=prev-img-custom-cmds-and-pstorm-settings /home/gitpod/.projector/ /home/gitpod/

# download from github for custom commands and change to executable
USER root
ADD https://raw.githubusercontent.com/tmy2017/php-ddd-example/main/.tmy-pstorm-launch-GITPOD_REPO_ROOT.sh /usr/local/bin/tmy-pstorm-launch-GITPOD_REPO_ROOT
ADD https://raw.githubusercontent.com/tmy2017/php-ddd-example/main/.tmy-save-ide-settings-through-image-for-gitpod.sh /usr/local/bin/tmy-save-ide-settings-through-image-for-gitpod
ADD https://raw.githubusercontent.com/tmy2017/php-ddd-example/main/.tmy-update-custom-cmds-from-usr-local-bin.sh /usr/local/bin/tmy-update-custom-cmds-from-usr-local-bin
RUN chmod 555 /usr/local/bin/tmy-pstorm-launch-GITPOD_REPO_ROOT /usr/local/bin/tmy-save-ide-settings-through-image-for-gitpod /usr/local/bin/tmy-update-custom-cmds-from-usr-local-bin

# return to gitpod as normal user
USER gitpod