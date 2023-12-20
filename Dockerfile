ARG NODE_TAG="lts-bullseye"
ARG USER_UID=1
ARG USER="node"
ARG GROUP="node"  # Add the missing GROUP argument
ARG PATH="1000"

FROM node:${NODE_TAG}
LABEL description="Node perfect Container"

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

USER root

# environment variables 
ENV DEBIAN_FRONTEND=noninteractive \
    SHELL=/bin/zsh \
    NODE_ENV=development \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8 \
    LC_ALL=en_US.UTF-8


# Update repository
RUN apt-get update --fix-missing


# necessary packages 
RUN apt-get -y install wget curl git zsh 

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


# zsh setup 
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" <<< $'\n'


RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen \
    && locale-gen

# Configure environment
ENV HOME=/home/${USER} \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8 \
    LC_ALL=en_US.UTF-8 \
    SHELL=/bin/zsh


# pnpm installation 

RUN wget -qO- https://get.pnpm.io/install.sh | sh - \
    && echo 'export PNPM_HOME="$HOME/.local/share/pnpm"' >> ~/.zshrc \
    && echo 'export PATH="$PNPM_HOME:$PATH"' >> ~/.zshrc \
    && source ~/.zshrc

RUN source ~./zshrc

# playwright installation 
RUN pnpm exec playwright install  

# Enable prompt color
RUN sed -i 's/^#force_color_prompt=yes/force_color_prompt=yes/' /etc/skel/.bashrc


# Create default user wtih name "node"
RUN groupadd -g ${USER_UID} ${GROUP} \
    && useradd -m -s /bin/zsh -u ${USER_UID} -g ${GROUP} ${USER} \
    && chmod g+w /etc/passwd

# Switch to user 
USER ${USER}
WORKDIR ${HOME}

# Configure container startup
CMD ["/bin/zsh"]
