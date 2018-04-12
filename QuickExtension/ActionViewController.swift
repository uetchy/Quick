//
//  ActionViewController.swift
//  QuickExtension
//
//  Created by Yasuaki Uechi on 18/3/21.
//  Copyright © 2018 Yasuaki Uechi. All rights reserved.
//

import UIKit
import MobileCoreServices
import QRCode
import Contacts

class ActionViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var statusIndicator: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
    
        let items = self.extensionContext!.inputItems as! [NSExtensionItem]
        
        for provider in items[0].attachments! as! [NSItemProvider] {
            NSLog("TypeIds")
            NSLog(provider.registeredTypeIdentifiers.description)
            if provider.hasItemConformingToTypeIdentifier(kUTTypeFileURL as String) {
                NSLog("File URL")
                provider.loadItem(forTypeIdentifier: kUTTypeFileURL as String, options: nil, completionHandler: { (target, error) in
                    do {
                        let content = try Data(contentsOf: target as! URL)
                        self.showQRCode(content)
                    } catch {
                        self.statusIndicator.text = "Failed to load file URL"
                        NSLog("Failed to load file URL")
                    }
                })
                break
            } else if provider.hasItemConformingToTypeIdentifier(kUTTypeURL as String) {
                NSLog("URL")
                provider.loadItem(forTypeIdentifier: kUTTypeURL as String, options: nil, completionHandler: { (target, error) in
                    self.showQRCode(target as! URL)
                })
                break
            } else if provider.hasItemConformingToTypeIdentifier(kUTTypeVCard as String) {
                NSLog("VCard")
                provider.loadItem(forTypeIdentifier: kUTTypeVCard as String, options: nil, completionHandler: { (target, error) in
                    if let data = target as? NSData, let vCardString = String(data: data as Data, encoding: .utf8) {
                        do {
                            let contacts = try CNContactVCardSerialization.contacts(with: vCardString.data(using: .utf8)!)
                            let contact = contacts.first!.mutableCopy() as! CNMutableContact
                            
                            // Remove profile picture for saving data
                            contact.imageData = nil
                            
                            let purifiedVCardData = try CNContactVCardSerialization.data(with: [contact])
                            NSLog(String(data: purifiedVCardData, encoding: .utf8)!)
                            self.showQRCode(purifiedVCardData)
                        } catch {
                            NSLog("Failed to handle VCard")
                        }
                    }
                    
                })
                break
            } else if provider.hasItemConformingToTypeIdentifier(kUTTypeHTML as String) {
                NSLog("HTML")
                provider.loadItem(forTypeIdentifier: kUTTypeHTML as String, options: nil, completionHandler: { (target, error) in
                    self.showQRCode(target as! String)
                })
                break
            } else if provider.hasItemConformingToTypeIdentifier(kUTTypeRTF as String) {
                NSLog("RTF")
                provider.loadItem(forTypeIdentifier: kUTTypeRTF as String, options: nil, completionHandler: { (target, error) in
                    self.showQRCode(target as! Data)
                })
                break
            } else if provider.hasItemConformingToTypeIdentifier(kUTTypeText as String) {
                NSLog("Text")
                provider.loadItem(forTypeIdentifier: kUTTypeText as String, options: nil, completionHandler: { (target, error) in
                    self.showQRCode(target as! String)
                })
                break
            } else if provider.hasItemConformingToTypeIdentifier(kUTTypeData as String) {
                NSLog("Data")
                provider.loadItem(forTypeIdentifier: kUTTypeData as String, options: nil, completionHandler: { (target, error) in
                    self.showQRCode(target as! Data)
                })
                break
            } else {
                NSLog("Unmatched")
                break
            }
        }
    }
    
    func showQRCode(_ data: Any) {
        weak var weakImageView = self.imageView
        weak var weakStatusIndicator = self.statusIndicator
        OperationQueue.main.addOperation {
            if let strongImageView = weakImageView {
                strongImageView.image = {
                    var qrCode: QRCode?
                    switch data {
                    case let str as String:
                        NSLog(str)
                        qrCode = QRCode(str.data(using: .utf8)!)
                    case let url as URL:
                        qrCode = QRCode(url.absoluteString.data(using: .utf8)!)
                    case let rawData as Data:
                        qrCode = QRCode(rawData)
                    default:
                        return nil
                    }
                    
                    if qrCode == nil {
                        NSLog("qrCode is nil")
                        return nil
                    }
                    
                    qrCode!.size = strongImageView.bounds.size
                    qrCode!.errorCorrection = .Low
                    
                    weakStatusIndicator?.text = "Scan this code to share"
                    
                    return qrCode!.image
                }()
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func done() {
        // Return any edited content to the host app.
        // This template doesn't do anything, so we just echo the passed in items.
        self.extensionContext!.completeRequest(returningItems: self.extensionContext!.inputItems, completionHandler: nil)
    }

}
