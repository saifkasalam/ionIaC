#!/bin/bash
read -p "Enter Tc-Code : " value1
md5sum configfiles/* > "$value1".chk
