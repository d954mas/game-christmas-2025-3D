::adb shell pm uninstall com.d954mas.idle.3d
adb install -r ".\build\playmarket\release\DrillsMergeMaster\DrillsMergeMaster.apk"
adb shell monkey -p com.d954mas.drills.merge.master.idle -c android.intent.category.LAUNCHER 1
pause
