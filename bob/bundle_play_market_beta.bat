if not defined in_subprocess (cmd /k set in_subprocess=y ^& %0 %*) & exit )
cd ../

java -jar bob/bob_beta.jar --build-server https://build-stage.defold.com --settings bob/settings/release_game.project_settings --archive --with-symbols --variant release --platform=armv7-android --bo bob/build/playmarket/release --settings bob/settings/play_market_game.project_settings resolve clean build bundle --strip-executable --keystore bob/keystore/release.jks --keystore-pass bob/keystore/release_password.txt --keystore-alias game --bundle-format=apk,aab
