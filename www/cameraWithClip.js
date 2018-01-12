var exec = require('cordova/exec');

exports.takePic = function(arg0, success, error) {
    exec(success, error, "cameraWithClip", "takePic", [arg0]);
};
