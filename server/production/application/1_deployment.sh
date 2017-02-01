#!/bin/bash

bundle exec cap production deploy --trace

bundle exec cap production unicorn:restart

bundle exec cap production unicorn:stop
