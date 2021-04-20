## build antibody
FROM golang:1.16.3-alpine3.13 AS antigitbuilder
LABEL maintainer="Siddhartha Basu <siddhartha-basu@northwestern.edu>"
RUN apk add --no-cache git build-base \
	&& mkdir -p /go \
	&& cd /go \
	&& git clone -b v6.1.1 --single-branch https://github.com/getantibody/antibody.git \
	&& cd antibody \
	&& go build -o antibody \
	&& cd /go \
	&& git clone -b 0.7.2 --single-branch https://github.com/MichaelMure/git-bug \
	&& cd git-bug \
	&& make build

## build prototool and go tools
FROM golang:1.16.3-alpine3.13 AS protobuilder
LABEL maintainer="Siddhartha Basu <siddhartha-basu@northwestern.edu>"
RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories
RUN apk add --no-cache build-base curl git protobuf \
    && rm -rf /var/cache/apk/*

ENV PROTOTOOL_VERSION=1.9.0
ENV GO_PROTO_VALIDATORS=0.2.0
ENV PROTOC_GEN_DOC=1.4.1
ENV CLI_VERSION=v1.9.1
ENV GO111MODULE=auto
RUN go install google.golang.org/protobuf/cmd/protoc-gen-go \
    && go install google.golang.org/grpc/cmd/protoc-gen-go-grpc \
    && go install github.com/grpc-ecosystem/grpc-gateway/v2/protoc-gen-grpc-gateway \
    && go install github.com/grpc-ecosystem/grpc-gateway/v2/protoc-gen-openapiv2 \
    && go get -v github.com/uber/prototool/cmd/prototool@v${PROTOTOOL_VERSION} \
    && go get -v github.com/mwitkow/go-proto-validators/protoc-gen-govalidators \
    && go get -v github.com/pseudomuto/protoc-gen-doc/cmd/protoc-gen-doc@v${PROTOC_GEN_DOC} \
    && git clone -b ${CLI_VERSION} https://github.com/cli/cli.git gh-cli \
    && cd gh-cli \
    && make \
    && cp bin/gh /go/bin/


#########################################
## setup dev environment 
#########################################
FROM golang:1.16.3-alpine3.13
LABEL maintainer="Siddhartha Basu <siddhartha-basu@northwestern.edu>"
ARG CONT_USER=cybersiddhu
ARG UID=1000
ARG GID=1000
ARG HOME_BASE=/home
ENV HOME=/${HOME_BASE}/${CONT_USER}
ENV CUSTOMDIR=/custom
ENV XDG_CONFIG_HOME=${CUSTOMDIR}
ENV ZDOTDIR=${CUSTOMDIR}/dotfiles/shell
ENV TMUXDIR=${CUSTOMDIR}/dotfiles/tmux
ENV NVIMDIR=${XDG_CONFIG_HOME}/nvim
ENV NVIM_LOG_FILE=${NVIMDIR}/log
ENV COCDIR=${XDG_CONFIG_HOME}/coc
ENV LANG=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8
ENV TERM=screen
ENV CMAKE_EXTRA_FLAGS=-DENABLE_JEMALLOC=OFF
RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories
# install deps
RUN  apk add --update --virtual build-deps --no-cache \ 
       autoconf automake cmake g++ libtool \
       libuv linux-headers lua5.3-dev m4 make libtermkey-dev \
       libintl gettext-dev lua-sec shadow \
       curl unzip ctags zsh git htop unibilium \
       file ca-certificates tmux bash gawk \ 
       gnupg exa fd starship \ 
       openssh-client protobuf tzdata libtermkey \ 
       the_silver_searcher the_silver_searcher-zsh-completion \
     python2 python3 python3-dev py3-pip npm yarn watchman neovim \
     && npm install -g dockerfile-language-server-nodejs semantic-release \
     && pip3 install --upgrade pynvim
# setup user
RUN groupadd -g ${GID} ${CONT_USER} \ 
    && useradd -u ${UID} -d ${HOME} -g ${CONT_USER} --system -m ${CONT_USER} 
# OS setup
RUN rm -fr /tmp/* /etc/apk/cache/* /var/cache/apk/* \ 
    && sed -i -e "s/bin\/ash/bin\/zsh/" /etc/passwd \
    && mkdir -p ${CUSTOMDIR}/starship ${ZDOTDIR}/antibody ${TMUXDIR} ${NVIMDIR} ${COCDIR}/extensions \ 
    && chown -R ${UID}:${GID} ${CUSTOMDIR} \
    && chown -R ${UID}:${GID} ${HOME} \
    && mkdir -p /var/run/watchman/${CONT_USER}-state \
    && cd /var/run \
    && chown -R ${UID}:${GID} watchman \
## timezone
    && cp /usr/share/zoneinfo/America/Chicago /etc/localtime \
    && echo "America/chicago" > /etc/timezone

## configure protocol buffer tools
COPY --from=protobuilder /go/bin/protoc-gen* /usr/local/bin/
COPY --from=protobuilder /go/bin/prototool /usr/local/bin/
## copy gh binary
COPY --from=protobuilder /go/bin/gh /usr/local/bin/
## copy git-bug
COPY --from=antigitbuilder /go/git-bug/git-bug /usr/local/bin
## configure antibody
COPY --from=antigitbuilder /go/antibody/antibody  /usr/local/bin
USER ${CONT_USER}
WORKDIR ${HOME} 
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
RUN curl -fLo ${NVIMDIR}/autoload/plug.vim --create-dirs \
	https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim \
	&& mkdir -p ${NVIMDIR}/plugged ${NVIMDIR}/markdown \
	&& git clone --branch feature/golang-coc https://github.com/cybersiddhu/spf13-vim.git ${NVIMDIR}/spf13 \
	&& ln -sf ${NVIMDIR}/spf13/.vimrc.before ${NVIMDIR}/.vimrc.before \
	&& ln -sf ${NVIMDIR}/spf13/init.vim ${NVIMDIR}/init.vim \
	&& ln -sf ${NVIMDIR}/spf13/.vimrc.bundles ${NVIMDIR}/.vimrc.bundles \
	&& ln -sf ${NVIMDIR}/spf13/.vimrc.local ${NVIMDIR}/.vimrc.local  \
	&& nvim --headless -E -s -u ${NVIMDIR}/init.vim +PlugInstall +qall 

RUN cd ${COCDIR}/extensions \
    && echo '{"dependencies":{}}'> package.json \
    && npm install coc-dictionary coc-tag coc-word coc-marketplace \
       --global-style --ignore-scripts --no-bin-links \
       --no-package-lock --only=prod 
ADD coc-settings.json ${NVIMDIR}/
ADD github-markdown.css ${NVIMDIR}/markdown/
ADD config.toml ${CUSTOMDIR}/starship/
EXPOSE 9255

## configure zsh
ENV SHELL=/bin/zsh
ENTRYPOINT ["/bin/zsh","-i" ]
CMD ["-l"]
