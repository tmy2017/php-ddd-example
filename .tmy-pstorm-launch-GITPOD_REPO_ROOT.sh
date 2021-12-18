#!/bin/sh
#projector run - learn from https://github.com/shaal/DrupalPod/blob/main/.gitpod/utils/phpstorm.template.sh
gp preview --external `gp url 19999`
# found it! no more "Starting attempts to set keymap to match user's OS (MAC)"
#       solution: https://youtrack.jetbrains.com/issue/PRJ-121#focus=Comments-27-5198388.0-0 and 
#       https://jetbrains.github.io/projector-client/mkdocs/latest/ij_user_guide/server_customization/#list-of-parameters 
export ORG_JETBRAINS_PROJECTOR_SERVER_AUTO_KEYMAP=false
~/.projector/configs/PhpStormByIdeAutoinstall-2021.2/run.sh ${GITPOD_REPO_ROOT}
