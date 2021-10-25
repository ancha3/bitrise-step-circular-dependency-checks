#!/bin/bash
set -ex

THIS_SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

if [[ ! -d $THIS_SCRIPT_DIR/node_modules/madge ]]
then
    echo "Error: madge library not installed"
    npm install --prefix $THIS_SCRIPT_DIR madge --save
fi

RESULTS=$($THIS_SCRIPT_DIR/checkCircularDependency.js "${dir_path}" "${ts_config_path}")

TOTAL_CIRCULAR_DEPENDENCIES_COUNT=0
for i in ${RESULTS//,/ }
do
  echo "$i" >> list_circular_dependencies.txt
  TOTAL_CIRCULAR_DEPENDENCIES_COUNT=`expr $TOTAL_CIRCULAR_DEPENDENCIES_COUNT + 1`
done


echo "---- REPORT ----"

if [ ! -f "quality_report.txt" ]; then
    printf "QUALITY REPORT\n\n\n" > quality_report.txt
fi

printf ">>>>>>>>>>  CURRENT TAGGED FILES  <<<<<<<<<<\n" >> quality_report.txt
printf "Directory path: $dir_path \n" >> quality_report.txt
printf "TS Config file path: $ts_config_path \n" >> quality_report.txt
printf "Total Circular dependencies count threshold: $circular_dep_count_threshold \n" >> quality_report.txt
printf "Total Circular dependencies detected: $TOTAL_CIRCULAR_DEPENDENCIES_COUNT \n" >> quality_report.txt
printf "You can see list of circular dependencies in list_circular_dependencies.txt \n\n" >> quality_report.txt

envman add --key TOTAL_CIRCULAR_DEPENDENCIES_COUNT --value $TOTAL_CIRCULAR_DEPENDENCIES_COUNT

if [ $TOTAL_CIRCULAR_DEPENDENCIES_COUNT -gt $circular_dep_count_threshold ]; then
    echo "ERROR: New circular depedncies have been detected"
    exit 1
fi
exit 0