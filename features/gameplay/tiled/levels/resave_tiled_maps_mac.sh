#Resave tileset and all maps
#NEED when tileset changed
#https://github.com/mapeditor/tiled/commit/72789ab0e1a42c87f196f027f2cb6169675f5e48
mkdir -p ./levels/lua
rm -r ./levels/lua/*

#replace path to tiled
#path should have /Contents/MacOS/Tiled
TILED_PATH="/Volumes/Media/Downloads/Tiled.app/Contents/MacOS/Tiled"


echo resave tilesets;
"$TILED_PATH" --export-map --embed-tilesets lua ./tilesets/tilesets.tmx ./tilesets/tilesets.lua

echo resave maps;

for f in $(find ./levels/sources -name '*.tmx'); do
	fname=`basename $f`
	newname=${fname%.*}.lua
	if [ ${fname%.*} == "level_tim_rules" ]
	then 
	continue; 
	fi
	echo $f;
	"$TILED_PATH" --export-map lua $f ./levels/lua/$newname
done;

#read -t 3 -p "Press any key or wait 3 second"