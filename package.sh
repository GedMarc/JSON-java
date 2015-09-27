#!/bin/bash

# Get the original sources from Douglas Crockfords GitHub repo
git clone https://github.com/douglascrockford/JSON-java.git original

echo ""
echo "The following tags exist in the repository:"
cd original
git tag -l 

echo "Please enter the tag name to be released"
read tagName

git checkout tags/${tagName}
cd ..

# repackage them into maven standard layout
mkdir -p dist/src/main/java/org/json
mv original/* dist/src/main/java/org/json/
rm dist/src/main/java/org/json/README
rm -Rf original

# Add a pom.xml with the current date as version
cp pom.xml dist/
sed -i "s/%%VERSION%%/${tagName}/g" dist/pom.xml

ech ""
echo "Please run mvn deploy in the dist folder"
echo "use a shell with a working gpg2 command. Hit <enter> afterwards."
read succes

rm -Rf dist
