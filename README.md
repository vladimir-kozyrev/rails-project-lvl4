Hexlet tests and linter status
==============================
[![Actions Status](https://github.com/vladimir-kozyrev/rails-project-lvl4/workflows/hexlet-check/badge.svg)](https://github.com/vladimir-kozyrev/rails-project-lvl4/actions)
[![Actions Status](https://github.com/vladimir-kozyrev/rails-project-lvl4/workflows/rails/badge.svg)](https://github.com/vladimir-kozyrev/rails-project-lvl4/actions)

About
=====
A service where teams can track the quality of their public repositories. Repositories are connected to the project, which are then checked through the github check mechanism https://docs.github.com/en/rest/reference/checks). The result is displayed both in the github interface and on the service itself.

Example
=======
https://hexlet-project-lvl4.herokuapp.com/

Ruby version
============
3.0.2

Available Makefile commands
===========================
Setup the application.
```
make setup
```

Run the application.
```
make start
```

Run tests.
```
make test
```

Run linters.
```
make lint
```

Run tests and linters.
```
make check
```

Drop the database and prepare it for local development.
```
make reset-db
```
