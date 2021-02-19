# URL Shortener README

* Ruby version
2.7

## System dependencies
Docker

## Local Development
First we want to setup the database in our docker container.
* `docker-compose run web rails db:setup`

Finally to run the application.
* `docker-compose up`

Our application is exposed on `localhost:3000` with a user with the following credentials:
* __username__: test
* __password__: test

## How to run the test suite
* `docker-compose run web rspec`
