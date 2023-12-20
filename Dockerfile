ARG NODE_TAG="lts-bullseye"

FROM node:${NODE_TAG}
LABEL description="Node perfect Container" 
MAINTAINER ashgw
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

USER root

# Update repository
RUN apt-get update --fix-missing

# necessary packages 
RUN apt-get -y install wget curl git zsh sudo neovim

#playwright dependencies for the graphical interface from within the container 
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends \
    gconf-service \
    libxext6 \
    libxfixes3 \
    libxi6 \
    libxrandr2 \
    libxrender1 \
    libcairo2 \
    libcups2 \
    libdbus-1-3 \
    libexpat1 \
    libfontconfig1 \
    libgcc1 \
    libgconf-2-4 \
    libgdk-pixbuf2.0-0 \
    libglib2.0-0 \
    libgtk-3-0 \
    libnspr4 \
    libpango-1.0-0 \
    libpangocairo-1.0-0 \
    libstdc++6 \
    libx11-6 \
    libx11-xcb1 \
    libxcb1 \
    libxcomposite1 \
    libxcursor1 \
    libxdamage1 \
    libxss1 \
    libxtst6 \
    libappindicator1 \
    libnss3 \
    libasound2 \
    libatk1.0-0 \
    libc6 \
    libdrm-dev \
    libgbm-dev \
    ca-certificates \
    fonts-liberation \
    lsb-release \
    xdg-utils

# user setup
ENV HOME=/home/ashx\
    SHELL=/bin/zsh \
    NODE_ENV=development \
    USER=ashx \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8 \
    LC_ALL=en_US.UTF-8 
    
# for passwordless sudo 
RUN useradd -rm -d /home/${USER} -s /bin/bash -g root -G sudo -u 1001 ${USER} && chmod 0440 /etc/sudoers.d/$USERNAME
RUN echo "$USER ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/${USER}-nopasswd

# change the the user 
USER ${USER} 
WORKDIR /home/${USER}
RUN echo ${USER}

# Install pnpm
RUN wget -qO- https://get.pnpm.io/install.sh | sh -


# zsh setup 
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" <<< $'\n'

# Update the PATH in the ~/.zshrc
RUN echo '# pnpm' >> ~/.zshrc \
    && echo 'export PNPM_HOME="$HOME/.local/share/pnpm"' >> ~/.zshrc \
    && echo 'case ":$PATH:" in' >> ~/.zshrc \
    && echo '  *":$PNPM_HOME:"*) ;;' >> ~/.zshrc \
    && echo '  *) export PATH="$PNPM_HOME:$PATH" ;;' >> ~/.zshrc \
    && echo 'esac' >> ~/.zshrc

# Add alias confs to the .zshrc file
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


# source the zshell 
RUN source. ~/.zshrc


# Configure container startup
# CMD ["/bin/zsh"]

#ENTRYPOINT [ "/bin/zsh" ]
CMD ["zsh", "-c", "sleep infinity"]