#!/bin/bash

DSN=$1
SES=$2
PASSES=$3
RULES=$4

java -jar freerouting.jar -de $DSN -do $SES -mp $PASSES -dr $RULES

# Pcbnew -> alt+f -> i -> enter