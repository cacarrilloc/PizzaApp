//
//  Pizza.swift
//  PizzaApp
//
//  Created by Carlos Carrillo on 8/13/17.
//  Copyright © 2017 Carlos Carrillo. All rights reserved.
//


import Foundation
import CoreData
import UIKit


enum ToppingType: String{
    case Pepperoni = "Pepperoni"
    case Bacon = "Bacon"
    case Sausage = "Sausage"
    case Beef = "Beef"
    case Jalapenos = "Jalapenos"
    case Mozzarella = "Mozzarella"
    case Mushrooms = "Mushrooms"
    case Onions = "Onions"
    case Pineapple = "Pineapple"
    case Artichokes = "Artichokes"
    case Tomatoes = "Tomatoes"
    case Red_Onions = "Red_Onions"
    case Spinach = "Spinach"
    case Broccoli = "Broccoli"
    case Olives = "Olives"
    case GreenPeppers = "GreenPeppers"
    case RoastedGarlic = "RoastedGarlic"
    case Roasted_Peppers = "Roasted_Peppers"
    case Zucchini = "Zucchini"
    case Potato = "Potato"
    case Fish = "Fish"
    case BaconCrumble = "BaconCrumble"
    case BaconStrips = "BaconStrips"
    case Chicken = "Chicken"
    case GroundBeef = "GroundBeef"
    case ItalianHam = "ItalianHam"
    case ItalianSausage = "ItalianSausage"
    case SteakStrips = "SteakStrips"
    case Salami = "Salami"
    case ChipotleSteak = "ChipotleSteak"
    case ChipotleChicken = "ChipotleChicken"
    case ChorizoSausage = "ChorizoSausage"
    case Capicollo = "Capocollo"
    case none = "none"
    
}


protocol PizzaProto:class{
    var topping:ToppingType {get}
    var toppingsArray:[ToppingType] {get set}
    
    func addTopping(topping: ToppingType, localArr: [ToppingType]) -> String
    func saveNameToCoreData (pizzaName: String) -> Void
    func saveToppingToCoreData (topping: ToppingType) -> Void
}

extension PizzaProto{
    
    // Add topping to pizza 
    func addTopping(topping: ToppingType, localArr: [ToppingType]) -> String {
        var alertMessage = ""
        var tempArray:[String] = []
        
        if (toppingsArray.count >= 0 && toppingsArray.count < 11) {
            tempArray = toppingsArray.map{$0.rawValue}
            print(tempArray)
            let filteredArray = tempArray.filter{$0.contains(topping.rawValue)}
            
            if filteredArray.count > 2 {
                print("moreThanTwo")
                tempArray.removeAll()
                toppingsArray.removeLast()
                alertMessage = "moreThanTwo"
                
            } else {
                self.toppingsArray.append(topping)
                self.saveToppingToCoreData (topping: topping)
            }
        }else{
            print("pizzaCompleted")
            alertMessage = "pizzaCompleted"
        }
        return alertMessage
    }
    
    // Save Pizza Name to CoreData
    func saveNameToCoreData (pizzaName: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let managedContext = appDelegate.persistentContainer.viewContext
        guard let entity = NSEntityDescription.entity(forEntityName: "Pizzas", in: managedContext) else {return}
        let name = NSManagedObject(entity: entity, insertInto: managedContext)
        name.setValue(pizzaName, forKey: "toppings")
        do {
            try managedContext.save()
        } catch {
            print("could not save data")
        }
    }
    
    // Save topping to CoreData
    func saveToppingToCoreData (topping: ToppingType) {
        let toppingIn = topping.rawValue
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let managedContext = appDelegate.persistentContainer.viewContext
        guard let entity = NSEntityDescription.entity(forEntityName: "Pizzas", in: managedContext) else {return}
        let pizza = NSManagedObject(entity: entity, insertInto: managedContext)
        pizza.setValue(toppingIn, forKey: "toppings")
        do {
            try managedContext.save()
        } catch {
            print("could not save data")
        }
    }
}


class Pizza:PizzaProto {
    var topping: ToppingType
    var toppingsArray: [ToppingType]
    
    init(inTopping:ToppingType, toppingsArray:[ToppingType]){
        self.topping = inTopping
        self.toppingsArray = toppingsArray
    }
}

