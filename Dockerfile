# Start from a base image for elixir
# Phoenix works best on pre 1.7 at the moment.
FROM elixir:1.10.2-alpine

# Set up Elixir and Phoenix
ARG APP_NAME=billing-api
ARG PHOENIX_SUBDIR=.
ENV MIX_ENV=prod REPLACE_OS_VARS=true TERM=xterm
WORKDIR /opt/app

# Update nodejs, rebar, and hex.
RUN apk update \
    && mix local.rebar --force \
    && mix local.hex --force
COPY . .

# Download and compile dependencies, then compile Web app.
RUN mix do deps.get, deps.compile, compile
# Create a release version of the application
RUN mix release --env=prod --verbose \
    && mv _build/prod/rel/${APP_NAME} /opt/release \
    && mv /opt/release/bin/${APP_NAME} /opt/release/bin/start_server

# Prepare final layer
FROM alpine:latest
RUN apk update && apk --no-cache --update add bash openssl-dev ca-certificates

# Add a user so the server will run as a non-root user.
RUN addgroup -g 1000 appuser && \
    adduser -S -u 1000 -G appuser appuser
# Pre-create necessary temp directory for erlang and set permissions.
RUN mkdir -p /opt/app/var
RUN chown appuser /opt/app/var
# Run everything else as 'appuser'
USER appuser

ENV MIX_ENV=prod REPLACE_OS_VARS=true
WORKDIR /opt/app
COPY --from=0 /opt/release .
ENV RUNNER_LOG_DIR /var/log

# Command to execute the application.
CMD ["/opt/app/bin/start_server", "foreground", "boot_var=/tmp"]