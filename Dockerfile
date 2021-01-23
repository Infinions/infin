FROM bitwalker/alpine-elixir-phoenix:latest

ARG SECRET_KEY_BASE
ENV SECRET_KEY_BASE=$SECRET_KEY_BASE

ENV MIX_ENV=prod

ADD mix.exs mix.lock ./
RUN mix do deps.get, deps.compile

ADD assets/package.json assets/

RUN cd assets && \
    npm install

ADD . .
RUN echo "ANALYTICS_URL=https://infin.di.uminho.pt/graphql" >> assets/.env

RUN cd assets/ && \
    npm run deploy && \
    cd - && \
    mix do compile, phx.digest

USER default

ENTRYPOINT ["/opt/app/docker-entrypoint.sh"]
