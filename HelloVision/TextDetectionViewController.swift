//
//  TextDetectionViewController.swift
//  HelloVision
//
//  Created by 郭朋 on 11/06/2017.
//  Copyright © 2017 Peng Guo. All rights reserved.
//

import UIKit
import Vision
import AVFoundation

class TextDetectionViewController: UIViewController, ImageChooserDelegate {
    
    @IBOutlet weak var textImageView: UIImageView!
    
    let imageChooser = ImageChooser()
    var textImage = UIImage(named: "text.jpg")!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.imageChooser.delegate = self
        
        self.analyze()
    }
    
    func analyze() {
        
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
        
        if let layers = self.textImageView.layer.sublayers {
            for layer in layers {
                layer.removeFromSuperlayer()
            }
        }
        
        let imageRect = AVMakeRect(aspectRatio: textImage.size, insideRect: textImageView.bounds)
        
        let layers: [CAShapeLayer] = observations.map { observation in
            
            
            let w = observation.boundingBox.size.width * imageRect.width
            let h = observation.boundingBox.size.height * imageRect.height
            let x = observation.boundingBox.origin.x * imageRect.width + imageRect.origin.x
            let y = imageRect.maxY - (observation.boundingBox.origin.y * imageRect.height) - h
            
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
    
    @IBAction func chooseImage(_ sender: Any) {
        self.imageChooser.choose(viewController: self)
    }
    
    func imageChooser(picked: UIImage) {
        self.textImage = picked
        self.textImageView.image = picked
        self.analyze()
    }
}
