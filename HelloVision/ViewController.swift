//
//  ViewController.swift
//  HelloVision
//
//  Created by 郭朋 on 08/06/2017.
//  Copyright © 2017 Peng Guo. All rights reserved.
//

import UIKit
import Vision

class ViewController: UIViewController, ImageChooserDelegate {

    @IBOutlet weak var result: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    let model = MobileNet()
    var image = UIImage(named: "image.jpg")!
    let imageChooser = ImageChooser()
    var request: VNCoreMLRequest?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let visionModel = try? VNCoreMLModel(for: model.model) else {
            fatalError("Error")
        }
        
        self.request = VNCoreMLRequest(model: visionModel) { request, error in
            
            if let observations = request.results as? [VNClassificationObservation] {
                let top5 = observations.prefix(through: 4)
                    .map { ($0.identifier, Double($0.confidence)) }
                self.show(results: top5)
            }
        }
        
        self.analyze()
        
        imageChooser.delegate = self
    }
    
    func analyze() {
        guard let request = self.request else {
            return
        }
        let handler = VNImageRequestHandler(cgImage: image.cgImage!)
        try? handler.perform([request])
    }
    
    // MARK: - UI stuff
    
    typealias Prediction = (String, Double)
    
    func show(results: [Prediction]) {
        var s: [String] = []
        for (i, pred) in results.enumerated() {
            s.append(String(format: "%d: %@ (%3.2f%%)", i + 1, pred.0, pred.1 * 100))
        }
        result.text = s.joined(separator: "\n")
    }
    
    @IBAction func chooseImage(_ sender: Any) {
        imageChooser.choose(viewController: self)
    }
    
    func imageChooser(picked: UIImage) {
        self.image = picked
        self.imageView.image = picked
        self.analyze()
    }
}

