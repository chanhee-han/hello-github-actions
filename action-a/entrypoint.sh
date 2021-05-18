#!/bin/sh -l

sh -c "echo Hello world my name is $INPUT_MY_NAME"
time=$(date)
echo "::set-output name=time::$time"