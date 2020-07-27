//
//  Utilities.swift
//  JCR3
//
//  Created by Irenna Nicole on 24/07/20.
//  Copyright © 2020 Irenna Lumbuun. All rights reserved.
//

import Foundation
import UIKit

class Utilities{
    
    //TODO: check regex.
    /**
         - Password has to be at least 8 characters
         - Contains a character, a number, a special character
     */
    static func isAStrongPassword(password: String) -> Bool{
        let passwordTest = NSPredicate(format: "SELF MATCHES %@",
            "^(?=.*[a-z])(?=.*[$@$#!%*?&])(A-Za-z\\d$@$#!%*?&]{8,}")
        return passwordTest.evaluate(with:password)
    }
    
    static func styleButton(btn: UIButton){
        btn.layer.cornerRadius = 10
    }
    // TODO: check phoneNumber
    static func initiateBackground(imageName: String, view: UIViewController) {
        let backgroundImage = UIImage.init(named: imageName)
        let backgroundImageView = UIImageView.init(frame: view.view.frame)

        backgroundImageView.image = backgroundImage
        backgroundImageView.contentMode = .scaleAspectFill

        view.view.insertSubview(backgroundImageView, at: 0)
    }
    
    /* buat kalo perlu picker lagi
     
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Number of columns of data
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) ->Int {
        return pickerData.count
    }
    // The data to return fopr the row and component (column) that's being passed in
      func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
          return pickerData[row]
      }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // This method is triggered whenever the user makes a change to the picker selection.
        // The parameter named row and component represents what was selected.
        print("component: \(component)")
        print("row: \(row)")
    }
    */
}