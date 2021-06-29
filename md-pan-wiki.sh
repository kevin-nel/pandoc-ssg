#! /bin/bash

# run in site directory
# this copies the directory structure into ./export/ without copying the files
cd ../pkms-site;
find ./ -type d > ../site/dirs.txt;
cd ../site;
mkdir -p export;
cd export;
xargs mkdir -p < ../dirs.txt;
# this copies assests like images into the new export assests directory
cp -r ../../pkms-site/assets/* assets/ ;

# find all md files and feed them in to pandoc as input files.
cd ../../pkms-site;

find ./ -iname "*.md" -type f -exec sh -c 'pandoc -f markdown+tex_math_dollars-smart -t html5 "${0}" -so "../site/export/${0%.*}.html" --lua-filter=../site/links-to-html.lua --include-after-body=../site/footer.html --include-before-body=../site/header.html --css /assets/css/oldschool.css --html-q-tags --katex --no-highlight' {} \;
# ${0%.*} strips the file extension while leaving the path
# the lua filter converts all relative links to .md files to .html files