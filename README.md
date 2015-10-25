## The Movies Example Application

A very simple web application using [Neo4j](http://neo4j.com/developer/get-started/) with [Elixir](http://elixir-lang.org), [Phoenix](http://www.phoenixframework.org) and [Neo4j.Sips(β)](https://github.com/florinpatrascu/neo4j_sips).

### The Stack

These are the components of our Web Application:

- Application Type: An [Elixir](http://elixir-lang.org) [Phoenix](http://www.phoenixframework.org) web application
- Web framework: [Phoenix](http://www.phoenixframework.org)
- Persistence Access: [Neo4j.Sips(β)](https://github.com/florinpatrascu/neo4j_sips)
- Database: [Neo4j](http://neo4j.com/developer/get-started/) Server
- Frontend: jquery, bootstrap

### Prerequisites

- a local (or remote) Neo4j graph dayabase server 
- the demo Movie Database

### Install

    $ git clone https://github.com/florinpatrascu/movies_elixir_phoenix
    $ cd movies_elixir_phoenix
    $ mix do deps.get, deps.compile


### Run

Start the Phoenix server:

    $ cd movies_elixir_phoenix
    $ mix phoenix.server

Point your browser to: `http://localhost:4000`, and you'll something like this:

![](web/static/elixir_movies_demo.png)

Oh, oh, and some **endpoints**, of course :)


    # JSON object for single movie with cast
    $ curl -H "Accept:application/json" \
      http://localhost:4000/movies/findByTitle?title=The%20Matrix

    # list of JSON objects for movie search results
    $ curl -H "Accept:application/json" \
      http://localhost:4000/movies/findByTitleContaining?title=matrix


### Credits

- using most of the UI from: [neo4j-examples/movies-java-spring-data-neo4j-4](https://github.com/neo4j-examples/movies-java-spring-data-neo4j-4). Thank you!

### License

MIT

