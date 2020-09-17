@echo off

python -m robot --report NONE --outputdir output --logtitle "Task log" robot.robot || goto :error

echo Success
goto :EOF

:error
echo Failed with error %errorlevel%.
exit /b %errorlevel%
