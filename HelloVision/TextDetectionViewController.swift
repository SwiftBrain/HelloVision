//
//  TextDetectionViewController.swift
//  HelloVision
//
//  Created by 郭朋 on 11/06/2017.
//  Copyright © 2017 Peng Guo. All rights reserved.
//

import UIKit
import Vision

class TextDetectionViewController: UIViewController {
    
    @IBOutlet weak var textImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let textImage = UIImage(named: "text.jpg")!
        
        let textDetectionRequest = VNDetectTextRectanglesRequest(completionHandler: {(request, error) in
            
            guard let observations = request.results as? [VNTextObservation]
                else { fatalError("unexpected result type from VNDetectTextRectanglesRequest") }
            
            self.addShapesToText(forObservations: observations)
        })
        
        let handler = VNImageRequestHandler(cgImage: textImage.cgImage!, options: [:])
        
        guard let _ = try? handler.perform([textDetectionRequest]) else {
            return print("Could not perform text Detection Request!")
        }
        
    }
    
    func addShapesToText(forObservations observations: [VNTextObservation]) {
        let layers: [CAShapeLayer] = observations.map { observation in
            
            let w = observation.boundingBox.size.width * textImageView.bounds.width
            let h = observation.boundingBox.size.height * textImageView.bounds.height
            let x = observation.boundingBox.origin.x * textImageView.bounds.width
            let y = abs(((observation.boundingBox.origin.y * (textImageView.bounds.height)) - textImageView.bounds.height)) - h
            
            print("----")
            print("W: ", w)
            print("H: ", h)
            print("X: ", x)
            print("Y: ", y)
            
            let layer = CAShapeLayer()
            layer.frame = CGRect(x: x , y: y, width: w, height: h)
            layer.borderColor = UIColor.red.cgColor
            layer.borderWidth = 2
            layer.cornerRadius = 3
            return layer
        }
        
        for layer in layers {
            textImageView.layer.addSublayer(layer)
        }
    }

}
