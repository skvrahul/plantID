//
//  FavouritesTableViewController.swift
//  plantID
//
//  Created by Rahul Sathanapalli on 09/11/18.
//  Copyright © 2018 Rahul Sathanapalli. All rights reserved.
//

import UIKit

class FavouritesTableViewController: UITableViewController {
    @IBOutlet weak var editButton: UIBarButtonItem!
    var plant_sci_names = ["Dahlia variabilis","Chrysanthemum indicum", "Cosmos bipinnatus", "Papaver somniferum"]
    var plant_comm_names = ["Dahlias", "Chrysanthemums","Cosmos","Poppy Plants"]
    var selected_plant:String? = nil
    override func viewDidLoad() {
        self.tableView.tableFooterView = UIView()
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    @IBAction func editClicked(_ sender: Any) {
        var isEditing = tableView.isEditing
        tableView.setEditing(!isEditing, animated: true)
        isEditing = !isEditing
        if(isEditing){
            editButton.title = "Done"
        }else{
            editButton.title = "Edit"
        }
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0{
            return plant_sci_names.count
        }else{
            return 0
        }
        
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selected_plant = plant_sci_names[indexPath.row]
        performSegue(withIdentifier: "showPlantDetails", sender: self)
    }
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        self.selected_plant = plant_sci_names[indexPath.row]
        performSegue(withIdentifier: "showPlantDetails", sender: self)
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favouriteCell", for: indexPath)

        let i = indexPath.row
        cell.textLabel?.text = (plant_sci_names[i])
        cell.detailTextLabel?.text = (plant_comm_names[i])
        
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            plant_sci_names.remove(at: indexPath.row)
            plant_comm_names.remove(at: indexPath.row)
            //TODO: Delete the plant from CoreData
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
 

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let dest = segue.destination as! PlantDetailsViewController
        dest.scientific_name = self.selected_plant
    }
 

}
