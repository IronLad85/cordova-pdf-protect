//
//  PDFProtector.swift
//  PDFProtector
//
//  Created by Pavan, Kumar on 1/2/17.
//  Copyright © 2017 Pavan, Kumar. All rights reserved.
//

import Foundation
import CoreGraphics
import UIKit

/**
 
 This is the core class to protect PDF file with the given password.
 
 */
@objc(PDFProtector) class PDFProtector: CDVPlugin {
    var command: CDVInvokedUrlCommand?
    var pluginResult = CDVPluginResult(
        status:CDVCommandStatus_ERROR
    )
    
    // MARK:- Overrides
    
    override func pluginInitialize() {
        print("pluginInitialize: ImageCapturePlugin")
    }
}

// MARK:- Helpers

extension PDFProtector {
    /**
     This method will be invoked from web pages
     */
    func protectPDF(_ command: CDVInvokedUrlCommand) {
        self.command = command
        if let params = command.arguments[0] as? [Any] {
            if let fileStringPath = params[0] as? String,
                let password = params[1] as? String {
                let filePath = URL(string: fileStringPath)!
                protectPDF(filePath: filePath, password:password)
            }
        }
    }
    
    /**
     
     Protects given PDF file at specified path
     
     - Parameters:
        - filePath: A filepath of the original PDF file
        - password: A password to secure PDF file
     
     */
    fileprivate func protectPDF(filePath: URL, password: String) {
        var pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: "")
        // Ensure password meets criteria
        do {
            // validate password
            let formattedPassword = PDFPassword(password)
            try formattedPassword.verify()
            
            // create secure directory to store secure PDF files
            createdSecurePDFFolderIfRequired()
            
            //create empty pdf file;
            let secureFilePath = securedPDFFolderPath().appendingPathComponent(filePath.lastPathComponent)
            UIGraphicsBeginPDFContextToFile(secureFilePath.path,
                                            .zero,
                                            formattedPassword.toDocumentInfo())
            
            if let actualPDFDocument = CGPDFDocument(filePath as CFURL) {
                let pageCount = actualPDFDocument.numberOfPages
                for pageNumber in 1...pageCount {
                    //get bounds of template page
                    let actualPage = actualPDFDocument.page(at: pageNumber)
                    let actualPageBounds = (actualPage?.getBoxRect(.cropBox))!
                    
                    //create empty page with corresponding bounds in new document
                    UIGraphicsBeginPDFPageWithInfo(actualPageBounds, nil)
                    let context = UIGraphicsGetCurrentContext()
                    
                    //flip context due to different origins
                    context!.translateBy(x: 0.0, y: actualPageBounds.size.height);
                    context!.scaleBy(x: 1.0, y: -1.0);
                    
                    //copy content of template page on the corresponding page in new file
                    context?.drawPDFPage(actualPage!)
                    
                    //flip context back
                    context!.translateBy(x: 0.0, y: actualPageBounds.size.height);
                    context!.scaleBy(x: 1.0, y: -1.0);
                }
                
                UIGraphicsEndPDFContext();
                pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: secureFilePath.path)
            }
        } catch _ {
            print("Password does not meet criteria")
        }
        
        self.commandDelegate.send(pluginResult, callbackId: self.command?.callbackId)
    }
    
    /**
     
     SecurePDF folder will be created to save secured PDF files
     
     */
    private func createdSecurePDFFolderIfRequired() {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let url = NSURL(fileURLWithPath: documentsPath)
        let dirURL = url.appendingPathComponent("SecuredPDF")
        let fileManager = FileManager.default
        
        if !fileManager.fileExists(atPath: dirURL!.path) {
            do {
                try fileManager.createDirectory(at: dirURL!, withIntermediateDirectories: true, attributes: nil)
            } catch let error {
                print("Unable to create secured directory \(error.localizedDescription)")
            }
        }
    }
    
    /**
     
     A path for `SecurePDF` will be returned
     
     - Returns: A file URL for `SecuredPDF`
     
     */
    private func securedPDFFolderPath() -> URL {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let url = NSURL(fileURLWithPath: documentsPath)
        let dirURL = url.appendingPathComponent("SecuredPDF")
        return dirURL!
    }
}
