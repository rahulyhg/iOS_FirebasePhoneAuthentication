//
//  ViewController.swift
//  FirebasePhoneAuthentication
//
//  Created by AliMac on 8/27/17.
//  Copyright © 2017 AliMac. All rights reserved.
//

import UIKit
import FirebaseAuth

class ViewController: UIViewController
{

    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var verficationCodeTextField: UITextField!
    @IBOutlet weak var statusLabel: UILabel!
    
    var verificationId : String = "";
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        if let user = Auth.auth().currentUser
        {
            print(user.phoneNumber ?? "No Phone Number");
            print(user);
        }
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }

    @IBAction func sendVerificationCode(_ sender: Any)
    {
        let phoneNumber = phoneNumberTextField.text!;
        print(phoneNumber);
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber)
        {
            (verificationID, error) in
            if let error = error
            {
                print(error);
                print("could not send SMS");
                return
            }
            
            UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
            self.verificationId = verificationID!;
        }

    }

    @IBAction func login(_ sender: Any)
    {
        let verificationCode = self.verficationCodeTextField.text;
        
        print(self.verificationId);
        let verificationID = UserDefaults.standard.string(forKey: "authVerificationID")
        print(verificationID ?? "no verificatoin id");
        
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: self.verificationId,verificationCode: verificationCode!);
        
        Auth.auth().signIn(with: credential)
        {
            (user, error) in
            if let error = error
            {
                print(error);
                return
            }
            
            print("User is signed in");
            print(Auth.auth().currentUser?.phoneNumber ?? "no phone number");
            
        }
    
    }
    
}

