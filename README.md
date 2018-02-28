This is a simple starting point for building a Cordova plugin on iOS and Android.

# cordova-pdf-protect
Protect your pdf files with password in Cordova / Ionic projects with this simple plugin

### Usage ###
#### PDF_Protect.addPassword(NativeFileUrl, Password, SuccessCallback, FailureCallback) ####

### example (Ionic 2) ###

declare const cordova: any;

cordova.plugins.PDF_Protect.addPassword(res.nativeURL, 'hello',
  function(res: any) {
    console.log(res);
    resolve();
  },
  function(error: any) {
    reject(error);
  })
