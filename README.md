# cordova-pdf-protect
Protect your pdf files with password in Cordova / Ionic projects with this simple plugin

## If this project has helped you out, please support us with a star 🌟

### Usage
##### PDF_Protect.addPassword(NativeFileUrl, Password, SuccessCallback, FailureCallback)

### Install
```cordova plugin add https://github.com/Siddharth-Stark/cordova-pdf-protect.git```


### example (Ionic 2) ###
------------
```javascript
declare const cordova: any;

cordova.plugins.PDF_Protect.addPassword(res.nativeURL, 'Your_Password',
    function(res) {
      // On Success
   },
   function(error) {
     // On Failure 
   });

```
