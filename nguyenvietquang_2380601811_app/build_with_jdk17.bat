@echo off
set JAVA_HOME=C:\Program Files\Eclipse Adoptium\jdk-17.0.20.101-hotspot
set PATH=%JAVA_HOME%\bin;%PATH%
set GRADLE_USER_HOME=%USERPROFILE%\.gradle
cd android
call gradlew.bat clean assembleDebug --no-daemon
