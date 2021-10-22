#!/bin/bash
set -ex

THIS_SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

if [[ ! -d $THIS_SCRIPT_DIR/node_modules/madge ]]
then
    npm install --prefix $THIS_SCRIPT_DIR madge --save
fi

RESULTS=$($THIS_SCRIPT_DIR/checkCircularDependency.js "${dir_path}" "${ts_config_path}")

for i in ${RESULTS//,/ }
do
  echo "$i" >> text.txt
done
