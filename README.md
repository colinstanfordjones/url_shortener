# URL Shortener README

## System dependencies

* Docker
* Ruby version 2.7

## Local Development

First we want to setup the database in our docker container.

* `docker-compose run web rails db:setup`

Finally to run the application.

* `docker-compose up`

Our application is exposed on `localhost:3000` and has endpoints for user authentication and url management namespaced in `/api`. The service handling the slug is `localhost:3000/<SLUG>`

### Notes on user management
I decided to use JWT as the method for session management due to its ease of use with an API.

This is built using the `devise-jwt` library as this has the most community support and robust feature set. There are full controller integration tests for handing user creation, signing in and signing off.

`User` is fairly barebones. Its main purpose is handling authentication and is used to build associated urls. This is built to prevent unauthorized requests from modifying a URL.

### Create a user

* curl -v -X POST -H "Content-Type: application/json" -d '{"user": {"email": "test@example.com", "password": "test"}}' localhost:3000/api/signup`

### Login as user

* curl -v -X POST -H "Content-Type: application/json" -d '{"user": {"email": "test@example.com", "password": "test"}}' localhost:3000/api/login`

Your output should looks like this:

```console
geronimo@geronimo url_shortener % curl -X POST -v -H "Content-Type: application/json" -d '{"user": {"email": "test@example.com", "password": "test"}}' localhost:3000/api/signup
Note: Unnecessary use of -X or --request, POST is already inferred.
*   Trying ::1...
* TCP_NODELAY set
* Connected to localhost (::1) port 3000 (#0)
> POST /api/signup HTTP/1.1
> Host: localhost:3000
> User-Agent: curl/7.64.1
> Accept: */*
> Content-Type: application/json
> Content-Length: 60
> 
* upload completely sent off: 60 out of 60 bytes
< HTTP/1.1 200 OK
< X-Frame-Options: SAMEORIGIN
< X-XSS-Protection: 1; mode=block
< X-Content-Type-Options: nosniff
< X-Download-Options: noopen
< X-Permitted-Cross-Domain-Policies: none
< Referrer-Policy: strict-origin-when-cross-origin
< Content-Type: application/json; charset=utf-8
< Authorization: Bearer eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiIzIiwic2NwIjoidXNlciIsImF1ZCI6bnVsbCwiaWF0IjoxNjEzNzAxMzk4LCJleHAiOjE2MTM3MDMxOTgsImp0aSI6IjU4MTFjM2MyLTRjMmMtNDVhNi05MjY3LTFiMWQzYjY5YTI3YiJ9._mCr_v31VMYUt32Y2J5tSKFChrAmTtL20ZI4xdqJNlA
< ETag: W/"262b3eb320bbbfeaf3e0eb364fa9a36b"
< Cache-Control: max-age=0, private, must-revalidate
< X-Request-Id: 8ae57e94-3864-49e6-82d1-9c109f8d7800
< X-Runtime: 0.315345
< Vary: Origin
< Transfer-Encoding: chunked
< 
* Connection #0 to host localhost left intact
{"user":{"id":1,"email":"test@example.com"}}* Closing connection 0
```

Take note of the header contents containing:

* `Authorization: Bearer <XXXXXXXXX>`

This is will be your authorization token.

### Create URL requests

* `curl -v -X POST -H "Content-Type: application/json" -H "Authorization: Bearer <AUTHORIZATION TOKEN>" -d <JSON> localhost:3000/api/urls`
* JSON format of `{"url": {"endpoint": "https://example.com", (OPTIONAL)"slug": "<SLUG>", (OPTIONAL)"expiration": "2021-02-21T22:01:01" } }`
  * `endpoint` must be a URL with valid encoding.
  * `slug` is the desired path, and must be URL safe characters. If not specified a random string will be generated. The namespace of `api` is reserved for obvious reasons.
  * `expiration` is a datetime string of the desired expiration. If not specified, the URL will last indefinitely.
* Successful return format `{"url": {"id": <X>, "endpoint": <ENDPOINT>, "slug": <SLUG>, "expiration": <EXPIRATION>}}`
* Error return format `{"errors": {"<FIELD>": "<REASON>"}}`

### Destroy URL requests

* `curl -v -X DELETE -H "Content-Type: application/json" -H "Authorization: Bearer <AUTHORIZATION TOKEN>" localhost:3000/api/urls/<ID>`
* Successful return format `{"success": true}`

### Using slug endpoints

* `localhost:3000/<SLUG>`

### Notes on URL service

Best practices for MVC applications tend to be:

* Controllers are to dispatch methods to the model and encapsulating returned values. Minimal logic should be contained in these methods.
* Models handle all business logic and any statefull operation.
* Views normalize data returned to the client.
* Most persistent objects, if not a state machine, can be described with RESTful methods for the lifecycle.

Keeping with this ethos, these are following classes for this service.

* `app/controllers/api/url_controller.rb` Methods describing the REST endpoints of `Url` and firing methods defined in:
* `app/models/urls.rb` Instances belong to a user, and ensures only this user may alter the object.
* `app/controller/slug_controller.rb` Defines the slug routing method for redirecting to a URL, if valid, or rendering a `404`.

Routes are pretty straightforward. We define the URL resources namespaced in `api`, and have a catchall `match` routing to `slug_controller`.

## How to run the test suite

* `docker-compose run web rspec`

Tests are writen using rspec. No paticular reason for choosing it expect for familiarity. The goal is to have fairly complete test coverage on all endpoints and ensure all use cases of the application are accounted for.
