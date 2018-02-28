var exec = require('cordova/exec');

var PLUGIN_NAME = 'PDF_Protect';

var PDF_Protect = {
  echo: function(phrase, onSuccess, onError) {
    exec(onSuccess, onError, PLUGIN_NAME, 'echo', [phrase]);
  },
  addPassword: function(filepath, passcode, onSuccess, onError) {
    exec(onSuccess, onError, PLUGIN_NAME, 'protectPDF', [filepath, passcode]);
  }
};

module.exports = PDF_Protect;
