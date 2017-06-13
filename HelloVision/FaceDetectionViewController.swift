//
//  FaceDetectionViewController.swift
//  HelloVision
//
//  Created by 郭朋 on 08/06/2017.
//  Copyright © 2017 Peng Guo. All rights reserved.
//

import UIKit
import Vision

class FaceDetectionViewController: UIViewController {
    
    @IBOutlet weak var facesImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let facesImage = UIImage(named: "faces.jpg")!
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
        let layers: [CAShapeLayer] = observations.map { observation in
            
            let w = observation.boundingBox.size.width * facesImageView.bounds.width
            let h = observation.boundingBox.size.height * facesImageView.bounds.height
            let x = observation.boundingBox.origin.x * facesImageView.bounds.width
            let y = abs(((observation.boundingBox.origin.y * (facesImageView.bounds.height)) - facesImageView.bounds.height)) - h
            
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
    
}
