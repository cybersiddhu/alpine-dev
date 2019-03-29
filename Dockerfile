## build antibody
FROM golang:1.11.6-alpine3.9 
LABEL maintainer="Siddhartha Basu <siddhartha-basu@northwestern.edu>"
RUN apk add --no-cache git build-base \
	&& mkdir -p /go \
	&& cd /go \
	&& git clone -b v4.1.1 --single-branch https://github.com/getantibody/antibody.git \
	&& cd antibody \
	&& go get -v ./... \
	&& go build -o antibody


## setup OS
FROM alpine:3.9
LABEL maintainer="Siddhartha Basu<biosidd@gmail.com>" 
ARG CONT_USER=cybersiddhu
ENV CUSTOMDIR=/custom
ENV ZDOTDIR=${CUSTOMDIR}/dotfiles/shell
ENV TMUXDIR=${CUSTOMDIR}/dotfiles/tmux
ENV LANG=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8
ENV TERM=screen
RUN addgroup -g 1000 -S ${CONT_USER} \ 
	&& adduser -u 1000 -S -G ${CONT_USER} ${CONT_USER} \
	&& apk update \ 
	&& apk add --no-cache zsh curl git file ca-certificates python python3 python3-dev tmux bash vim gawk \ 
	&& rm -f /tmp/* /etc/apk/cache/* \ 
	&& sed -i -e "s/bin\/ash/bin\/zsh/" /etc/passwd \
	&& mkdir -p ${ZDOTDIR}/antibody ${TMUXDIR} \ 
	&& chown -R 1000:1000 ${CUSTOMDIR}
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
	&& git clone https://github.com/tmux-plugins/tmux-fpp ${TMUXDIR}/plugins/tmux-fpp
ADD tmux.conf ${TMUXDIR}/.tmux.conf
ENV TMUX_PLUGIN_MANAGER_PATH=${TMUXDIR}/plugins

## configure zsh
ENV SHELL=/bin/zsh
ENTRYPOINT ["/bin/zsh","-i" ]
CMD ["-l"]
