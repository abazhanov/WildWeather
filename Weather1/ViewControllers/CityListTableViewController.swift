//
//  CityListTableViewController.swift
//  Weather1
//
//  Created by Artem Bazhanov on 08.05.2021.
//

import UIKit

protocol AddCityViewControllerDelegate {
    func updateCities(newCity: String)
}

class CityListTableViewController: UITableViewController {
    
    var cities: [String] = []
    var delegate: CityListTableViewControllerDelegate!

    override func viewDidLoad() {
        super.viewDidLoad()
        cities = StorageManager.shared.getCities()
        //print("cities: ", cities)
        navigationItem.leftBarButtonItem = editButtonItem
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let addCityVC = segue.destination as? AddCityViewController else { return }
        addCityVC.delegate = self
    }
    
    
    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        print("cities.count: ", cities.count)
        return cities.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! CityListTableViewCell
        cell.textLabel?.text = cities[indexPath.row]

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
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            // Delete the row from the data source
            print("???? ????????????????:", cities)
            
            StorageManager.shared.deleteCity(at: indexPath.row)
            cities = StorageManager.shared.getCities()
            print("?????????? ????????????????:", cities)
            
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    
//    override func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
//        false
//    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let currentCity = cities.remove(at: sourceIndexPath.row)
        cities.insert(currentCity, at: destinationIndexPath.row)
        StorageManager.shared.updateCities(cities: cities)
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension CityListTableViewController: AddCityViewControllerDelegate {
    func updateCities(newCity: String) {
        //cities.append(newCity)
        //UserDefaults.standard.set(cities, forKey: "Cities")
        
        StorageManager.shared.addCity(city: newCity)
        cities = StorageManager.shared.getCities()
        
        tableView.reloadData()
    }
}

extension CityListTableViewController {
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("viewWillDisappear")
        StorageManager.shared.updateCities(cities: cities)
        print("????: ", cities)
        cities = StorageManager.shared.getCities()
        print("??????????: ", cities)
        
        delegate.updateCities(cities: cities)
        
    }
}


