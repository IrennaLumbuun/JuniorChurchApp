//
//  SignUpViewController.swift
//  JCR3
//
//  Created by Irenna Nicole on 23/07/20.
//  Copyright © 2020 Irenna Lumbuun. All rights reserved.
//

import UIKit
import FirebaseAuth

class PhoneLoginViewController: UIViewController {
    
    // Outlets
    @IBOutlet weak var phoneNumberTxt: UITextField!
    @IBOutlet weak var daftarBtn: UIButton!
    @IBOutlet weak var errorLbl: UILabel!
    @IBOutlet weak var kodeVerifikasiTxt: UITextField!
    @IBOutlet weak var verifikasiBtn: UIButton!
    
    //Constructor
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpElements()
    }
    
    func setUpElements(){
        errorLbl.alpha = 0
        kodeVerifikasiTxt.alpha = 0
        verifikasiBtn.alpha = 0
        Utilities.initiateBackground(imageName: "welcome.jpg", view: self)
    }
    
    
    // check textfields and validate the data is correct
    // return nil if correct
    // return error if not
    func validateFields() -> String?{
        // check all fields are filled in
        if phoneNumberTxt.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "Semua textbox harus diisi"
        }
        
        return nil
    }
    
    @IBAction func daftarBtnTapped(_ sender: Any) {
        // validate fields
        let error = validateFields()
        if error != nil {
            // show error
            errorLbl.text = error!
            errorLbl.alpha = 1
        } else {
            errorLbl.alpha = 0
            // login user
            PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumberTxt.text!, uiDelegate: nil) { (verificationID, error) in
                if error == nil{
                    UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
                    self.verifikasiBtn.alpha = 1
                    self.kodeVerifikasiTxt.alpha = 1
                    self.phoneNumberTxt.alpha = 0
                    self.daftarBtn.alpha = 0
                } else {
                        self.errorLbl.text = error?.localizedDescription
                        self.errorLbl.alpha = 1
                      return
                    }
            }
        }
    }
    
    @IBAction func verifikasiBtnTapped(_ sender: Any) {
        let kodeVerifikasi = kodeVerifikasiTxt.text?.trimmingCharacters(in: .whitespaces)
        let verificationID = UserDefaults.standard.string(forKey: "authVerificationID")
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationID!, verificationCode: kodeVerifikasi!)
        
        Auth.auth().signIn(with: credential) { (success, error) in
            if error == nil {
                // if is a new user, redirect to daftar
                print("additionalUserInfo ->\(success!.additionalUserInfo as Any)")
                if success!.additionalUserInfo!.isNewUser == true {
                    print("is new user")
                    self.transitionToDaftar()
                }
                else{
                    self.transitionToHome()
                }
          } else {
                self.errorLbl.text = error?.localizedDescription
                self.errorLbl.alpha = 1
          }
        }
    }
    
    func transitionToHome(){
        let homeVC = storyboard?.instantiateViewController(identifier: Constants.Storyboard.homeViewController) as? HomeViewController
        
        view.window?.rootViewController = homeVC
        view.window?.makeKeyAndVisible()
    }
    
    func transitionToDaftar(){
        let daftarVC = storyboard?.instantiateViewController(identifier: Constants.Storyboard.daftarViewController) as? DaftarViewController
        
        view.window?.rootViewController = daftarVC
        view.window?.makeKeyAndVisible()
    }
}
