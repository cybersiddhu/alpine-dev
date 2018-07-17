FROM golang:1.10.3-alpine3.7 
LABEL maintainer="Siddhartha Basu <siddhartha-basu@northwestern.edu>"
RUN apk add --no-cache git build-base \
	&& go get github.com/golang/dep/cmd/dep \
	&& mkdir -p /go/src/github.com \
	&& cd /go/src/github.com \
	&& git clone -b v3.5.1 --single-branch https://github.com/getantibody/antibody.git \
	&& cd antibody \
	&& dep ensure \
	&& go build -o antibody


FROM alpine:3.7
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
	&& apk add --no-cache zsh curl git file ca-certificates python tmux bash \ 
	&& rm -f /tmp/* /etc/apk/cache/* \ 
	&& sed -i -e "s/bin\/ash/bin\/zsh/" /etc/passwd \
	&& mkdir -p ${ZDOTDIR} ${TMUXDIR} \ 
	&& chown -R 1000:1000 ${CUSTOMDIR}
COPY --from=0 /go/src/github.com/antibody/antibody  /usr/local/bin
USER ${CONT_USER}
WORKDIR /home/cybersiddhu 
ADD plugin.txt ${ZDOTDIR}
ADD zshrc ${ZDOTDIR}/.zshrc
RUN antibody bundle < ${ZDOTDIR}/plugin.txt > ${ZDOTDIR}/zsh_plugins.sh
RUN antibody bundle robbyrussell/oh-my-zsh folder:plugins/git >> ${ZDOTDIR}/zsh_plugins.sh
RUN git clone https://github.com/tmux-plugins/tpm ${TMUXDIR}/plugins/tpm \
	&& git clone https://github.com/tmux-plugins/tmux-sensible ${TMUXDIR}/plugins/tmux-sensible \
	&& git clone https://github.com/tmux-plugins/tmux-pain-control ${TMUXDIR}/plugins/tmux-pain-control \
	&& git clone https://github.com/tmux-plugins/tmux-sidebar ${TMUXDIR}/plugins/tmux-sidebar
ADD tmux.conf ${TMUXDIR}/.tmux.conf
ENV SHELL=/bin/zsh
ENTRYPOINT ["/bin/zsh","-i" ]
CMD ["-l"]
