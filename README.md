## My 100 Tales

This application manages your inspirations by save, edit, search.
So, my100tales grows your ideas in order to make dreams come true.

## Ruby version

## System dependencies

```
$ brew install node
$ npm install -g bower
# $ brew install graphviz
```

## Configuration

```
$ bundle install --path vendor/bundle --without=production
$ bundle exec rake bower:install
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

```
$ DB_USERNAME=[username] DB_PASSWORD=[password] bundle exec rake db:migrate:reset
```

## Search engine creation

```
$ docker build -t [image name] ./docker/elasticsearch/
$ docker run -d -p 9200:9200 -p 9300:9300 --name [container name] [image name]
```

## Search engine initialization

```
$ DB_USERNAME=[username] DB_PASSWORD=[password] bundle exec rake elasticsearch:create_index
```

## Assets initialization

```
$ bundle exec rake emoji
```

## How to run the test suite

```
$ rake rubocop
$ rake rubocop:auto_correct
$ rubocop --auto-gen-config # => make source code better!
```

## Services (job queues, cache servers, search engines, etc.)

- MariaDB
- Redis

## Deployment instructions

```
$ DB_USERNAME=[username] DB_PASSWORD=[password] REDIS_DB=[db number] rails s
```

