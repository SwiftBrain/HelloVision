//
//  ViewController.swift
//  HelloVision
//
//  Created by 郭朋 on 08/06/2017.
//  Copyright © 2017 Peng Guo. All rights reserved.
//

import UIKit
import Vision

class ViewController: UIViewController {

    @IBOutlet weak var result: UILabel!
    
    let model = MobileNet()
    let image = UIImage(named: "image.jpg")!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let visionModel = try? VNCoreMLModel(for: model.model) else {
            fatalError("Error")
        }
        
        let request = VNCoreMLRequest(model: visionModel) { request, error in
            
            if let observations = request.results as? [VNClassificationObservation] {
                let top5 = observations.prefix(through: 4)
                    .map { ($0.identifier, Double($0.confidence)) }
                self.show(results: top5)
            }
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
}

