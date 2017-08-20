//
//  SecondTabBarViewController.swift
//  PizzaApp
//
//  Created by Carlos Carrillo on 8/11/17.
//  Copyright © 2017 Carlos Carrillo. All rights reserved.
//

import Foundation
import UIKit

class SecondTabBarViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var myButton3: UIButton!
    @IBOutlet weak var myButton2: UIButton!
    @IBOutlet weak var myButton1: UIButton!
    
    var topLimit = 0
    var copyArray:[[String]] = []
    var outputArray:[[String]] = []
    let myPizza = Pizza(inTopping: .none, toppingsArray: [])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myButton1.layer.cornerRadius = 10
        myButton2.layer.cornerRadius = 10
        myButton3.layer.cornerRadius = 10
        DispatchQueue.main.async {
            self.readAndCopyJson()
        }
        myTableView.reloadData()
    }
 
    // Load the table every single time you get to this tab
    override func viewWillAppear(_ animated: Bool) {
        myTableView.reloadData()
    }
    
    // Populate and Process TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return outputArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.myTableView.dequeueReusableCell(withIdentifier: "Cell3") else {fatalError("found nil on cell")}
        cell.textLabel?.text = outputArray[indexPath.row].flatMap{$0}.joined(separator: ", ")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //TODO: Deselect Row
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func selectTop10(_ sender:UIButton) {
        topLimit = 10
        outputArray.removeAll() // Clean Table
        for i in 0..<topLimit {
            outputArray.append(copyArray[i])
        }
        myTableView.reloadData()
    }
    
    @IBAction func selectTop20(_ sender:UIButton) {
        topLimit = 20
        outputArray.removeAll() // Clean Table
        for i in 0..<topLimit {
            outputArray.append(copyArray[i])
        }
        myTableView.reloadData()
    }
    
    @IBAction func selectTop50(_ sender:UIButton) {
        topLimit = 50
        outputArray.removeAll() // Clean Table
        for i in 0..<topLimit {
            outputArray.append(copyArray[i])
        }
        myTableView.reloadData()
    }
    
    func readAndCopyJson() {
        do {
            if let file = Bundle.main.url(forResource: "assignment", withExtension: "json") {
                let data = try Data(contentsOf: file)
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                guard let jsonArray = json as? [[String:Any]] else {return}
                let toppingsArrays = jsonArray.flatMap{$0["toppings"] as? [String]}
                let countedArray = NSCountedSet(array: toppingsArrays)
                let sortedArray = countedArray.sorted {return countedArray.count(for:$0) > countedArray.count(for:$1)} as! [[String]]
                // Copy sorted array to Pizza class
                copyArray = sortedArray.map{$0}
            
            } else {
                print("no file")
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
