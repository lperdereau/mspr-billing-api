# Prepare final layer
FROM debian:buster
RUN apt update && apt install -y bash ca-certificates locales

RUN export LANG=en_US.UTF-8 \
    && echo $LANG UTF-8 > /etc/locale.gen \
    && locale-gen \
    && update-locale LANG=$LANG

# Pre-create necessary temp directory for erlang and set permissions.
RUN mkdir -p /opt/app/var
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8
ENV MIX_ENV prod
WORKDIR /opt/app
COPY ./build/ ./
ENV RUNNER_LOG_DIR /var/log

EXPOSE 4000
# Command to execute the application.
CMD ["/opt/app/bin/app", "start"]