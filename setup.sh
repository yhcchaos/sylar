#!/bin/bash
mkdir -p  thirdpart
wget -P thirdpart https://github.com/jbeder/yaml-cpp/archive/refs/tags/yaml-cpp-0.6.3.zip
wget -P thirdpart https://github.com/open-source-parsers/jsoncpp/archive/refs/tags/1.8.4.zip
cd thirdpart
unzip  yaml-cpp-0.6.3.zip 
unzip 1.8.4.zip

cd yaml-cpp-0.6.3 && mkdir -p build && cd build 
cmake .. && make -j 4 && sudo make install && cd ..

cd jsoncpp-1.8.4 && mkdir -p build && cd build 
cmake .. && make -j 4 && sudo make install && cd ..

