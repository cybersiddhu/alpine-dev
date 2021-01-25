# build antibody
FROM golang:1.15.7-buster AS antibuilder
LABEL maintainer="Siddhartha Basu <siddhartha-basu@northwestern.edu>"
ENV DEBIAN_FRONTEND=noninteractive
RUN mkdir -p /go \
    && cd /go \
    && git clone -b v4.1.2 --single-branch https://github.com/getantibody/antibody.git \
    && cd antibody \
    && go build -o antibody

# setup env
FROM node:14.15.4-buster-slim
LABEL maintainer="Siddhartha Basu <siddhartha-basu@northwestern.edu>"
ARG CONT_USER=cybersiddhu
ENV CUSTOMDIR=/custom
ENV XDG_CONFIG_HOME=${CUSTOMDIR}
ENV ZDOTDIR=${CUSTOMDIR}/dotfiles/shell
ENV TMUXDIR=${CUSTOMDIR}/dotfiles/tmux
ENV NVIMDIR=${XDG_CONFIG_HOME}/nvim
ENV COCDIR=${XDG_CONFIG_HOME}/coc
ENV LANG=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8
ENV TERM=screen
ENV DEBIAN_FRONTEND=noninteractive

# install deps 
RUN apt-get update -qqy \
    && apt-get upgrade -yq \
    && apt-get install -y --no-install-recommends \ 
       build-essential pkg-config autoconf automake \
       gnupg2 curl wget unzip zsh htop ninja-build \ 
       file ncurses-term tmux gawk tree fzf less \
       openssh-client silversearcher-ag tzdata git \
       python3 libpython3-all-dev python3-pip python 

# install python deps
RUN python3 -m pip install setuptools \
    && python3 -m pip install --upgrade pynvim 

# add user and group
RUN groupmod -n ${CONT_USER} node \ 
    && usermod -l ${CONT_USER} -g 1000 -d /home/${CONT_USER} -m node 

# install watchman
RUN cd /tmp \
    && curl -L -O https://github.com/facebook/watchman/releases/download/v2021.01.18.00/watchman-v2021.01.18.00-linux.zip  \ 
    && unzip watchman-*-linux.zip \ 
    && mkdir -p /usr/local/{bin,lib} /usr/local/var/run/watchman \
    && cd watchman-v2021.01.18.00-linux/ \
    && cp bin/* /usr/local/bin \
    && cp lib/* /usr/local/lib \
    && chmod 755 /usr/local/bin/watchman \
    && chmod 2777 /usr/local/var/run/watchman 

# OS setup
RUN apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && sed -i -e "s/bin\/ash/bin\/zsh/" /etc/passwd \
    && mkdir -p ${ZDOTDIR}/antibody ${TMUXDIR} ${NVIMDIR} ${COCDIR}/extensions  

# setup timezone
RUN cp /usr/share/zoneinfo/America/Chicago /etc/localtime \
    && echo "America/chicago" > /etc/timezone 

# install neovim
RUN cd /tmp \
    && curl -L -O https://github.com/neovim/neovim/releases/download/v0.4.4/nvim.appimage \
    && chmod +x nvim.appimage \
    && ./nvim.appimage --appimage-extract \
    && mv squashfs-root/* ${CUSTOMDIR}/  \
    && chown -R 1000:1000 ${CUSTOMDIR} /home/${CONT_USER} \
    && mkdir -p /var/run/watchman/${CONT_USER}-state \
    && cd /var/run \
    && chown -R 1000:1000 watchman  \
    && rm -fr /tmp/*

# configure antibody and zsh plugins
COPY --from=antibuilder /go/antibody/antibody  /usr/local/bin
USER ${CONT_USER}
WORKDIR /home/${CONT_USER} 
ADD plugin.txt ${ZDOTDIR}
ADD zshenv ${ZDOTDIR}/.zshenv
ADD zshrc ${ZDOTDIR}/.zshrc
ENV ANTIBODY_HOME=${ZDOTDIR}/antibody
RUN antibody bundle < ${ZDOTDIR}/plugin.txt > ${ZDOTDIR}/zsh_plugins.sh

# configure tmux
RUN git clone https://github.com/tmux-plugins/tpm ${TMUXDIR}/plugins/tpm \
    && git clone https://github.com/tmux-plugins/tmux-sensible ${TMUXDIR}/plugins/tmux-sensible \
    && git clone https://github.com/tmux-plugins/tmux-pain-control ${TMUXDIR}/plugins/tmux-pain-control \
    && git clone https://github.com/tmux-plugins/tmux-sidebar ${TMUXDIR}/plugins/tmux-sidebar \
    && git clone https://github.com/tmux-plugins/tmux-fpp ${TMUXDIR}/plugins/tmux-fpp \
    && git clone https://github.com/arcticicestudio/nord-tmux ${TMUXDIR}/plugins/nord-tmux
ADD tmux.conf ${TMUXDIR}/.tmux.conf
ENV TMUX_PLUGIN_MANAGER_PATH=${TMUXDIR}/plugins

# setup nvim
RUN mkdir -p ${NVIMDIR}/spf13
ADD init.vim ${NVIMDIR}/spf13/
ADD .vimr* ${NVIMDIR}/spf13/ 
ADD coc-settings.json ${NVIMDIR}/
ADD github-markdown.css ${NVIMDIR}/markdown/
RUN curl -fLo ${NVIMDIR}/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim \
    && mkdir -p ${NVIMDIR}/plugged ${NVIMDIR}/markdown \
    && ln -sf ${NVIMDIR}/spf13/init.vim ${NVIMDIR}/init.vim \
    && ln -sf ${NVIMDIR}/spf13/.vimrc.before ${NVIMDIR}/.vimrc.before \
    && ln -sf ${NVIMDIR}/spf13/.vimrc.bundles ${NVIMDIR}/.vimrc.bundles \
    && ln -sf ${NVIMDIR}/spf13/.vimrc.local ${NVIMDIR}/.vimrc.local  
RUN ${CUSTOMDIR}/usr/bin/nvim -E -s -u ${NVIMDIR}/init.vim +PlugInstall +qall 

# install coc-extensions
RUN cd ${COCDIR}/extensions \
    && echo '{"dependencies":{}}'> package.json \
    && npm install coc-dictionary coc-tag coc-word coc-marketplace \
       --global-style --ignore-scripts --no-bin-links \
       --no-package-lock --only=prod 
EXPOSE 9255

# shell path 
ENV SHELL=/bin/zsh
ENTRYPOINT ["/bin/zsh","-i" ]
CMD ["-l"]
