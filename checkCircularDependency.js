#!/usr/bin/env node

const madge = require('madge');

let dirPath = process.argv[2];
let tsConfigPath = process.argv[3];

const path = dirPath;
const config = {
  tsConfig: tsConfigPath,
};

const buildCircularDependency = nodes => {
  let circularDependencyList = '';
  nodes.forEach(node => {
    console.log('test22', node.length);
    if (Array.isArray(node)) {
      const nodeLength = node.length - 1;
      const line = node.reduce((resultString, filename, currIndex, fileList) =>
        nodeLength === currIndex
          ? `${resultString}=>${filename}=>${fileList[0]}`
          : `${resultString}=>${filename}`
      );

      circularDependencyList = circularDependencyList.concat(line, ',');
    }
  });
  return circularDependencyList;
};

madge(path, config).then(res => {
  const resultList = res.circular();
  if (resultList.length > 0) {
    console.log('test1', resultList.length);
    const result = buildCircularDependency(resultList);

    console.log(result);
    return result;
  }
}).catch(error => {
  console.log('ERROR', error);
  return error
});
