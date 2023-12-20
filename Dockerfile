ARG NODE_TAG="lts-bullseye"

FROM node:${NODE_TAG}
LABEL description="Node perfect Container" \
      maintainer="ashgw"
MAINTAINER ashgw
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

USER root

# environment variables 
ENV SHELL=/bin/zsh \
    NODE_ENV=development \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8 \
    LC_ALL=en_US.UTF-8


# Update repository
RUN apt-get update --fix-missing


# necessary packages 
RUN apt-get -y install wget curl git zsh sudo 

#playwright dependencies for GUI workings 
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends \
    gconf-service libxext6 libxfixes3 libxi6 libxrandr2 \
    libxrender1 libcairo2 libcups2 libdbus-1-3 libexpat1 \
    libfontconfig1 libgcc1 libgconf-2-4 libgdk-pixbuf2.0-0 \
    libglib2.0-0 libgtk-3-0 libnspr4 libpango-1.0-0 libpangocairo-1.0-0 \
    libstdc++6 libx11-6 libx11-xcb1 libxcb1 libxcomposite1 libxcursor1 \
    libxdamage1 libxss1 libxtst6 libappindicator1 libnss3 libasound2 \
    libatk1.0-0 libc6 libdrm-dev libgbm-dev ca-certificates fonts-liberation lsb-release xdg-utils

# user setup

ENV HOME=/home/ashx\
    USER=ashx \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8 \
    LC_ALL=en_US.UTF-8 
    
RUN useradd -rm -d /home/${USER} -s /bin/bash -g root -G sudo -u 1001 ${USER} && chmod 0440 /etc/sudoers.d/$USERNAME
RUN echo 'ashx ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/${USER}-nopasswd
USER ${USER} 
WORKDIR /home/${USER}
RUN echo ${USER}
RUN echo $USERNAME
RUN echo ${USER_UID}

# zsh setup 
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" <<< $'\n'

# Configure environment



# pnpm installation 

# Install pnpm
RUN wget -qO- https://get.pnpm.io/install.sh | sh -

# Update the PATH in the ~/.zshrc
RUN echo '# pnpm' >> ~/.zshrc \
    && echo 'export PNPM_HOME="$HOME/.local/share/pnpm"' >> ~/.zshrc \
    && echo 'case ":$PATH:" in' >> ~/.zshrc \
    && echo '  *":$PNPM_HOME:"*) ;;' >> ~/.zshrc \
    && echo '  *) export PATH="$PNPM_HOME:$PATH" ;;' >> ~/.zshrc \
    && echo 'esac' >> ~/.zshrc


# Add alias configurations to the .zshrc file
RUN echo 'alias \
    c="clear" \
    ka="killall" \
    sdn="shutdown -h now" \
    e="$EDITOR" \
    a="apt-get" \
    i="sudo apt-get install" \
    g="git" \
    v="nvim" \
    ts="pnpm ts-node" \
    t="touch" \
    reload=". ~/.zshrc" \
    y="rm -rf" \
    b="cd .."  \
    bb="cd ..."   \
    bbb="cd ...."   \
    bbbb="cd ....."  \
    bbbbb="cd ....." \
    x="chmod +x" \
    ls="ls -hN --color=auto --group-directories-first" \
    grep="grep --color=auto" \
    diff="diff --color=auto" \
    ccat="highlight --out-format=ansi" \
    ip="ip -color=auto" \
    ' >> ~/.zshrc



RUN source ~/.zshrc

# playwright installation 
# you can install playwright with pnpm by running 
# pnpm exec playwright install  

# set default user shell
ENV SHELL=/bin/zsh

# Configure container startup
# CMD ["/bin/zsh"]
RUN . $HOME/.zshrc
#ENTRYPOINT [ "/bin/zsh" ]
CMD ["zsh", "-c", "sleep infinity"]