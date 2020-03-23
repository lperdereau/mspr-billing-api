FROM elixir:latest

# Create app directory and copy the Elixir projects into it
RUN mkdir /app
COPY . /app
WORKDIR /app

# Install hex package manager
# By using --force, we don’t need to type “Y” to confirm the installation
RUN mix local.hex --force

ARG MIX_ENV=prod

# Compile the project
RUN mix deps.get &&\
    export SECRET_KEY_BASE=$(mix phx.gen.secret) &&\
    mix compile

CMD ["MIX_ENV=prod", "mix", "phx.server"]