var LibHtmlUtils = {


    HtmlHtmlUtilsHideBg: function () {
        if(window.my_image3D){
            window.my_image3D.delete();
            window.my_image3D = null;
        }

        let bg = document.getElementById("image-overlay");
        if (bg) {
            bg.style.display = "none";
            bg.style.background = "";
            bg.remove()
        }
        var progress_bar_root = document.getElementById('progress-bar-root');
        progress_bar_root.style.visibility = "hidden";

        clearInterval(window.loadingTooltipIntervalID);
    },

    HtmlHtmlUtilsLoadLiveUpdate: function () {
        window.progress_loader.reset_percentage();
        window.progress_loader.load_liveupdate = true
    },

    HtmlHtmlUtilsLoadLiveUpdateSetPercentage: function (percentage) {
        if (window.progress_loader.load_liveupdate){
            window.progress_loader.set_percentage(percentage);
        }
    },

    HtmlHtmlUtilsCanvasFocus: function () {
        document.getElementById("canvas").focus()
    },

    HtmlHtmlUtilsLoad: function (path, callback) {
        try {
            var path = UTF8ToString(path);
            let item = window.localStorage.getItem(path)
            if (item) {
                var _value = stringToNewUTF8(item);
                {{{ makeDynCall("viii", "callback")}}}(1, _value, lengthBytesUTF8(item));
                Module._free(_value);
            }else{
                var _value = stringToNewUTF8("no data");
                {{{ makeDynCall("viii", "callback")}}}(0, _value, lengthBytesUTF8("no data"));
                Module._free(_value);
            }
        } catch (e) {
            var _value = stringToNewUTF8(e.toString());
            {{{ makeDynCall("viii", "callback")}}}(0, _value, lengthBytesUTF8(e.toString()));
            Module._free(_value);
        }
    },

    HtmlHtmlUtilsSave: function (path,data, callback) {
        try {
            var path = UTF8ToString(path);
            var data = UTF8ToString(data);
            window.localStorage.setItem(path, data)
            var _value = ""
            {{{ makeDynCall("viii", "callback")}}}(1, _value, lengthBytesUTF8(""));
            Module._free(_value);
        } catch (e) {
            var _value = stringToNewUTF8(e.toString());
            {{{ makeDynCall("viii", "callback")}}}(0, _value, lengthBytesUTF8(e.toString()));
            Module._free(_value);
        }
    },

    HtmlHtmlUtilsIsMobile: function () {
        return (typeof window.orientation !== 'undefined') || (navigator.userAgent.indexOf('IEMobile') !== -1);
    },

}

addToLibrary(LibHtmlUtils);