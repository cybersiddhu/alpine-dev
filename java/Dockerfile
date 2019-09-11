## build antibody
FROM golang:1.13.0-alpine3.10 
LABEL maintainer="Siddhartha Basu <siddhartha-basu@northwestern.edu>"
RUN apk add --no-cache git build-base \
	&& mkdir -p /go \
	&& cd /go \
	&& git clone -b v4.1.2 --single-branch https://github.com/getantibody/antibody.git \
	&& cd antibody \
	&& go get -v ./... \
	&& go build -o antibody


## setup OS
FROM alpine:edge
LABEL maintainer="Siddhartha Basu<biosidd@gmail.com>" 
ARG CONT_USER=cybersiddhu
ENV CUSTOMDIR=/custom
ENV ZDOTDIR=${CUSTOMDIR}/dotfiles/shell
ENV TMUXDIR=${CUSTOMDIR}/dotfiles/tmux
ENV VIMDIR=${CUSTOMDIR}/dotfiles/vim
ENV LANG=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8
ENV TERM=screen
ENV CMAKE_EXTRA_FLAGS=-DENABLE_JEMALLOC=OFF
RUN echo "http://dl-4.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories
# install deps
RUN addgroup -g 1000 -S ${CONT_USER} \ 
	&& adduser -u 1000 -S -G ${CONT_USER} ${CONT_USER} \
    && apk add --update-cache --virtual build-deps --no-cache \
        autoconf automake cmake g++ libtool \
        libuv linux-headers lua5.3-dev m4 make libtermkey-dev \
        libintl gettext-dev lua-sec 
# install deps
RUN  apk add --update-cache curl unzip ctags zsh git htop unibilium \
       file ca-certificates tmux bash gawk tree \ 
       openssh-client protobuf tzdata libtermkey \ 
       the_silver_searcher the_silver_searcher-zsh-completion \
       python openjdk11-jdk yarn watchman
# install deps
RUN git clone https://github.com/neovim/libvterm.git && \
    cd libvterm \
    make -j4 && make install \
    && cd ../ && rm -rf libvterm
# compile and install neovim
RUN git clone -b nightly --single-branch https://github.com/neovim/neovim.git nvim \
    && cd nvim \
    && make -j6 \
    && make install \
    && cd .. && rm -rf nvim 
# OS setup
RUN	rm -f /tmp/* /etc/apk/cache/* \ 
	&& sed -i -e "s/bin\/ash/bin\/zsh/" /etc/passwd \
	&& mkdir -p ${ZDOTDIR}/antibody ${TMUXDIR} ${VIMDIR} \ 
	&& chown -R 1000:1000 ${CUSTOMDIR} \
## timezone
    && cp /usr/share/zoneinfo/America/Chicago /etc/localtime \
    && echo "America/chicago" > /etc/timezone

#download and extract gradle
ENV GRADLE_HOME /opt/gradle
ENV GRADLE_VERSION 5.6
RUN curl -k -L -o gradle.zip "https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip" \
	&& echo "Installing Gradle" \
	&& unzip -q gradle.zip \
	&& rm gradle.zip \
	&& mkdir -p /opt \
	&& mv "gradle-${GRADLE_VERSION}" "${GRADLE_HOME}/" \
	&& ln -s "${GRADLE_HOME}/bin/gradle" /usr/bin/gradle 

COPY --from=0 /go/antibody/antibody  /usr/local/bin
USER ${CONT_USER}
WORKDIR /home/cybersiddhu 
ADD plugin.txt ${ZDOTDIR}
ADD zshrc ${ZDOTDIR}/.zshrc

## configure antibody
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

## setup vim
#RUN curl -fLo ${VIMDIR}/autoload/plug.vim --create-dirs \
	#https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim \
	#&& mkdir -p ${VIMDIR}/plugged \
	#&& git clone --branch feature/golang https://github.com/cybersiddhu/spf13-vim.git ${VIMDIR}/spf13 \
	#&& ln -sf ${VIMDIR}/spf13/.vimrc.before ${VIMDIR}/.vimrc.before \
	#&& ln -sf ${VIMDIR}/spf13/.vimrc ${VIMDIR}/.vimrc \
	#&& ln -sf ${VIMDIR}/spf13/.vimrc.bundles ${VIMDIR}/.vimrc.bundles \
	#&& ln -sf ${VIMDIR}/spf13/.vimrc.local ${VIMDIR}/.vimrc.local \
	#&& vim -E -s -u ${VIMDIR}/.vimrc +PlugInstall +qall \
    #&& echo  "call deoplete#custom#option('omni_patterns', { 'go': '[^. *\t]\.\w*' })" >> ${VIMDIR}/spf13/.vimrc.local

## configure zsh
ENV SHELL=/bin/zsh
ENTRYPOINT ["/bin/zsh","-i" ]
CMD ["-l"]
