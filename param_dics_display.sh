#!/bin/bash
path=$(pwd)
ns3_path=$path
ns3_version=3.36.1
user_program_name=wireless_adhoc_network.cc
file=$ns3_path/ns-allinone-$ns3_version/ns-$ns3_version/scratch/$user_program_name
while IFS= read -r line; do
  if [[ "$line" == *"pv_atsa "* ]]; then
    printf '%s\n' "$line"
  fi
done < $file
