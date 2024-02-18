@echo off

git add .

set /P msg=

git commit -m "%msg%"

git push