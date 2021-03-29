# docker run -it --rm --name gitlab --privileged -p 8080:80 -p 8443:443 -p 2222:22 gitlab-pi:dev

FROM arm64v8/ubuntu:20.04

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y curl openssh-server ca-certificates tzdata perl nano && \
    apt-get -y upgrade

RUN mkdir -p /gitlab

WORKDIR /gitlab

RUN curl https://packages.gitlab.com/install/repositories/gitlab/gitlab-ce/script.deb.sh | bash

RUN apt-get install -y gitlab-ce

EXPOSE 22 443 80

RUN sed -i "s/# grafana\['enable'\] = true/grafana['enable'] = false/g" /etc/gitlab/gitlab.rb

ENTRYPOINT (/opt/gitlab/embedded/bin/runsvdir-start &) && \
    gitlab-ctl reconfigure && \
    tail -f /dev/null