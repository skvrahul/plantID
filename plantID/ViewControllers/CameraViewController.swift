//
//  SecondViewController.swift
//  plantID
//
//  Created by Rahul Sathanapalli on 03/11/18.
//  Copyright © 2018 Rahul Sathanapalli. All rights reserved.
//

import UIKit
import VisionLab

class CameraViewController: ImageClassificationController<ClassificationService>
{

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        mainView.button.setTitle("Choose an image of a flower", for: .normal)
        classificationService.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension CameraViewController: ClassificationServiceDelegate {
    func classificationService(_ service: ClassificationService, didDetectFlower flower: String) {
        DispatchQueue.main.async { [weak mainView] in
            mainView?.label.text = flower.capitalized
            
            // Returns a 2d array of string, with each subarray containing the flowername and percentage
            // Eg, for name of first flower, do preds[0][0], second flower, preds[1][0] ans so on
            var preds = getFlowers(str: flower)
        }
    }
}


func getFlowers(str: String)->[[Substring.SubSequence]]
    {
        let out = str.split(separator: "\n")
        print(out[0])
        print(out[1])
        print(out[2])
        
        var name0 = out[0].split(separator: "(")
        var name1 = out[1].split(separator: "(")
        var name2 = out[2].split(separator: "(")
        
        let o = [name0, name1, name2]
        print(name1[0], name1[1])
        return o
        
    }

