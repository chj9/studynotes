#!/bin/bash
IFS=$'\n'
for each in $(kubectl get pods -A | grep Completed|awk '{print $1,$2}');
do
  eval `echo $each | awk '{printf("namespace=%s; pod=%s", $1, $2)}'`
  kubectl delete pods $pod -n $namespace  --grace-period=0 --force
done
