# cordova-pdf-protect
Protect your pdf files with password in Cordova / Ionic projects with this simple plugin

### Usage
##### PDF_Protect.addPassword(NativeFileUrl, Password, SuccessCallback, FailureCallback)

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
