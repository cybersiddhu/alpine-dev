# build antibody
FROM golang:1.13.10-buster AS builder
LABEL maintainer="Siddhartha Basu <siddhartha-basu@northwestern.edu>"
ENV DEBIAN_FRONTEND=noninteractive
RUN apt update -qq \ 
    && apt-get -y --no-install-recommends install git \
	&& mkdir -p /go \
	&& cd /go \
	&& git clone -b v4.1.2 --single-branch https://github.com/getantibody/antibody.git \
	&& cd antibody \
	&& go get -v ./... \
	&& go build -o antibody
ENV HUB_VERSION=v2.11.2+incompatible
ENV GO111MODULE=on
RUN go get -v github.com/github/hub@${HUB_VERSION}

#python setup
FROM python:3.7.7-slim-buster
LABEL maintainer="Siddhartha Basu <siddhartha-basu@northwestern.edu>"
ARG CONT_USER=cybersiddhu
ENV CUSTOMDIR=/custom
ENV XDG_CONFIG_HOME=${CUSTOMDIR}
ENV ZDOTDIR=${CUSTOMDIR}/dotfiles/shell
ENV TMUXDIR=${CUSTOMDIR}/dotfiles/tmux
ENV NVIMDIR=${XDG_CONFIG_HOME}/nvim
ENV COCDIR=${XDG_CONFIG_HOME}/coc
ENV LANG_SERVER_DIR=${COCDIR}/extensions/coc-python-data/languageServer.0.5.45
ENV LANG=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8
ENV TERM=screen
ENV DEBIAN_FRONTEND=noninteractive
## install deps
RUN addgroup --gid 1000 ${CONT_USER} \ 
    && useradd -m --uid 1000 -g ${CONT_USER} ${CONT_USER} \
    && apt update -qq \
    && apt upgrade -y \
    && apt-get install -y --no-install-recommends \ 
       build-essential \
       pkg-config \
       autoconf \
       automake \
       locales-all \
       libtool \
       libffi-dev \ 
       libffi6 \
       gnupg2 \
       libssl-dev \
       libpq-dev \ 
       libhdf5-dev \
       libblas-dev \ 
       liblapack-dev \ 
       libpng-dev \ 
       graphviz-dev \
       gfortran-8 \ 
       curl \ 
       wget \
       unzip \ 
       exuberant-ctags \
       zsh \ 
       git-core \ 
       htop \ 
       file \ 
       ncurses-term \
       tmux \ 
       gawk \ 
       tree \ 
       fzf \
       less \
       openssh-client \ 
       silversearcher-ag \
       nodejs \ 
       libpython3-all-dev \ 
       tzdata  \
       m4
## install watchman
RUN cd /tmp \
    && git clone https://github.com/facebook/watchman.git -b v4.9.0 --depth 1 \
    && cd watchman \
    && ./autogen.sh \
    && ./configure --enable-statedir=/tmp --enable-lenient --without-pcre \
    && make -j6 \
    && make install 
## install node, npm and yarn
RUN curl -sL https://deb.nodesource.com/setup_12.x | bash - \
    && curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg |  apt-key add - \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" |  tee /etc/apt/sources.list.d/yarn.list \
    && apt-get -y --no-install-recommends install nodejs \ 
## install neovim
    && cd /tmp \
    && curl -L -O https://github.com/neovim/neovim/releases/download/v0.4.3/nvim.appimage \
    && chmod +x nvim.appimage \
    && ./nvim.appimage --appimage-extract \
    && mv squashfs-root ${CUSTOMDIR}/ 
## other installs
RUN npm install -g dockerfile-language-server-nodejs semantic-release yarn \
    && python -m pip install poetry \
    && cd \
    && rm -fr /tmp/*
## OS setup
RUN apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && sed -i -e "s/bin\/ash/bin\/zsh/" /etc/passwd \
    && mkdir -p ${ZDOTDIR}/antibody ${TMUXDIR} ${NVIMDIR} ${LANG_SERVER_DIR} \ 
    && chown -R 1000:1000 ${CUSTOMDIR} /home/${CONT_USER} \
    && mkdir -p /var/run/watchman/${CONT_USER}-state \
    && cd /var/run \
    && chown -R 1000:1000 watchman \
### timezone
    && cp /usr/share/zoneinfo/America/Chicago /etc/localtime \
    && echo "America/chicago" > /etc/timezone

### copy hub binary
COPY --from=builder /go/bin/hub /usr/local/bin/
### configure antibody
COPY --from=builder /go/antibody/antibody  /usr/local/bin
USER ${CONT_USER}
WORKDIR /home/${CONT_USER} 
ADD plugin.txt ${ZDOTDIR}
ADD zshenv ${ZDOTDIR}/.zshenv
ADD zshrc ${ZDOTDIR}/.zshrc
ENV ANTIBODY_HOME=${ZDOTDIR}/antibody
RUN antibody bundle < ${ZDOTDIR}/plugin.txt > ${ZDOTDIR}/zsh_plugins.sh

### configure tmux
RUN git clone https://github.com/tmux-plugins/tpm ${TMUXDIR}/plugins/tpm \
    && git clone https://github.com/tmux-plugins/tmux-sensible ${TMUXDIR}/plugins/tmux-sensible \
    && git clone https://github.com/tmux-plugins/tmux-pain-control ${TMUXDIR}/plugins/tmux-pain-control \
    && git clone https://github.com/tmux-plugins/tmux-sidebar ${TMUXDIR}/plugins/tmux-sidebar \
    && git clone https://github.com/tmux-plugins/tmux-fpp ${TMUXDIR}/plugins/tmux-fpp \
    && git clone https://github.com/arcticicestudio/nord-tmux ${TMUXDIR}/plugins/nord-tmux
ADD tmux.conf ${TMUXDIR}/.tmux.conf
ENV TMUX_PLUGIN_MANAGER_PATH=${TMUXDIR}/plugins

### setup nvim
RUN curl -fLo ${NVIMDIR}/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim \
    && mkdir -p ${NVIMDIR}/plugged ${NVIMDIR}/markdown \
    && git clone --branch feature/python-coc https://github.com/cybersiddhu/spf13-vim.git ${NVIMDIR}/spf13 \
    && ln -sf ${NVIMDIR}/spf13/.vimrc.before ${NVIMDIR}/.vimrc.before \
    && ln -sf ${NVIMDIR}/spf13/init.vim ${NVIMDIR}/init.vim \
    && ln -sf ${NVIMDIR}/spf13/.vimrc.bundles ${NVIMDIR}/.vimrc.bundles \
    && ln -sf ${NVIMDIR}/spf13/.vimrc.local ${NVIMDIR}/.vimrc.local \
    && ${CUSTOMDIR}/usr/bin/nvim  -E -s -u ${NVIMDIR}/init.vim +PlugInstall +qall 

RUN cd ${COCDIR}/extensions \
    && echo '{"dependencies":{}}'> package.json \
    && npm install coc-dictionary coc-tag coc-word coc-marketplace coc-json \
       --global-style --ignore-scripts --no-bin-links \
       --no-package-lock --only=prod 
ADD coc-settings.json ${NVIMDIR}/
ADD github-markdown.css ${NVIMDIR}/markdown/
EXPOSE 9255

### configure zsh
ENV SHELL=/bin/zsh
ENTRYPOINT ["/bin/zsh","-i" ]
CMD ["-l"]
