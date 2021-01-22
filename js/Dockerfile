## build antibody
FROM golang:1.15.6-alpine3.12 AS antibuilder
LABEL maintainer="Siddhartha Basu <siddhartha-basu@northwestern.edu>"
RUN apk add --no-cache git build-base \
    && mkdir -p /go \
    && cd /go \
    && git clone -b v6.1.1 --single-branch https://github.com/getantibody/antibody.git \
    && cd antibody \
    && go build -o antibody

## build bs-platform
FROM node:14.15.4-alpine3.12 AS bsbuilder
ARG VERSION=8.4.2
RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories 
RUN apk add --update --no-cache g++ make python3 && \
    yarn global add bs-platform@${VERSION}

## setup OS
FROM node:14.15.4-alpine3.12
LABEL maintainer="Siddhartha Basu <siddhartha-basu@northwestern.edu>"
ARG CONT_USER=cybersiddhu
ARG VERSION=8.4.2
ENV CUSTOMDIR=/custom
ENV XDG_CONFIG_HOME=${CUSTOMDIR}
ENV ZDOTDIR=${CUSTOMDIR}/dotfiles/shell
ENV TMUXDIR=${CUSTOMDIR}/dotfiles/tmux
ENV NVIMDIR=${XDG_CONFIG_HOME}/nvim
ENV COCDIR=${XDG_CONFIG_HOME}/coc
ENV LANG=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8
ENV TERM=screen
RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories
# install deps and add users and groups
RUN apk add --update --virtual build-deps --no-cache build-base shadow g++ make \ 
    curl unzip zsh git htop file ca-certificates tmux bash gawk \ 
    gnupg exa fd openssh-client tzdata fzf the_silver_searcher \ 
    the_silver_searcher-zsh-completion python2 python3 python3-dev \ 
    py3-pip watchman neovim \
    && pip3 install --upgrade pynvim \
    && yarn global add dockerfile-language-server-nodejs semantic-release \
    && groupmod -n ${CONT_USER} node \ 
    && usermod -l ${CONT_USER} -g 1000 -d /home/${CONT_USER} -m node \
# OS setup
    && rm -fr /tmp/* /etc/apk/cache/* /var/cache/apk/* \ 
    && sed -i -e "s/bin\/ash/bin\/zsh/" /etc/passwd \
    && mkdir -p ${ZDOTDIR}/antibody ${TMUXDIR} ${NVIMDIR} ${COCDIR}/extensions \
    && chown -R 1000:1000 ${CUSTOMDIR} \
    && mkdir -p /var/run/watchman/${CONT_USER}-state \
    && cd /var/run \
    && chown -R 1000:1000 watchman \
## timezone
    && cp /usr/share/zoneinfo/America/Chicago /etc/localtime \
    && echo "America/chicago" > /etc/timezone
## configure bs-platform
COPY --from=bsbuilder /usr/local/share/.config/yarn/global /usr/local/share/.config/yarn/global
ENV BS_PLATFORM_VERSION=${VERSION}
RUN cd /usr/local 
    && ln -s ../share/.config/yarn/global/node_modules/.bin/bsb bin/bsb \
    && ln -s ../share/.config/yarn/global/node_modules/.bin/bsc bin/bsc \
    && ln -s ../share/.config/yarn/global/node_modules/.bin/bsrefmt bin/bsrefmt
## configure antibody
COPY --from=antibuilder /go/antibody/antibody  /usr/local/bin
USER ${CONT_USER}
WORKDIR /home/${CONT_USER} 
ADD plugin.txt ${ZDOTDIR}
ADD zshenv ${ZDOTDIR}/.zshenv
ADD zshrc ${ZDOTDIR}/.zshrc
ENV ANTIBODY_HOME=${ZDOTDIR}/antibody
RUN antibody bundle < ${ZDOTDIR}/plugin.txt > ${ZDOTDIR}/zsh_plugins.sh

## configure tmux
RUN git clone https://github.com/tmux-plugins/tpm ${TMUXDIR}/plugins/tpm \
    && git clone https://github.com/tmux-plugins/tmux-sensible ${TMUXDIR}/plugins/tmux-sensible \
    && git clone https://github.com/tmux-plugins/tmux-pain-control ${TMUXDIR}/plugins/tmux-pain-control \
    && git clone https://github.com/tmux-plugins/tmux-sidebar ${TMUXDIR}/plugins/tmux-sidebar \
    && git clone https://github.com/tmux-plugins/tmux-fpp ${TMUXDIR}/plugins/tmux-fpp \
    && git clone https://github.com/arcticicestudio/nord-tmux ${TMUXDIR}/plugins/nord-tmux
ADD tmux.conf ${TMUXDIR}/.tmux.conf
ENV TMUX_PLUGIN_MANAGER_PATH=${TMUXDIR}/plugins

## setup nvim
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
RUN nvim -E -s -u ${NVIMDIR}/init.vim +PlugInstall +qall 
RUN cd ${COCDIR}/extensions \
    && echo '{"dependencies":{}}'> package.json \
    && npm install coc-dictionary coc-tag coc-word coc-marketplace \
       --global-style --ignore-scripts --no-bin-links \
       --no-package-lock --only=prod 
EXPOSE 9255

## configure zsh
ENV SHELL=/bin/zsh
ENTRYPOINT ["/bin/zsh","-i" ]
CMD ["-l"]
