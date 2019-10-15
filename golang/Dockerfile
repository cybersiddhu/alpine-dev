## build antibody
FROM golang:1.11.13-alpine3.10 AS antibuilder
LABEL maintainer="Siddhartha Basu <siddhartha-basu@northwestern.edu>"
RUN apk add --no-cache git build-base \
	&& mkdir -p /go \
	&& cd /go \
	&& git clone -b v4.1.1 --single-branch https://github.com/getantibody/antibody.git \
	&& cd antibody \
	&& go get -v ./... \
	&& go build -o antibody

## build prototool and go tools
FROM cybersiddhu/golang:1.12.10-alpine-edge AS protobuilder
LABEL maintainer="Siddhartha Basu <siddhartha-basu@northwestern.edu>"
RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
    && apk add --no-cache build-base curl git protobuf \
    && rm -rf /var/cache/apk/*

ENV GOLANG_PROTOBUF_VERSION=1.3.2
ENV PROTOTOOL_VERSION=1.8.0
ENV GO_PROTO_VALIDATORS=0.2.0
ENV PROTOC_GEN_DOC=1.3.0
ENV HUB_VERSION=2.12.8
ENV GO111MODULE=on
RUN go get -v github.com/golang/protobuf/protoc-gen-go@v${GOLANG_PROTOBUF_VERSION} \
    && go get -v github.com/uber/prototool/cmd/prototool@v${PROTOTOOL_VERSION} \
    && go get -v github.com/mwitkow/go-proto-validators/protoc-gen-govalidators@v${GO_PROTO_VALIDATORS} \
    && go get -v github.com/pseudomuto/protoc-gen-doc/cmd/protoc-gen-doc@v${PROTOC_GEN_DOC} \
    && go get -v github.com/github/hub@v${HUB_VERSION}


## setup OS
FROM cybersiddhu/golang:1.11.13-alpine-edge
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
ENV CMAKE_EXTRA_FLAGS=-DENABLE_JEMALLOC=OFF
RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories
# install deps
RUN addgroup -g 1000 -S ${CONT_USER} \ 
	&& adduser -u 1000 -S -G ${CONT_USER} ${CONT_USER} \
    && apk add --update --virtual build-deps --no-cache \
        autoconf automake cmake g++ libtool \
        libuv linux-headers lua5.3-dev m4 make libtermkey-dev \
        libintl gettext-dev lua-sec 
# install deps
RUN  apk add --update --no-cache curl unzip ctags zsh git htop unibilium \
       file ca-certificates tmux bash gawk tree \ 
       openssh-client protobuf tzdata libtermkey \ 
       the_silver_searcher the_silver_searcher-zsh-completion \
       python npm yarn watchman \
       && npm install -g dockerfile-language-server-nodejs
# install deps
RUN git clone https://github.com/neovim/libvterm.git && \
    cd libvterm \
    make -j4 && make install \
    && cd ../ && rm -rf libvterm
# compile and install neovim
RUN git clone -b v0.4.2 --single-branch https://github.com/neovim/neovim.git nvim \
    && cd nvim \
    && make -j6 \
    && make install \
    && cd .. && rm -rf nvim 
# OS setup
RUN	rm -f /tmp/* /etc/apk/cache/* /var/cache/apk/* \ 
	&& sed -i -e "s/bin\/ash/bin\/zsh/" /etc/passwd \
	&& mkdir -p ${ZDOTDIR}/antibody ${TMUXDIR} ${NVIMDIR} ${COCDIR}/extensions \ 
	&& chown -R 1000:1000 ${CUSTOMDIR} \
    && mkdir -p /var/run/watchman/${CONT_USER}-state \
    && cd /var/run \
    && chown -R 1000:1000 watchman \
## timezone
    && cp /usr/share/zoneinfo/America/Chicago /etc/localtime \
    && echo "America/chicago" > /etc/timezone

## configure protocol buffer tools
COPY --from=protobuilder /go/bin/protoc-gen* /usr/local/bin/
COPY --from=protobuilder /go/bin/prototool /usr/local/bin/
## copy hub binary
COPY --from=protobuilder /go/bin/hub /usr/local/bin/
ENV GRPC_GATEWAY_VERSION=1.11.3
RUN curl -sSL \
    https://github.com/grpc-ecosystem/grpc-gateway/releases/download/v${GRPC_GATEWAY_VERSION}/protoc-gen-grpc-gateway-v${GRPC_GATEWAY_VERSION}-linux-x86_64 \
    -o /usr/local/bin/protoc-gen-grpc-gateway \
    && curl -sSL \
    https://github.com/grpc-ecosystem/grpc-gateway/releases/download/v${GRPC_GATEWAY_VERSION}/protoc-gen-swagger-v${GRPC_GATEWAY_VERSION}-linux-x86_64 \
    -o /usr/local/bin/protoc-gen-swagger \
    && chmod +x /usr/local/bin/protoc-gen-grpc-gateway \
    && chmod +x /usr/local/bin/protoc-gen-swagger

## configure antibody
COPY --from=antibuilder /go/antibody/antibody  /usr/local/bin
USER ${CONT_USER}
WORKDIR /home/cybersiddhu 
ADD plugin.txt ${ZDOTDIR}
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
	&& ln -sf ${NVIMDIR}/spf13/.vimrc.local ${NVIMDIR}/.vimrc.local \
	&& nvim -E -s -u ${NVIMDIR}/init.vim +PlugInstall +qall \
    && cd ${COCDIR}/extensions \
    && echo '{"dependencies":{}}'> package.json \
    && npm install coc-dictionary coc-tag coc-word \
       --global-style --ignore-scripts --no-bin-links \
       --no-package-lock --only=prod
ADD coc-settings.json ${NVIMDIR}/
ADD github-markdown.css ${NVIMDIR}/markdown/
EXPOSE 9255

## configure zsh
ENV SHELL=/bin/zsh
ENTRYPOINT ["/bin/zsh","-i" ]
CMD ["-l"]
