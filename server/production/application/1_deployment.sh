#!/bin/bash

# deploy
bundle exec cap production deploy --trace

# restart
bundle exec cap production unicorn:re_start

# stop
bundle exec cap production unicorn:stop

# force stop at remote server
ps -ef | grep unicorn | grep master | awk '{ print $2 }' | xargs kill -QUIT
