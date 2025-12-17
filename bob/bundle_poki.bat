if not defined in_subprocess (cmd /k set in_subprocess=y ^& %0 %*) & exit )
cd ../


java -jar bob/bob.jar --settings bob/settings/release_game.project_settings --settings bob/settings/poki_game.project_settings --archive  --texture-compression true --with-symbols --variant release --platform=js-web --bo bob/build/poki/release -brhtml bob/build/poki/release/report.html --liveupdate yes clean resolve build bundle
