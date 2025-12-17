if not defined in_subprocess (cmd /k set in_subprocess=y ^& %0 %*) & exit )
cd ../


java -jar bob/bob.jar --settings bob/settings/release_game.project_settings  --settings bob/settings/itch_game.project_settings --archive  --texture-compression true --with-symbols --variant debug --platform=js-web --bo bob/build/itch/release -brhtml bob/build/itch/release/report.html -liveupdate yes clean resolve build bundle
