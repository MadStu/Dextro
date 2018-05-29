#!/bin/bash
# MadStu's Small Install Script
cd ~
wget https://raw.githubusercontent.com/MadStu/Dextro/master/newdxomn.sh
chmod 777 newdxomn.sh
sed -i -e 's/\r$//' newdxomn.sh
./newdxomn.sh
