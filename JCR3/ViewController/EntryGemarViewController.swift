//
//  EntryGemarViewController.swift
//  JCR3
//
//  Created by Irenna Nicole on 30/07/20.
//  Copyright © 2020 Irenna Lumbuun. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class EntryGemarViewController: UIViewController {
    
    //outlet
    @IBOutlet weak var tanggalLbl: UILabel!
    @IBOutlet weak var ayatTxt: UITextField!
    @IBOutlet weak var rhemaTxt: UITextView!
    
    public var item: GemarEntry?
    public var completionHandler: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // if there is no item, render date and empty text field.
        // else, render item
        if item != nil {
            tanggalLbl.text = item?.date
            ayatTxt.text = item?.ayat
            rhemaTxt.text = item?.rhema
        } else {
            tanggalLbl.text = Utilities.getFormattedDate(desiredFormat: "dd MMMM yyyy")
        }
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "save", style: .done, target: self, action: #selector(simpanBtnTapped))
    }
    
    override func viewDidLayoutSubviews() {
        rhemaTxt.layer.backgroundColor = UIColor.white.cgColor
        rhemaTxt.layer.borderColor = UIColor.lightGray.cgColor
        rhemaTxt.layer.borderWidth = 1
        rhemaTxt.layer.cornerRadius = 5
        rhemaTxt.layer.masksToBounds = true
    }
    
    @IBAction func simpanBtnTapped(_ sender: Any) {
        let uuid = Auth.auth().currentUser?.uid
        
        //save to database
        Database.database().reference().child("jcsaatteduh/sate/\(uuid!)").observeSingleEvent(of: .value, with: { (snapshot) in
            let data = snapshot.value as? NSMutableDictionary
            var entries: [String: String] = data as? [String : String] ?? [String: String]()
            // check whether to save as new item or as existing item
            let key = (self.item == nil) ? Utilities.getFormattedDate(desiredFormat: "MMddyyyyHHmmss") : self.item?.key
            entries[key!] = "[\(self.tanggalLbl.text ?? ""), \(self.ayatTxt.text ?? ""), \(self.rhemaTxt.text ?? "")]"
            Database.database().reference().child("jcsaatteduh/sate/\(uuid!)").setValue(entries)
            
            //empty text field & go back to root controller
            self.ayatTxt.text = ""
            self.rhemaTxt.text = ""
            self.transitionToGemar()
           })
        {(error) in
           print(error.localizedDescription)
       }
    }
    func transitionToGemar(){
        let gemarVC = storyboard?.instantiateViewController(identifier: "gemarVC") as? GemarViewController
        
        navigationController?.pushViewController(gemarVC!, animated: true)
    }
    
}
