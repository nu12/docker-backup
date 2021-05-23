# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

```shell

$ docker volume create --opt type=none --opt o=bind --opt device=~/backup docker-backup
$ docker run --rm -p 3000:3000 -v docker-backup:/backup -v /var/run/docker.sock:/var/run/docker.sock docker-backup
```

* ...
