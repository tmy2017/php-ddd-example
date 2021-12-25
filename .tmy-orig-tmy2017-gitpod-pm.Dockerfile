# below credit goes to https://github.com/shaal/DrupalPod/blob/main/.gitpod/images/Dockerfile#L29  
FROM gitpod/workspace-full
SHELL ["/bin/bash", "-c"]
# ENV HOMEBREW_INSTALL_FROM_API=true

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

# Install ddev
RUN brew install drud/ddev/ddev

# Install latest composer
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
RUN php -r "if (hash_file('sha384', 'composer-setup.php') === '906a84df04cea2aa72f40b5f787e49f22d4c2f19492ac310e8cba5b96ac8b64115ac402c8cd292b8a03482574915d1a8') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
RUN sudo php composer-setup.php --install-dir /usr/bin --filename composer
RUN php -r "unlink('composer-setup.php');"