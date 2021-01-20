# S76

## To develop (with iex)

```
docker-compose up -d db
docker-compose run -p 4000:4000 api bash
> mix ecto.setup
> iex -S mix phx.server
```

## To Run

```
docker-compose up -d
```

## Data Model

### Repository

Representation of the actual repository
has:

- owner: string
- name: string
  ... timestamps

### Stargazer

Representation of the return objects from the repository's stargazer_url. Basically each row is a User + Repository joining event

has:

- repository_id: ID
- github_id: integer
- username: string
  ... timestamps

> I chose not to create a User table because there were no other use cases aside from Stargazer. If we needed to have relationships to anything besides repositories, or maybe list all repositories that a specific user has starred, Stargazer would only be a join table for User and Repository, potentially with an additional field like `starred_at` to track when the user starred the repo.

## API

I'll document the apis required for the challenge, but all the CRUD operations for repositories are supported as you'd expect.

```
Create repository to track
POST /api/repositories
request
{
  "repository": {
    "name": "dotfiles",
    "owner": "zakjholt"
  }
}
response 201
{
  "data": {
    "id": <id>,
    "name": "dotfiles",
    "owner": "zakjholt"
  }
}

Fetch repositories
GET /api/repositories (list of repos)

Fetch repository
GET /api/repositories/<repo_id> (single repo)

Fetch repository with stargazers
GET /api/repositories/<repo_id>/stargazers (sends back repo with stargazers list in `stargazers` key)

Fetch repository with old/new distribution of stargazers
GET /api/repositories/<repo_id>/stargazers?start_date=YYYY-MM-DD (sends back `old_stargazers` and `new_stargazers` keys)
```

## Scheduling

I've added [Quantum](https://github.com/quantum-elixir/quantum-core) to the deps for this project. It's a Sidekiq-esque job queing lib that's great for handling background procs. As Elixir spins up everythin in child processes, the Quantum background jobs are just another sub-tree. This is what handles the daily backfill for stargazers.

## What I would improve with time

1. Change the 2 db queries for old_stargazers/new_stargazers to be a single group_by query
2. Rethink the api routes. /api/repositories/<repo_id>/stargazers in particular is a bit weird to me I think
3. Add error handling/better date parsing to the start_date param

## Boilerplate

To start your Phoenix server:

- Install dependencies with `mix deps.get`
- Create and migrate your database with `mix ecto.setup`
- Install Node.js dependencies with `npm install` inside the `assets` directory
- Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

- Official website: https://www.phoenixframework.org/
- Guides: https://hexdocs.pm/phoenix/overview.html
- Docs: https://hexdocs.pm/phoenix
- Forum: https://elixirforum.com/c/phoenix-forum
- Source: https://github.com/phoenixframework/phoenix
