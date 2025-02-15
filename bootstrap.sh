#!/usr/bin/env bash

VH=/home/vagrant
BOOT=/vagrant/boot
RESOURCES=/vagrant/resources

IDEA_URL='https://download-cdn.jetbrains.com/idea/ideaIU-2024.3.2.tar.gz'
WEBSTORM_URL='https://download-cf.jetbrains.com/webstorm/WebStorm-2018.1.2.tar.gz'
DOCKER_MACHINE_VERSION=0.16.2
DOCKER_COMPOSER_VERSION=1.29.2

function heading(){
  echo ---------------------------- >&2
  echo $* >&2
  echo ---------------------------- >&2
}

export DEBIAN_FRONTEND=noninteractive

heading Updating apt sources
until apt-get update ; do echo retrying updating apt sources... ; done

heading Updating packages
until apt-get -y upgrade ; do echo retrying updating packages... ; done

heading 'ssh keys set up'
sudo -Hu vagrant ${BOOT}/101-maybe-set-up-ssh-keys.bash ${RESOURCES}/ssh-keys
heading 'known_hosts set up'
sudo -Hu vagrant ${BOOT}/102-set-up-known_hosts.bash github.com bitbucket.org

heading Installing curl
${BOOT}/210-install-curl.bash

heading Installing jq
${BOOT}/212-as-root-install-jq.bash

heading Installing sbt
${BOOT}/010-install-sbt-step-1-add-apt-sources.bash
until apt-get update ; do echo retrying updating apt sources... ; done
${BOOT}/220-install-sbt-step-2-apt-get-install.bash

heading Installing tree
${BOOT}/230-install-tree.bash
heading Installing gitk
${BOOT}/240-install-gitk.bash
heading Setting up git
sudo -Hu vagrant ${BOOT}/241-set-up-git.bash ${RESOURCES}/git/email ${RESOURCES}/git/name
${BOOT}/245-as-root-install-tig.bash
heading Installing git-crypt
${BOOT}/247-as-root-install-git-crypt.bash

heading Installing Chromium
${BOOT}/250-as-root-install-chromium.bash

heading Installing net-tools
${BOOT}/260-as-root-install-net-tools.bash

heading Installing rbenv with ruby-build
${BOOT}/270-as-root-install-rbenv.bash
sudo -Hu vagrant ${BOOT}/271-as-vagrant-set-up-rbenv.bash
sudo -Hu vagrant ${BOOT}/272-as-vagrant-install-ruby-build.bash

heading Installing openjdk
${BOOT}/302-as-root-install-openjdk.bash

heading Installing IntelliJ Idea
sudo -Hu vagrant ${BOOT}/410-install-idea-step-1-install.bash "$IDEA_URL" "${VH}/tools"
${BOOT}/411-install-idea-step-2-increase-fs-user-watches.bash
sudo -Hu vagrant ${BOOT}/412-maybe-copy-idea-config.bash ${RESOURCES}/idea-config/config "${VH}"/.config/JetBrains
sudo -Hu vagrant ${BOOT}/412-maybe-copy-idea-config.bash ${RESOURCES}/idea-config/plugins "${VH}"/.local/share/JetBrains

#heading Installing WebStorm
#sudo -Hu vagrant ${BOOT}/420-install-webstorm.bash "$WEBSTORM_URL" "${VH}/tools"

heading Installing Node
${BOOT}/510-install-node-all-users.bash

#heading Installing yarn
#${BOOT}/520-as-root-install-yarn.bash
#sudo -Hu vagrant ${BOOT}/521-as-vagrant-add-yarn-to-path.bash

#heading Installing elm
#sudo -Hu vagrant ${BOOT}/530-install-elm.bash

heading Installing entr
${BOOT}/601-as-root-install-entr.bash

heading 'Installing heroku cli'
${BOOT}/620-install-heroku-cli.bash

heading 'Installing gsutil'
sudo -Hu vagrant ${BOOT}/630-as-vagrant-install-gsutil.bash


heading 'Installing Docker CE and Docker Compose'
${BOOT}/701-as-root-install-docker-ce-and-docker-compose.bash

heading 'Installing Docker Rootless'
${BOOT}/705-as-root-install-docker-rootless-dependencies.bash
sudo -Hu vagrant ${BOOT}/706-as-vagrant-install-docker-rootless.bash
${BOOT}/707-as-root-enable-linger-for-vagrant-user-for-docker-rootless.bash

heading 'Installing Slack'
${BOOT}/730-install-slack.bash

heading 'Installing mbpoll (cli client to talk to a ModBus slave)'
${BOOT}/740-as-root-install-mbpoll.bash

heading 'Installing influxdb client'
${BOOT}/760-as-root-install-influxdb-client.bash

heading 'Installing terraform'
${BOOT}/770-as-root-install-terraform.bash

heading 'Installing Hashicorp vault'
${BOOT}/771-as-root-install-vault.bash

heading 'Installing Cloudfoundry CLI'
${BOOT}/772-as-root-install-cloudfoundry-cli.bash

heading 'Installing nix with flakes'
${BOOT}/780-as-root-install-nix-multi-user-with-flakes.bash

#heading 'Installing Chinese Hong Kong Cantonese Jyutping input support'
#${BOOT}/810-as-root-install-chinese-hongkong-jyutping-input.bash

