#!/bin/bash
read -p "Enter filter1 : " log1


tail -f replaceme | grep  "$log1"

