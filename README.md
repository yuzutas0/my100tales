## My 100 Tales

This application manages your inspirations by save, edit, search.

Tapir is called "Baku" in Japan, and thought as the animal which eats dream.
So, my100tales grows your inspirations in order to make dreams come true.

## Ruby version

## System dependencies

## Configuration

```
$ bundle install --path vendor/bundle --without=production
```

## Database creation

after set up MySQL / MariaDB

create user

```
mysql> CREATE USER 'username'@'%' IDENTIFIED BY 'password';
mysql> GRANT ALL PRIVILEGES ON *.* TO 'username'@'%' WITH GRANT OPTION;
```

create scheme

```
mysql> CREATE DATABASE my100tales;
```

create tables

```
$ DB_USERNAME=[username] DB_PASSWORD=[password] bundle exec rake db:migrate
```

## Database initialization

## How to run the test suite

```
$ rake rubocop
$ rake rubocop:auto_correct
$ rubocop --auto-gen-config # => make source code better!
```

## Services (job queues, cache servers, search engines, etc.)

## Deployment instructions

