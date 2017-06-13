//
//  BarcodesDetectViewController.swift
//  HelloVision
//
//  Created by 郭朋 on 10/06/2017.
//  Copyright © 2017 Peng Guo. All rights reserved.
//

import UIKit
import Vision

class BarcodesDetectViewController: UIViewController {

    @IBOutlet weak var result: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let barcodeImage = UIImage(named: "QRCode.png")!
        
        let barcodeRequest = VNDetectBarcodesRequest(completionHandler: {(request, error) in
            
            for result in request.results! {
                
                if let barcode = result as? VNBarcodeObservation {
                    
                    if let desc = barcode.barcodeDescriptor as? CIQRCodeDescriptor {
                        print(desc.symbolVersion)
                        let content = String(data: desc.errorCorrectedPayload, encoding: .utf8)
                        
                        let resultStr = """
                                        Symbology: \(barcode.symbology.rawValue)\n
                                        Payload: \(String(describing: content))\n
                                        Error-Correction-Level:\(desc.errorCorrectionLevel)\n
                                        Symbol-Version: \(desc.symbolVersion)\n
                                        """
                        DispatchQueue.main.async {
                            self.result.text = resultStr
                        }
                    }
                }
            }
        })
        
        let handler = VNImageRequestHandler(cgImage: barcodeImage.cgImage!, options: [:])
        
        guard let _ = try? handler.perform([barcodeRequest]) else {
            return print("error")
        }

    }

}
