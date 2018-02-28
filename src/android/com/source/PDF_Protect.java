/**
 */
package com.source;

import org.apache.cordova.CallbackContext;
import android.content.Context;
import org.apache.cordova.CordovaInterface;
import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CordovaWebView;
import org.apache.cordova.PluginResult;
import org.apache.cordova.PluginResult.Status;
import org.apache.cordova.LOG;
import org.json.JSONObject;
import org.json.JSONArray;
import org.json.JSONException;

import android.util.Log;
import java.util.Date;
import java.io.FileNotFoundException;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;

//PDF Related imports
import com.itextpdf.text.DocumentException;
import com.itextpdf.text.pdf.PdfReader;
import com.itextpdf.text.pdf.PdfStamper;
import com.itextpdf.text.pdf.PdfWriter;

public class PDF_Protect extends CordovaPlugin {
    private static final String TAG = "PDF_Protect";

    public void initialize(CordovaInterface cordova, CordovaWebView webView) {
        super.initialize(cordova, webView);

        Log.d(TAG, "Initializing PDF_Protect");
    }

    public boolean execute(String action, JSONArray args, final CallbackContext callbackContext) throws JSONException  {
        if (action.equals("echo")) {
            String phrase = args.getString(0);
            // Echo back the first argument
            Log.d(TAG, phrase);
        } else if (action.equals("protectPDF")) {
            // An example of returning data back to the web layer
            PluginResult result = new PluginResult(PluginResult.Status.OK, "SUCCESSFUL");
            result.setKeepCallback(true);
            try {
              String filePath = args.getString(0);
              String passcode = args.getString(1);
                encryptPdf(filePath, passcode, callbackContext);
                callbackContext.sendPluginResult(result);
            }
            catch (Exception e) {
              callbackContext.error("Err"+e);
              LOG.w("IONIC_ERROR",e);
              e.printStackTrace();
            }
        }
        return true;
    }

    public void encryptPdf(String src, String passcode, final CallbackContext callbackContext) throws IOException, DocumentException {
      src = src.replaceFirst("file://", "");
      File file = new File(src);
      String dest = src.replaceFirst(".pdf", "_SECURE.pdf");
      if (!file.exists()) {
        callbackContext.error("FILE_NOT_FOUND");
        Log.e("IONIC_ERROR", "File not found: " + src);
      }
      else {
      PdfReader reader = new PdfReader(src);
      PdfStamper stamper = new PdfStamper(reader, new FileOutputStream(dest));
      stamper.setEncryption(passcode.getBytes(), null, PdfWriter.ALLOW_PRINTING,  PdfWriter.ENCRYPTION_AES_128 | PdfWriter.DO_NOT_ENCRYPT_METADATA);
      stamper.close();
      reader.close();
      file.delete();
      File renamed = new File(dest);
      File source = new File(src);
      boolean status = renamed.renameTo(source);
      callbackContext.success("SUCCESSFUL_"+status);
      }
    }
}
