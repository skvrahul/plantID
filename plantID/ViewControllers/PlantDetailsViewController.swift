//
//  PlantDetailsViewController.swift
//  plantID
//
//  Created by Rahul Sathanapalli on 04/11/18.
//  Copyright © 2018 Rahul Sathanapalli. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import CoreData


extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
extension Favourites{
    static func fetchRequest() -> NSFetchRequest<Favourites>{
        return NSFetchRequest<Favourites>(entityName: "Favourites")
    }
    static func fetchRequestWithCommonName(common_name:String)->NSFetchRequest<Favourites>{
        let req:NSFetchRequest<Favourites> = self.fetchRequest();
        req.predicate = NSPredicate(format: "common_name like %@", argumentArray: [common_name])
        return req
        
    }
    static func fetchRequestWithSciName(sci_name:String)->NSFetchRequest<Favourites>{
        let req:NSFetchRequest<Favourites> = self.fetchRequest();
        req.predicate = NSPredicate(format: "scientific_name like %@", argumentArray: [sci_name])
        return req
    }
}


class PlantDetailsViewController: UIViewController {
    @IBOutlet weak var plantImageView: UIImageView!
    @IBOutlet weak var plantDescriptionTV: UITextView!
    @IBOutlet weak var favouriteImageView: UIImageView!
    
    var plant:Plant? = nil
    var scientific_name:String? = nil
    
    @IBOutlet weak var plantLabel: UILabel!
    func createPlantFromJSON(sci_name:String, json:JSON) -> Plant?{
        let name:String? = json[["itemListElement",0,"result","name"]].string
        if name == nil{
            print(json)
        }
        let description:String? = json[["itemListElement",0,"result","detailedDescription","articleBody"]].string
        let wikipediaURL:String? = json[["itemListElement",0,"result","detailedDescription","url"]].string
        let imageURL:String? = json[["itemListElement",0,"result","image","contentUrl"]].string
        
        guard name != nil else{
            return nil
        }
        let p:Plant = Plant(commonName: name!, scientificName:sci_name)
        if let description = description{
            p.setDescription(desc: description)
        }
        if let imageURL = imageURL{
            print(imageURL)
            p.setImageURL(url: imageURL)
        }
        if let wikiURL = wikipediaURL{
            p.setWikipediaLink(link: wikiURL)
        }
        
        return p
    }
    func addFav(plant:Plant){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "PlantModel", in: context)
        let newPlant = NSManagedObject(entity:entity!, insertInto:context)
        newPlant.setValue(plant.scientificName, forKey: "scientific_name")
        newPlant.setValue(plant.commonName, forKey: "common_name")
        do {
            try context.save()
        } catch {
            print("Failed saving")
        }
    }
    func isFav(sci_name:String)->Bool{
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        var isFav = false
        //Checking if already a favourite
        let request = Favourites.fetchRequestWithSciName(sci_name: sci_name)
        request.returnsObjectsAsFaults = false
        
        do {
            let result = try context.fetch(request)
            print("Number of results:\(result.count)")
            if(result.count>0){
                isFav = true
            }
        } catch {
            print("Failed")
        }
        return isFav
    }
    func fetchDetails(sci_name:String){
        print("Fetching details for \(sci_name)")
        let params:[String:String] = ["key":"AIzaSyCRJhryHn2nfaJveyP6Pbi3CNCcf4LWgPo","query":sci_name, "indent":"true", "limit":"1"]
        let url = "https://kgsearch.googleapis.com/v1/entities:search"
        Alamofire.request(url, method: .get, parameters: params)
                    .responseJSON { response in
                        if response.result.isSuccess {
                            let plantJSON : JSON = JSON(response.result.value!)
                            self.plant = self.createPlantFromJSON(sci_name:sci_name, json: plantJSON)
                            print("Sucess! Got the plant data for \(self.plant?.commonName)")

                            //Reload the UI
                            self.loadUI()
                        } else {
                            print("Error: \(String(describing: response.result.error))")
                        }
                    }
    }
    @objc func favClicked(){
        guard self.plant != nil else{
            return
        }
        let plant = self.plant!
        
        if(isFav(sci_name: plant.scientificName)){
            //TODO: Handle when already a favourite
            print("\(plant.commonName) is already int your favourites!")
        }else{
            //Adding this to favourites
            addFav(plant: plant)
            print("Added \(plant.commonName) to your favourites!")
            favouriteImageView.image = UIImage(named:"heart_icon")
        }
        
        
    }
    func loadUI(){
        plantImageView.image = UIImage()
        guard plant != nil else {
            return
        }
        // Do any additional setup after loading the view.
        if(isFav(sci_name: plant!.scientificName)){
            favouriteImageView.image = UIImage(named: "heart_icon")
        }else{
            favouriteImageView.image = UIImage(named: "heart_icon_greyscale")
        }
        self.navigationItem.title = plant?.commonName
        if let url = plant?.imageURL{
            print("Loading plant image:\(url)")
            self.plantImageView.load(url: URL(string: url)! )
        }
        if let desc = plant?.plantDescription{
            self.plantDescriptionTV.text = desc
        }
        self.plantLabel.text = self.plant?.scientificName
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        loadUI()
        if let scientific_name = scientific_name{
            fetchDetails(sci_name: scientific_name)
        }
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(PlantDetailsViewController.favClicked))
        favouriteImageView.isUserInteractionEnabled = true
        favouriteImageView.addGestureRecognizer(singleTap)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var heartImageView: UIImageView!
    
    @IBOutlet weak var reportImageView: UIImageView!
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func wikipediaClicked(_ sender: Any) {
        let url:String? = self.plant?.wikipediaLink
        if let url = url{
            print("Attempting to open URL:\(url)")
            if let link = URL(string: url){
                print("opening link")
                UIApplication.shared.open(link)
            }
        }
        
    }
    
}
