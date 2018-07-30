#!/bin/bash

#Usage : sh deploy <AWS_ACCESS_KEY_ID> <AWS_SECRET_ACCESS_KEY>

sh deploy-eu.sh $1 $2
sh deploy-us.sh $1 $2
