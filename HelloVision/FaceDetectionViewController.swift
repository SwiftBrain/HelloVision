//
//  FaceDetectionViewController.swift
//  HelloVision
//
//  Created by 郭朋 on 08/06/2017.
//  Copyright © 2017 Peng Guo. All rights reserved.
//

import UIKit
import Vision
import AVFoundation

class FaceDetectionViewController: UIViewController, ImageChooserDelegate {
    
    @IBOutlet weak var facesImageView: UIImageView!
    
    var facesImage = UIImage(named: "faces.jpg")!
    let imageChooser = ImageChooser()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.imageChooser.delegate = self
        self.analyze()
    }
    
    func analyze() {
        guard let facesCIImage = CIImage(image: facesImage)
            else { fatalError("can't create CIImage from UIImage") }
        let detectFaceRequest: VNDetectFaceRectanglesRequest = VNDetectFaceRectanglesRequest(completionHandler: self.handleFaces)
        let detectFaceRequestHandler = VNImageRequestHandler(ciImage: facesCIImage, options: [:])
        
        do {
            try detectFaceRequestHandler.perform([detectFaceRequest])
        } catch {
            print(error)
        }
    }
    
    func handleFaces(request: VNRequest, error: Error?) {
        guard let observations = request.results as? [VNFaceObservation]
            else { fatalError("unexpected result type from VNDetectFaceRectanglesRequest") }
        
        self.addShapesToFace(forObservations: observations)
    }
    
    func addShapesToFace(forObservations observations: [VNFaceObservation]) {
        
        if let sublayers = facesImageView.layer.sublayers {
            for layer in sublayers {
                layer.removeFromSuperlayer()
            }
        }
        
        let imageRect = AVMakeRect(aspectRatio: facesImage.size, insideRect: facesImageView.bounds)
        
        let layers: [CAShapeLayer] = observations.map { observation in
            
            let w = observation.boundingBox.size.width * imageRect.width
            let h = observation.boundingBox.size.height * imageRect.height
            let x = observation.boundingBox.origin.x * imageRect.width
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
            facesImageView.layer.addSublayer(layer)
        }
    }
    
    @IBAction func chooseImage(_ sender: Any) {
        self.imageChooser.choose(viewController: self)
    }
    
    func imageChooser(picked: UIImage) {
        self.facesImage = picked
        self.facesImageView.image = picked
        self.analyze()
    }
}
