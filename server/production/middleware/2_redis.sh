#!/bin/bash

su

yum install redis

systemctl start redis.service
systemctl enable redis.service

# => check by 'redis-cli ping'
