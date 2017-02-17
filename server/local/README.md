# Local Environment

## System dependencies

```
$ brew install libsass
$ brew install node
$ npm install -g bower
```

## Configuration

```
$ bundle install --path vendor/bundle --without=production
$ bundle exec rake bower:install
```

## Database creation

set up MariaDB

```
$ docker build -t ${image_name} ./server/local/docker/mariadb/
$ docker run -d --name ${container_name} -p 3306:3306 -e MYSQL_ROOT_PASSWORD=${root_password} \
    ${image_name} \
    --character-set-server=utf8mb4 \
    --collation-server=utf8mb4_unicode_ci \
    --innodb-file-format=Barracuda \
    --innodb-file-per-table=1 \
    --innodb-large-prefix=true
$ mysql -h localhost --port 3306 --protocol tcp -u root -p${root_password}
```

create user

```
mysql> CREATE USER '${username}'@'%' IDENTIFIED BY '${password}';
mysql> GRANT ALL PRIVILEGES ON *.* TO '${username}'@'%' WITH GRANT OPTION;
```

create scheme

```
mysql> CREATE DATABASE my100tales DEFAULT CHARSET utf8mb4;
```

create tables

```
$ DB_USERNAME=${username} DB_PASSWORD=${password} bundle exec rake db:migrate
```

## Database initialization

```
$ DB_USERNAME=[username] DB_PASSWORD=[password] bundle exec rake db:migrate:reset
```

## Key Value Store creation

```
$ docker build -t [image name] ./server/local/docker/redis/
$ docker run -d -p 6379:6379 --name [container name] [image name]
```

## Search engine creation

```
$ docker build -t [image name] ./server/local/docker/elasticsearch/
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

sorry for inadequate test code...

```
# use static code analysis before commit
$ rake rubocop
$ rake rubocop:auto_correct
$ rubocop --auto-gen-config # => make source code better!
$ rails_best_practices # => make source code better!
```

## Deployment instructions

```
$ cp .env_template .env
$ sed -i -e "s/DB_USERNAME=/DB_USERNAME=${username}/g" .env
$ sed -i -e "s/DB_PASSWORD=/DB_PASSWORD=${password}/g" .env
$ sed -i -e "s/REDIS_DB=/REDIS_DB=${db number}/g" .env
$ sed -i -e "s/SECRET_KEY_BASE=/SECRET_KEY_BASE=`bundle exec rake secret`/g" .env
$ rails s
```
