//
//  AccountViewController.swift
//  helpr
//
//  Created by ryan.konynenbelt on 2018-10-18.
//  Copyright © 2018 ryan.konynenbelt. All rights reserved.
//

import UIKit

class AccountViewController: UIViewController {

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var credentials: UILabel!
    @IBOutlet weak var fName: UILabel!
    @IBOutlet weak var lName: UILabel!
    @IBOutlet weak var phoneNum: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    
    
    @IBOutlet weak var creditCardPicture: UIImageView!
    @IBOutlet weak var creditChange: UIButton!
    @IBOutlet weak var creditInfoLabel: UILabel!
    @IBOutlet weak var creditCardNum: UILabel!
    @IBOutlet weak var cardNumLabel: UILabel!
    @IBOutlet weak var expiryMonth: UILabel!
    @IBOutlet weak var expirySlash: UILabel!
    @IBOutlet weak var expiryYear: UILabel!
    @IBOutlet weak var expiryDateLabel: UILabel!
    @IBOutlet weak var cvv: UILabel!
    @IBOutlet weak var cvvLabel: UILabel!
    
    
    @IBOutlet weak var passwordChange: UIButton!
    @IBOutlet weak var oldPassLabel: UILabel!
    @IBOutlet weak var newPassLabel: UILabel!
    @IBOutlet weak var rNewPassLabel: UILabel!
    
    @IBOutlet weak var oldPassword: UITextField!
    @IBOutlet weak var newPassword: UITextField!
    @IBOutlet weak var rNewPassword: UITextField!
    @IBOutlet weak var passwordSave: UIButton!
    @IBOutlet weak var passwordCancel: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        password.isUserInteractionEnabled = false
        credentials.text = "Technology, Tutoring"
        phoneNum.keyboardType = UIKeyboardType.numberPad
        
        oldPassLabel.isHidden = true
        newPassLabel.isHidden = true
        rNewPassLabel.isHidden = true
        oldPassword.isHidden = true
        newPassword.isHidden = true
        rNewPassword.isHidden = true
        passwordSave.isHidden = true
        passwordCancel.isHidden = true
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        animateViewMoving(up: true, moveValue: 100)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        animateViewMoving(up: false, moveValue: 100)
    }
    func animateViewMoving (up:Bool, moveValue :CGFloat){
        let movementDuration:TimeInterval = 0.3
        let movement:CGFloat = ( up ? -moveValue : moveValue)
        UIView.beginAnimations( "animateView", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration )
        self.view.frame = self.view.frame.offsetBy(dx: 0, dy: movement)
        UIView.commitAnimations()
    }
    
    
    @IBAction func changePhoneNum(_ sender: Any) {
        phoneNum.resignFirstResponder()
    }
    
    @IBAction func changePassword(_ sender: Any) {
        oldPassword.becomeFirstResponder()
        
        textFieldDidBeginEditing(oldPassword)
        textFieldDidBeginEditing(newPassword)
        textFieldDidBeginEditing(rNewPassword)
        
        oldPassLabel.isHidden = false
        newPassLabel.isHidden = false
        rNewPassLabel.isHidden = false
        oldPassword.isHidden = false
        newPassword.isHidden = false
        rNewPassword.isHidden = false
        passwordSave.isHidden = false
        passwordCancel.isHidden = false
        passwordChange.isHidden = true
        
        creditInfoLabel.isHidden = true
        creditCardNum.isHidden = true
        creditCardPicture.isHidden = true
        creditChange.isHidden = true
        cardNumLabel.isHidden = true
        expiryYear.isHidden = true
        expiryMonth.isHidden = true
        expirySlash.isHidden = true
        expiryDateLabel.isHidden = true
        cvv.isHidden = true
        cvvLabel.isHidden = true
    }
    
    
    @IBAction func savePassword(_ sender: Any) {
        let alert1 = UIAlertController(title: "Incorrect Password.", message: "You have entered your current password incorrectly. Please try again.", preferredStyle: UIAlertController.Style.alert)
        
        // addAction code was described by users Oscar Swanros and azureric on StackOverflow at URL: https://stackoverflow.com/questions/24022479/how-would-i-create-a-uialertview-in-swift . There might only be one way of doing this, but credit where it is due.
        alert1.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            switch action.style{
            case .default:
                print("default")
                
            case .cancel:
                print("cancel")
                
            case .destructive:
                print("destructive")
                
            }}))
        
        let alert2 = UIAlertController(title: "Passwords don't match.", message: "Your new password and repeated new password don't match. Please try again.", preferredStyle: UIAlertController.Style.alert)
        
        // addAction code was described by users Oscar Swanros and azureric on StackOverflow at URL: https://stackoverflow.com/questions/24022479/how-would-i-create-a-uialertview-in-swift . There might only be one way of doing this, but credit where it is due.
        alert2.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            switch action.style{
            case .default:
                print("default")
                
            case .cancel:
                print("cancel")
                
            case .destructive:
                print("destructive")
                
            }}))
        
        if oldPassword.text == password.text {
            if newPassword.text == rNewPassword.text{
                password.text = newPassword.text
                
                oldPassword.text = ""
                newPassword.text = ""
                rNewPassword.text = ""
                oldPassLabel.isHidden = true
                newPassLabel.isHidden = true
                rNewPassLabel.isHidden = true
                oldPassword.isHidden = true
                newPassword.isHidden = true
                rNewPassword.isHidden = true
                passwordSave.isHidden = true
                passwordCancel.isHidden = true
                passwordChange.isHidden = false
                
                creditInfoLabel.isHidden = false
                creditCardNum.isHidden = false
                creditCardPicture.isHidden = false
                creditChange.isHidden = false
                cardNumLabel.isHidden = false
                expiryYear.isHidden = false
                expiryMonth.isHidden = false
                expirySlash.isHidden = false
                expiryDateLabel.isHidden = false
                cvv.isHidden = false
                cvvLabel.isHidden = false
                
                oldPassword.resignFirstResponder()
                newPassword.resignFirstResponder()
                rNewPassword.resignFirstResponder()
                
                textFieldDidEndEditing(oldPassword)
                textFieldDidEndEditing(newPassword)
                textFieldDidEndEditing(rNewPassword)
                
            }
            else{
                self.present(alert2, animated: true, completion: nil)
            }
        }
        else{
            self.present(alert1, animated: true, completion: nil)
        }
        
    }
    
    
    @IBAction func creditInfoChange(_ sender: Any) {
    }
    
    
    @IBAction func cancelPassChange(_ sender: Any) {
        oldPassword.text = ""
        newPassword.text = ""
        rNewPassword.text = ""
        oldPassLabel.isHidden = true
        newPassLabel.isHidden = true
        rNewPassLabel.isHidden = true
        oldPassword.isHidden = true
        newPassword.isHidden = true
        rNewPassword.isHidden = true
        passwordSave.isHidden = true
        passwordCancel.isHidden = true
        passwordChange.isHidden = false
        
        creditInfoLabel.isHidden = false
        creditCardNum.isHidden = false
        creditCardPicture.isHidden = false
        creditChange.isHidden = false
        cardNumLabel.isHidden = false
        expiryYear.isHidden = false
        expiryMonth.isHidden = false
        expirySlash.isHidden = false
        expiryDateLabel.isHidden = false
        cvv.isHidden = false
        cvvLabel.isHidden = false
        
        oldPassword.resignFirstResponder()
        newPassword.resignFirstResponder()
        rNewPassword.resignFirstResponder()
        
        textFieldDidEndEditing(oldPassword)
        textFieldDidEndEditing(newPassword)
        textFieldDidEndEditing(rNewPassword)
    }
    
}

