#!/bin/bash

git submodule update --init --recursive --remote

cd dam-web-ui
npm install && npm run build
cd ..

mv dam-web-ui/build public
