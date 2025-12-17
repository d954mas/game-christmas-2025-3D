if not defined in_subprocess (cmd /k set in_subprocess=y ^& %0 %*) & exit )
cd ../
java -jar bob/bob.jar --settings bob/settings/dev_game.project_settings --archive  --texture-compression true --with-symbols --variant debug --platform=js-web --bo bob/build/web/dev -brhtml bob/build/web/dev/report.html --liveupdate yes clean resolve build bundle 