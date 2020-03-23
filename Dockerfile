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
COPY ./_build/dev/rel/mspr_billing_api /opt/app
COPY ./_build/dev/rel/mspr_billing_api/bin/mspr_billing_api /opt/app/bin/start_server
ENV RUNNER_LOG_DIR /var/log

# Command to execute the application.
CMD ["/opt/app/bin/start_server", "foreground", "boot_var=/tmp"]