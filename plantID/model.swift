//
//  model.swift
//  plantID
//
//  Created by Rahul Sathanapalli on 04/11/18.
//  Copyright © 2018 Rahul Sathanapalli. All rights reserved.
//

import Foundation
import UIKit.UIImage

class Plant:Codable,CustomStringConvertible {
    var commonName:String
    var scientificName:String
    var imageURL:String?
    var wikipediaLink:String? = nil
    var plantDescription:String? = nil
    var description:String{
        return "Name:\(self.commonName) SciName:\(self.scientificName) \n image:\(String(describing: self.imageURL)) wiki: \(String(describing: self.wikipediaLink))"
    }
    init(commonName:String, scientificName:String) {
        self.commonName = commonName
        self.scientificName = scientificName
    }
    init(commonName:String, scientificName:String, imageURL:String) {
        self.commonName = commonName
        self.scientificName = scientificName
        self.imageURL = imageURL
    }
    func setImageURL(url:String){
        self.imageURL = url
    }
    func getImageURL()->String?{
        return self.imageURL
    }
    func setDescription(desc:String){
        self.plantDescription = desc
    }
    func getDescription()->String?{
        return self.plantDescription
    }
    func setWikipediaLink(link:String){
        self.wikipediaLink = link
    }
    func getWikipediaLink()->String?{
        return self.wikipediaLink
    }
    
}
