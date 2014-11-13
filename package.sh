#!/bin/bash

# Get the original sources from Douglas Crockfords GitHub repo
git clone https://github.com/douglascrockford/JSON-java.git original

# repackage them into maven standard layout
mkdir -p dist/src/main/java/org/json
rm original/README
mv original/* dist/src/main/java/org/json/

# Add a pom.xml with the current date as version
cp pom.xml dist/
sed -i "s/%%VERSION%%/`date +%Y%m%d`/g" dist/pom.xml

# Build and release it
cd dist
mvn deploy -Psonatype-oss-release
cd ..

# and clean everything up again
rm -Rf original
rm -Rf dist
