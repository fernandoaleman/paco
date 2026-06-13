# vim: set ft=zsh:
# DOCKER_HOST points to podman's user socket so lazydocker and other
# Docker-API clients (docker CLI, docker-compose, etc.) talk to podman
# instead of looking for a Docker daemon at /var/run/docker.sock.
#
# The socket itself is enabled by install/config/podman-socket.sh via
# `systemctl --user enable --now podman.socket`.
export DOCKER_HOST="unix:///run/user/${UID}/podman/podman.sock"
