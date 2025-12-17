::adb shell pm uninstall com.d954mas.idle.3d.dev
adb install -r ".\build\playmarket\dev\CashchubbiesIslandDev\CashchubbiesIslandDev.apk"
adb shell monkey -p com.d954mas.cashchubbies.island.idle.tycoon.dev -c android.intent.category.LAUNCHER 1
pause
