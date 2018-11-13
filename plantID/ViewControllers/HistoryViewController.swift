//
//  FirstViewController.swift
//  plantID
//
//  Created by Rahul Sathanapalli on 03/11/18.
//  Copyright © 2018 Rahul Sathanapalli. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func goClicked(_ sender: Any) {
        performSegue(withIdentifier: "showPlantDetails", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! PlantDetailsViewController
        vc.scientific_name = "Ficus Religiosa"
    }
    

}

