## Overview

This Docker image is made for use in a development environment, particularly with **[devcontainers](https://containers.dev/)**.
If you're on GitHub, you can try it out by clicking the `<> code` dropdown, then selecting `codespaces`, and finally choosing `create code space of main`.


The container runs with `ZSH` and comes pre-installed with `nvm`, `npm`, `yarn`, and `pnpm`, along with some basic development packages 
such as `git`, `curl`, `wget`, and `neovim`. It also includes graphical support for browsers used with test runners like Playwright and Selenium, 
for smooth rendering on the host machine without distortions.

## Usage
Update your `devcontainer.json` file as follows:

```json
{
    "name": "Node.js & TypeScript",
    "image": "ashgw/node:latest",
    "runArgs": [
        "-e",
        "DISPLAY=host.docker.internal:0",
        "-v",
        "/tmp/.X11-unix:/tmp/.X11-unix"
    ]
}
```
#### Display Configuration
> Make sure X11 is properly configured on the host machine. Set the DISPLAY environment variable to allow GUIS in the container to connect to the host's X server.

## License 
[GPL-3.0](https://github.com/AshGw/oauth2_utils/blob/main/LICENSE)