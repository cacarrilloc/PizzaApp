//
//  ViewController.swift
//  PizzaApp
//
//  Created by Carlos Carrillo on 8/9/17.
//  Copyright © 2017 Carlos Carrillo. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import SwiftKeychainWrapper
import LocalAuthentication


class LoginViewController: UIViewController {
    
    @IBOutlet weak var myButton: UIButton!
    @IBOutlet weak var passField:UITextField!
    @IBOutlet weak var emailField:UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        passField.delegate = self
        emailField.delegate = self
        Authentication.shared.currentVC = self
        myButton.layer.cornerRadius = 10
        assignbackground()
    
        /*
        let usrProfs = UserDefaults.standard
        guard let email = usrProfs.object(forKey: Constants.KUserKey) as? String else {return}
        self.emailField.text = email
        guard let tidEnabled = usrProfs.value(forKey: Constants.KEnabledTID) as? Bool else {return}
        guard tidEnabled else {return}
        let authContext = LAContext()
        var authError = NSError?()
        guard authContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: authError) else {return}
        static usrProfs.bool(forKey: Constants.KEnabledTID) else {return}
        if authContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: AuthError) else {return}
        
        authContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Use touch ID to get ypur pizza") {
            (success, error) in
            guard let pass = KeychainWrapper.standard.object(forKey: Constants.KPassKey) as? String else {return}
            self.loginToFirebase(user: email, pass: pass)
        }
        */
    }
    
    func assignbackground(){
        let background = UIImage(named: "pizzaCat")
        var imageView : UIImageView!
        imageView = UIImageView(frame: view.bounds)
        imageView.contentMode =  UIViewContentMode.scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = background
        imageView.center = view.center
        view.addSubview(imageView)
        self.view.sendSubview(toBack: imageView)
    }
    
    //MARK Gesture Recognizer
    @IBAction func tapedView(_sender:AnyObject){
        emailField.resignFirstResponder()
        passField.resignFirstResponder()
    }
    
    
    func checkFields() {
        guard let email = emailField.text else{
            presentAlert(title: "Error", message: "Email field field should not be empty")
            return
        }
        guard email.isValidEmail() else {
            presentAlert(title: "Error", message: "Email does NOT have a valid format")
            return
        }
        guard let password = passField.text  else {
            presentAlert(title: "Error", message: "Password is invalid")
            return
        }
        guard password.characters.count > 5 else {
            presentAlert(title: "Error", message: "Password is tooo short")
            return
        }
    }
    
    func loginToFirebase(user:String, pass:String) {
        print("Login to firebase")
        Authentication.shared.fireBaseAuth.signIn(withEmail: user, password: pass) {
        (fUser, error) in
            guard error == nil else {return}
            guard let _ = fUser else {return}
            let userPrefs = UserDefaults.standard
            userPrefs.setValue(user, forKey: Constants.KUserKey)
            userPrefs.synchronize()
            
            let alert = Alert.createYesNoAlert(title: "Touch ID", message: "Would you like to use touch Screen?", yesCompletion: {
                userPrefs.setValue(true, forKey: Constants.KEnabledTID)
                userPrefs.synchronize()
                KeychainWrapper.standard.set(pass, forKey: Constants.KEnabledTID)
                
            }, noCompletion: {
                userPrefs.setValue(false, forKey: Constants.KEnabledTID)
                userPrefs.synchronize()
                KeychainWrapper.standard.removeObject(forKey: Constants.KEnabledTID)
            })
            self.present(alert, animated: true)
        }
    }
    
    func presentAlert(title:String, message:String){
        let alert = Alert.createAlert(title: title, message: message){
            //[unowned self] in
            //self.parseData()
            print("Alert Activated")
        }
        self.present(alert, animated: true)
    }
    
    /*
    func parseData(){
        Networking.getData(from: "https://swapi.co/api/people/1") {(error,data) in
            guard error == nil else {
                print("Error: \(error!.localizedDescription)")
                return
            }
            guard let data = data else {print("no data"); return}
            guard let object = try? JSONSerialization.jsonObject(with: data) else {return}
            guard let dictionary = object as? [String:Any]
                else {return}
            guard let name = dictionary["name"] as? String else{return}
            print(name)
        }
    }
    */
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension LoginViewController: UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard string == "\n" else {return true}
        if textField === emailField {
            textField.resignFirstResponder()
            self.checkFields()
        } else {
            textField.resignFirstResponder()
            self.checkFields()
        }
    return true
    }
}


extension LoginViewController:loginDelegate {
    func appStateDidChange (to value: Bool) {
        //TODO: call segue,
        print("On view controller value = \(value)")
    }
    
}
