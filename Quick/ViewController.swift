//
//  ViewController.swift
//  Quick
//
//  Created by Yasuaki Uechi on 18/3/21.
//  Copyright © 2018 Yasuaki Uechi. All rights reserved.
//

import UIKit
import QRCode

class ViewController: UIViewController {
    
    @IBOutlet weak var qrView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        qrView.image = {
            var qrCode = QRCode("http://github.com/aschuch/QRCode")!
            qrCode.size = self.qrView.bounds.size
            qrCode.errorCorrection = .High
            return qrCode.image
        }()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

