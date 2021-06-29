# pandoc-ssg
a simple bash script to generate a static site from a folder full of markdown files

I wanted something simple and I really didn't want to mess with jekyll again so i decided to make a little wrapper script for pandoc.

It takes in a folder full of markdown files that link each other where all the assests are in an assets folder.
and converts it into a website with common header and footer.

the site directory should look as follows

```
.
├── pkms-site/
│   ├── assets/
│   ├── blog/
│   ├── notes/
│   ├── projects/
│   └── index.md
└── site/
    ├── footer.html
    ├── header.html
    ├── links-to-html.lua
    └── md-pan-wiki.sh
```

``md-pan-wiki.sh`` contains the following.

```bash
#! /bin/bash

# run in /site directory
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
```

``links-to-html.lua`` is a lua filter that changes all the relative links to .md files into links to .html files

```lua
function Link(el)
    el.target = string.gsub(el.target, "%.md", ".html")
    return el
end
```

for an live example see my [personal site](https://github.com/kevin-nel/kevin-nel.github.io) 
