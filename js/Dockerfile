# build antibody
FROM golang:1.17.2-alpine3.14 AS antibuilder
RUN apk add --no-cache git build-base \ 
    && mkdir -p /go \
    && cd /go \
    && git clone -b v6.1.1 --single-branch https://github.com/getantibody/antibody.git \
    && cd antibody \
    && go build -o antibody

# setup env
FROM node:16.13-alpine3.14
LABEL maintainer="Siddhartha Basu <siddhartha-basu@northwestern.edu>"
ARG CONT_USER=cybersiddhu
ARG UID=1000
ARG GID=1000
ARG HOME_BASE=/home
ENV HOME=/${HOME_BASE}/${CONT_USER}
ENV CUSTOMDIR=/custom
ENV XDG_CONFIG_HOME=${CUSTOMDIR}
ENV XDG_DATA_HOME=${XDG_CONFIG_HOME}
ENV ZDOTDIR=${CUSTOMDIR}/dotfiles/shell
ENV TMUXDIR=${CUSTOMDIR}/dotfiles/tmux
ENV NVIMDIR=${XDG_CONFIG_HOME}/nvim
ENV NVIM_LOG_FILE=${NVIMDIR}/log
ENV LANG=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8
ENV TERM=kitty
RUN echo "https://dl-cdn.alpinelinux.org/alpine/edge/main" > /etc/apk/repositories
RUN echo "https://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories
# install deps 
RUN  apk add --update build-base --no-cache \ 
       g++ make shadow curl unzip \
       zsh git htop gotop lazygit ncdu fzf \
       file ca-certificates bash gawk \ 
       gnupg exa fd rxvt-unicode-terminfo \ 
       ncurses-terminfo ripgrep ripgrep-zsh-completion \
       openssh-client tzdata \ 
       python2 python3 python3-dev py3-pip neovim neovim-doc \
     && npm install -g dockerfile-language-server-nodejs semantic-release \
        vscode-langservers-extracted graphql-language-service-cli \
	typescript typescript-language-server yaml-language-server \
     && cd $(mktemp -d) \
     && curl --fail --silent --location -o starship.tar.gz \
     	https://github.com/starship/starship/releases/download/v0.56.0/starship-aarch64-unknown-linux-musl.tar.gz \
     && tar xvzf starship.tar.gz -C /usr/local/bin  \
     && pip3 install --upgrade pynvim \
# setup user
    && groupadd -g ${GID} ${CONT_USER} \ 
    && useradd -u ${UID} -d ${HOME} -g ${CONT_USER} --system -m ${CONT_USER}  \
# OS setup
    && rm -fr /tmp/* /etc/apk/cache/* /var/cache/apk/* \ 
    && sed -i -e "s/bin\/ash/bin\/zsh/" /etc/passwd \
    && mkdir -p ${CUSTOMDIR}/starship ${ZDOTDIR}/antibody ${TMUXDIR} ${NVIMDIR} ${COCDIR}/extensions \ 
    && chown -R ${UID}:${GID} ${CUSTOMDIR} \
    && chown -R ${UID}:${GID} ${HOME} \
## timezone
    && cp /usr/share/zoneinfo/America/Chicago /etc/localtime \
    && echo "America/chicago" > /etc/timezone

# configure antibody and zsh plugins
COPY --from=antibuilder /go/antibody/antibody  /usr/local/bin
WORKDIR ${HOME} 
USER ${CONT_USER}
COPY plugin.txt ${ZDOTDIR}
COPY zshenv ${ZDOTDIR}/.zshenv
COPY zshrc ${ZDOTDIR}/.zshrc
ENV ANTIBODY_HOME=${ZDOTDIR}/antibody
RUN antibody bundle < ${ZDOTDIR}/plugin.txt > ${ZDOTDIR}/zsh_plugins.sh

# setup nvim
RUN git clone --depth=1 https://github.com/wbthomason/packer.nvim \
    ${NVIMDIR}/site/pack/packer/start/packer.nvim
COPY init.lua ${NVIMDIR}/init.lua
COPY lua ${NVIMDIR}/lua
RUN  nvim --headless -c "autocmd User PackerComplete quitall" -c "PackerSync" 
# install language parser for treesitter
ENV TREE_INSTALL_PATH=${NVIMDIR}/site/pack/packer/start/nvim-treesitter/parser
RUN mkdir -p ${TREE_INSTALL_PATH} \
# tsx and typescript parser install
    && cd $(mktemp -d) \
    && git clone https://github.com/tree-sitter/tree-sitter-typescript \
    && cd tree-sitter-typescript/typescript \
    && gcc -o ${TREE_INSTALL_PATH}/typescript.so -I./src src/parser.c src/scanner.c -shared -Os -lstdc++ \
    && cd ../tsx \
    && gcc -o ${TREE_INSTALL_PATH}/tsx.so -I./src src/parser.c src/scanner.c -shared -Os -lstdc++ \
    && cd ../../ \
    && rm -rf tree-sitter-typescript \
# javascript parser install
    && git clone https://github.com/tree-sitter/tree-sitter-javascript \
    && cd tree-sitter-javascript \
    && gcc -o ${TREE_INSTALL_PATH}/javascript.so -I./src src/parser.c src/scanner.c -shared -Os -lstdc++ \
    && cd ../ \
    && rm -rf tree-sitter-javascript \
# html parser install
#    && git clone https://github.com/tree-sitter/tree-sitter-html \
#    && cd tree-sitter-html \ 
#    && gcc -o ${TREE_INSTALL_PATH}/html.so -I./src src/parser.c src/scanner.cc -shared -Os -lstdc++ \
#    && cd ../ \
#    && rm -rf tree-sitter-html  \
# json parser install
    && git clone https://github.com/tree-sitter/tree-sitter-json \
    && cd tree-sitter-json \ 
    && gcc -o ${TREE_INSTALL_PATH}/json.so -I./src src/parser.c -shared -Os -lstdc++ \
    && cd ../ \
    && rm -rf tree-sitter-json \ 
# graphql parser install
    && git clone https://github.com/bkegley/tree-sitter-graphql \
    && cd tree-sitter-graphql \ 
    && gcc -o ${TREE_INSTALL_PATH}/graphql.so -I./src src/parser.c -shared -Os -lstdc++ \
    && cd ../ \
    && rm -rf tree-sitter-graphql \ 
# yaml parser install
    && git clone https://github.com/ikatyang/tree-sitter-yaml \
    && cd tree-sitter-yaml \ 
    && gcc -o ${TREE_INSTALL_PATH}/yaml.so -I./src src/parser.c src/scanner.cc -shared -Os -lstdc++ \
    && cd ../ \
    && rm -rf tree-sitter-yaml \ 
# dockerfile parser install
    && git clone https://github.com/camdencheek/tree-sitter-dockerfile \
    && cd tree-sitter-dockerfile \ 
    && gcc -o ${TREE_INSTALL_PATH}/dockerfile.so -I./src src/parser.c -shared -Os -lstdc++ \
    && cd ../ \
    && rm -rf tree-sitter-dockerfile 

COPY config.toml ${CUSTOMDIR}/starship/

# shell path 
ENV SHELL=/bin/zsh
ENTRYPOINT ["/bin/zsh","-i" ]
CMD ["-l"]
