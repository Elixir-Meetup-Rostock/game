# Game

[![Test](https://github.com/Elixir-Meetup-Rostock/game/actions/workflows/test.yml/badge.svg)](https://github.com/Elixir-Meetup-Rostock/game/actions/workflows/test.yml)

## Goals

This game is an experiment by the [Elixir Meetup Rostock](https://github.com/Elixir-Meetup-Rostock).

We are building a multiplayer browser game with Elixir & LiveView and (on the way) learn as much as possible.

## MVP

- We have a closed map with objects like trees
- Players from two factions can run around the map
- Players of opposing teams can hit each other
- Players can hide behind objects to avoid being hit
- There is a counter with K/D ratio for the teams

## Status: Work in progress

- You start in a /lobby where you pick your name and jump into the game.
- The game itself is currently only about movement and displaying all connected players and their movement in realtime.
- From here we start building the game logic and develop the game further

## Setup

> 💡 This project uses [asdf](https://asdf-vm.com) to pin runtime versions for [Erlang](https://www.erlang.org) and [Elixir](https://elixir-lang.org). You'll need to set up asdf to contributing. Check its website and docs for instructions.

With `asdf` set up, install it with:

```
$ asdf install
```

Install dependencies:

```
$ mix deps.get
```

> 💡 To speed things up, compile everything upfront:
>
> ```
> $ mix do compile + assets.setup + assets.build
> ```

### Database

This project uses [PostgreSQL](https://www.postgresql.org) - there isn't much requirements for the version in use. Any version that's recent enough should do.

Set up the database with:

```
$ mix ecto.setup
```

> 💡 If you get any `Postgrex.Error` related to user permissions, `role "postgres" does not exist`, etc., it might be because your PostgreSQL server does not have a `postgres` user/role, or your database server might be somewhere else than `localhost`, etc. In any case, you can customize it through a `DATABASE_URL` environment variable with a `.env`.
>
> Check the `.env.sample` file for usage instructions.

## Run

With all set, run the project with:

```
$ mix phx.server
```

You can also start it with IEx (Elixir's REPL):

```
$ iex -S mix phx.server
```

You should be able to access it through [localhost:4000](http://localhost:4000).

> 💡 To start it with a REPL

## Contribute

We ecourage everyone to get in touch and contribute as much as you like.

You can find us on [Discord](https://discord.gg/CvcVcfKF).
