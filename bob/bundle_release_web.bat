if not defined in_subprocess (cmd /k set in_subprocess=y ^& %0 %*) & exit )
cd ../


java -jar bob/bob.jar --settings bob/settings/release_game.project_settings  --archive  --texture-compression true --with-symbols --variant release --platform=js-web --bo bob/build/web/release -brhtml bob/build/web/release/report.html -liveupdate yes clean resolve build bundle
