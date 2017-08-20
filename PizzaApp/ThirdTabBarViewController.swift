//
//  ThirdTabBarViewController.swift
//  PizzaApp
//
//  Created by Carlos Carrillo on 8/12/17.
//  Copyright © 2017 Carlos Carrillo. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class ThirdTabBarViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var warningLabel: UILabel!
    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var myButton: UIButton!
    
    var pizzaNames:[String] = []
    var pizzaArray:[NSManagedObject] = []
    let myPizza = Pizza(inTopping: .none, toppingsArray: [])
    
    var toppingsArray:[ToppingType] = []
    let arrayTable:[ToppingType] = [.Pepperoni, .Bacon, .Sausage, .Beef, .Jalapenos, .Mozzarella, .Mushrooms, .Onions, .Pineapple,.Artichokes,.Tomatoes,.Red_Onions,.Spinach,.Broccoli,.Olives,.GreenPeppers,.RoastedGarlic,.Roasted_Peppers,.Zucchini,.Potato,.Fish,.BaconCrumble,.BaconStrips,.Chicken,.GroundBeef,.ItalianHam,.ItalianSausage,.SteakStrips,.Salami,.ChipotleSteak,.ChipotleChicken,.ChorizoSausage,.Capicollo]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        warningLabel.lineBreakMode = .byWordWrapping
        warningLabel.numberOfLines = 0;
        myButton.layer.cornerRadius = 10
        self.myTableView.reloadData()
    }
    
    
    // Populate table with output array
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayTable.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = myTableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.text = arrayTable[indexPath.row].rawValue
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //TODO: Deselect Row
        tableView.deselectRow(at: indexPath, animated: true)
        let Ingredient = arrayTable[indexPath.row]
        
        // Add topping to system arrays
        toppingsArray.append(Ingredient)
        //let myPizza = Pizza(inTopping:Ingredient, toppingsArray:toppingsArray)
        let errorMessage = myPizza.addTopping(topping: Ingredient, localArr: toppingsArray)
        
        switch errorMessage {
        case "moreThanTwo":
            toppingsArray.removeLast()
            presentAlert(title: "TOO MUCH \(Ingredient)!!", message: "A pizza cannot have more than 2x the same ingredient!!")
        case "pizzaCompleted":
            presentAlert(title: "YOUR PIZZA IS READY!!", message: "Only 10 toppings per pizza are allowed")
        default:
            break;
        }
    }
    
    //MARK:IBAction to finish order and name pizza
    @IBAction func finishOrder(_ sender:AnyObject) {
        let alert = UIAlertController(title: "THANKS FOR YOUR ORDER!", message: "Type a name or id for your pizza and then click 'OK' to place your order.", preferredStyle: .alert)
        alert.addTextField(configurationHandler: {textField in textField.placeholder = "name"})
        
        let okButton = UIAlertAction(title: "SUBMIT ORDER", style: .default) {
            Void in
            guard let textField = alert.textFields?[0] else {return}
            textField.becomeFirstResponder()
            guard textField.text != nil else {print("no text"); return}
            
            // Save pizza name and clean all the arrays
            //let myPizza = Pizza(inTopping: .none, toppingsArray:self.toppingsArray)
            let name = "===> LATEST ORDER ID: \(textField.text!) Pizza"
            
            self.myPizza.saveNameToCoreData (pizzaName: name)
            self.myPizza.toppingsArray.removeAll()
            self.toppingsArray.removeAll()
            
            print(self.myPizza.toppingsArray)
            print(self.toppingsArray)
        }
        alert.addAction(okButton)
        self.present(alert, animated: true)
        //tabBarController?.selectedIndex = 0
    }
    
    func presentAlert(title:String, message:String){
        let alert = Alert.createAlert(title: title, message: message){
            //[unowned self] in self.parseData()
            print("Alert Activated")
        }
        self.present(alert, animated: true)
    }
}

