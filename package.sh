#!/bin/bash
SRC_FOLDER=dist/src/main/java/org/json
WORKING_DIR=`pwd`

# Get the original sources from Douglas Crockfords GitHub repo
mkdir -p $SRC_FOLDER
git clone https://github.com/stleary/JSON-java.git $SRC_FOLDER

echo ""
echo "The following tags exist in the repository:"
cd "$SRC_FOLDER"
git tag -l

echo ""
echo "Please enter the tag name to be released"
read tagName

git checkout tags/${tagName}

# Checkout the tags from the unit test repo
cd "$WORKING_DIR"
git clone https://github.com/stleary/JSON-Java-unit-test.git tests
cd tests
git checkout tags/${tagName}

# And copy them into the build folder structure
cd "$WORKING_DIR"
mkdir -p dist/src/test
mv tests/src/test/* dist/src/test/
rm -Rf tests

# Remove the README file from the package structure
cd "$SRC_FOLDER"
rm README.md

# Add a pom.xml
# Since the tests are written in java 7 and the code itself has to be built with java 6, we du two runs here
cd "$WORKING_DIR"
cp pom.xml dist/
sed -i "s/%%VERSION%%/${tagName}/g" dist/pom.xml
sed -i "s/%%JAVAVERSION%%/1.7/g" dist/pom.xml

echo ""
echo "Please run mvn verify -Dgpg.passphrase=thepassphrase in the dist folder"
read success

# Add a pom.xml with the current date as version
cd "$WORKING_DIR"
rm dist/pom.xml
cp pom.xml dist/
sed -i "s/%%VERSION%%/${tagName}/g" dist/pom.xml
sed -i "s/%%JAVAVERSION%%/1.6/g" dist/pom.xml
rm -Rf dist/src/test

echo ""
echo "Please run mvn clean deploy -Dgpg.passphrase=thepassphrase in the dist folder"
echo "use a shell with a working gpg2 command. Hit <enter> afterwards."
read success

rm -Rf dist
