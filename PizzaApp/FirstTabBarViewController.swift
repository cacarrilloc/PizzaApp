//
//  FirstTabBarViewController.swift
//  PizzaApp
//
//  Created by Carlos Carrillo on 8/11/17.
//  Copyright © 2017 Carlos Carrillo. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class FirstTabBarViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var myLabel: UILabel!
    @IBOutlet weak var myButton: UIButton!
    
    var pizzaToppings:[NSManagedObject] = []
   
    override func viewDidLoad() {
        super.viewDidLoad()
        myButton.layer.cornerRadius = 10
        myTableView.reloadData()
    }
    
    // Load the table every single time you get to this tab
    override func viewWillAppear(_ animated: Bool) {
        self.fetchFromCoreData()
        myTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pizzaToppings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.myTableView.dequeueReusableCell(withIdentifier: "Cell2") else {fatalError("found nil on cell")}
        let pizza = pizzaToppings[indexPath.row]
        cell.textLabel?.text = (pizza.value(forKey: "toppings") as? String)
        return cell
    }
    
    // Read/fetch Data from DB
    func fetchFromCoreData(){
        print("FETCHING!!")
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest <NSManagedObject>(entityName: "Pizzas")
        
        do {
            pizzaToppings = try managedContext.fetch(fetchRequest)
            pizzaToppings = pizzaToppings.reversed()
            DispatchQueue.main.async{
                self.myTableView.reloadData()
            }
        } catch {
            print("could not get info from CoreData")
        }
    }
    
    //MARK:IBAction to delete all data stored in CoreData
    @IBAction func deleteAllCoreData(_ sender:AnyObject){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest <NSManagedObject>(entityName: "Pizzas")
        let DelAllReqVar = NSBatchDeleteRequest(fetchRequest: fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
        do {
            try managedContext.execute(DelAllReqVar)
            fetchFromCoreData()
            myTableView.reloadData()
        }
        catch { print(error) }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
