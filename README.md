# Elm Starter

A simple sample for getting started with Elm or the simplest project starter ever.

All it does it produce an text input for making a list of stuff, even more stripped down than [TodoMVC](https://github.com/evancz/elm-todomvc), which is a bit difficult to parse for beginners who learn best by example. It also demonstrates how to use Elm modules, which TodoMVC doesn't.

It also shows how to build the CRUD operations and use various Elm features incrementally. Just follow along with the tags and commits, starting at the first commit, which has working functionality to create todos.

## Getting Started

This assumes you have Elm installed. Just clone the repo and run `./build`.

If you want to use the provided `watch` script, it depends on `fswatch`.

    brew install fswatch

## Using http-server

[Elm Reactor](https://github.com/elm-lang/elm-reactor), typically recommended for beginners, isn't fully featured yet. It doesn't let you use your own HTML or CSS to style the output easily, so it's not a good proxy for understanding how an Elm project might work. I recommend using a really simple HTTP server instead, like `http-server`.

    npm install -g http-server
    cd dist
    http-server

This will give you a better idea of how an Elm project can be structured. It's also worth noting that all Elm code is compiled into a single file, `dist/scripts/app.js`, and thus Elm doesn't require its own special server.

## Dependencies

- [Skeleton CSS](https://getskeletcom.com)
- [Elm](http://elm-lang.org/)
- [Elm HTML](http://package.elm-lang.org/packages/elm-lang/html/latest)
