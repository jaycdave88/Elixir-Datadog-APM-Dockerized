FROM bitwalker/alpine-elixir-phoenix

RUN apk add git
RUN mix local.hex --force && mix local.rebar --force

WORKDIR /app

COPY . /app

RUN mix deps.get
RUN npm install

EXPOSE 4000