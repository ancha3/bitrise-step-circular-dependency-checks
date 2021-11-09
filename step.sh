#!/bin/bash
set -ex

THIS_SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

if [[ ! -d $THIS_SCRIPT_DIR/node_modules/madge ]]
then
    echo "Error: madge library not installed"
    npm install --prefix $THIS_SCRIPT_DIR madge --save
fi

if [[ ! -f ${dir_path} ]]
then
    echo "Error: ${dir_path} does not exist"
    exit 1
fi

if [[ ! -f ${ts_config_path} ]]
then
    echo "Error: ${ts_config_path} does not exist"
    exit 1
fi

RESULTS=$($THIS_SCRIPT_DIR/checkCircularDependency.js "${dir_path}" "${ts_config_path}")

TOTAL_CIRCULAR_DEPENDENCIES_COUNT=0

FORMATTED_REPORT_NAME=$(echo $report_name | tr '[:upper:]' '[:lower:]')
FILENAME=circular_dependencies_${FORMATTED_REPORT_NAME}_list.txt

for i in ${RESULTS//,/ }
do
  if [ ! -f "$FILENAME" ]; then
    printf "Circular Dependencies\n\n\n" > $FILENAME
  fi
  echo "$i" >> $FILENAME
  TOTAL_CIRCULAR_DEPENDENCIES_COUNT=`expr $TOTAL_CIRCULAR_DEPENDENCIES_COUNT + 1`
done

# if [ -f "$FILENAME" ]; then
#     cp $FILENAME $BITRISE_DEPLOY_DIR/$FILENAME
# fi

if [ -f "$FILENAME" ]; then
    if [ -f "${BITRISE_DEPLOY_DIR}/circular_dependency_list.zip" ]; then
        cp $BITRISE_DEPLOY_DIR/circular_dependency_list.zip circular_dependency_list.zip
    fi
    zip circular_dependency_list.zip $FILENAME
    cp circular_dependency_list.zip $BITRISE_DEPLOY_DIR/circular_dependency_list.zip
fi


echo "---- REPORT ----"

if [ ! -f "quality_report.txt" ]; then
    printf "QUALITY REPORT\n\n\n" > quality_report.txt
fi

printf ">>>>>>>>>>  CURRENT CIRCULAR DEPENDENCY REPORT FOR $report_name <<<<<<<<<<\n" >> quality_report.txt
printf "Directory path: $dir_path \n" >> quality_report.txt
printf "TS Config file path: $ts_config_path \n" >> quality_report.txt
printf "Total Circular dependencies count threshold: $circular_dep_count_threshold \n" >> quality_report.txt
printf "Total Circular dependencies detected: $TOTAL_CIRCULAR_DEPENDENCIES_COUNT \n" >> quality_report.txt
printf "You can see list of circular dependencies in circular_dependency_list.zip \n\n" >> quality_report.txt

cp quality_report.txt $BITRISE_DEPLOY_DIR/quality_report.txt || true

envman add --key TOTAL_CIRCULAR_DEPENDENCIES_COUNT --value $TOTAL_CIRCULAR_DEPENDENCIES_COUNT

if [ $TOTAL_CIRCULAR_DEPENDENCIES_COUNT -gt $circular_dep_count_threshold ]; then
    echo "ERROR: New circular depedncies have been detected"
    exit 1
fi
exit 0