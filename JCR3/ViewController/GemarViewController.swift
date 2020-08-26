//
//  GemarViewController.swift
//  JCR3
//
//  Created by Irenna Nicole on 26/07/20.
//  Copyright © 2020 Irenna Lumbuun. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class GemarEntry {
    @objc dynamic var date: String = ""
    @objc dynamic var ayat: String = ""
    @objc dynamic var rhema: String = ""
    
    init(date: String, ayat: String, rhema: String) {
        self.date = date
        self.ayat = ayat
        self.rhema = rhema
    }
}

class GemarViewController: UIViewController {

    @IBOutlet weak var addEntryBtn: UIButton!
    @IBOutlet weak var bacaRenunganBtn: UIButton!
    @IBOutlet weak var gemarTable: UITableView!
    
    var datasource = [GemarEntry]()
    var currentIndex = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getSate()
        
        //app broke when trying to register uinib
        //gemarTable.register(UINib(nibName: "GemarTableViewCell", bundle: nil), forCellReuseIdentifier: "sate_cell")
        gemarTable.delegate = self
        gemarTable.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        Utilities.styleRectangularButton(btn: bacaRenunganBtn)
        Utilities.styleRectangularButton(btn: addEntryBtn)
        bacaRenunganBtn.backgroundColor = UIColor(red: 199/255, green: 60/255, blue: 22/255, alpha: 1)
        addEntryBtn.backgroundColor = UIColor(red: 2/255, green: 97/255, blue: 48/255, alpha: 1)
    }
    
    func getSate(){
        /*
         If you have time, uncomment the commented part and add some logic to reload database as user scrolls down instead of doing it at once.
         */
        let uuid = Auth.auth().currentUser?.uid
        Database.database().reference().child("jcsaatteduh/sate/\(uuid!)").observeSingleEvent(of: .value, with: { (snapshot) in
            
            if snapshot.childrenCount > 0 {
                for s in snapshot.children.allObjects as! [DataSnapshot]{
                    let str = (s.value as! String)
                    let range = str.index(after: str.startIndex)..<str.index(before: str.endIndex)
                    let items = str[range].components(separatedBy:", ")
                    self.datasource.append(GemarEntry(date:items[0], ayat: items[1], rhema: items[2]))
                }
                self.gemarTable.reloadData()
            }
        }){(error) in
            print(error.localizedDescription)
        }
    }
        
        /*if currentIndex == -1 {
            Database.database().reference().child("jcsaatteduh/sate/\(uuid!)").queryLimited(toFirst: 10).observeSingleEvent(of: .value, with: { (snapshot) in
                
                if snapshot.childrenCount > 0 {
                    for s in snapshot.children.allObjects as! [DataSnapshot]{
                        let str = (s.value as! String)
                        let range = str.index(after: str.startIndex)..<str.index(before: str.endIndex)
                        let items = str[range].components(separatedBy:",")
                        self.datasource.append(GemarEntry(date:items[0], ayat: items[1], rhema: items[2]))
                    }
                    self.currentIndex = 10
                    self.gemarTable.reloadData()
                }
            }){(error) in
                print(error.localizedDescription)
            }
        } //not the first time retrieving data
        else {
            Database.database().reference().child("jcsaatteduh/sate/\(uuid!)").queryLimited(toLast: 11).observeSingleEvent(of: .value, with: { (snapshot) in
                
                if snapshot.childrenCount > 0 {
                    for s in snapshot.children.allObjects as! [DataSnapshot]{
                        let str = (s.value as! String)
                        let range = str.index(after: str.startIndex)..<str.index(before: str.endIndex)
                        let items = str[range].components(separatedBy:",")
                        self.datasource.append(GemarEntry(date:items[0], ayat: items[1], rhema: items[2]))
                    }
                    self.currentIndex += 10
                    self.gemarTable.reloadData()
                }
            }){(error) in
                print(error.localizedDescription)
            }
        }
    }*/
    @IBAction func backButtonTapped(_ sender: Any) {
        //transition to home
        let homeVC = storyboard?.instantiateViewController(identifier: Constants.Storyboard.homeViewController) as? HomeViewController
        
        homeVC?.modalPresentationStyle = .fullScreen
        homeVC?.modalTransitionStyle = .coverVertical
        present(homeVC!, animated: true, completion: nil)
    }
}

class GemarTableViewCell: UITableViewCell{
    @IBOutlet var noteImg: UIImageView!
    @IBOutlet var dateLbl: UILabel!
    @IBOutlet var ayatLbl: UILabel!
    
    var entry: GemarEntry = GemarEntry(date: "", ayat: "", rhema: "") {
        didSet {
            //this gives out the same error. HELP.
            let dateLbl: UILabel = {
                let lbl = UILabel()
                lbl.text = entry.date
                lbl.font = UIFont.systemFont(ofSize: 14)
                lbl.numberOfLines = 1
                return lbl
            }()
            dateLbl.frame = CGRect(x: 70, y: 5, width: self.frame.width, height: 25)
            self.addSubview(dateLbl)
            
            if(ayatLbl != nil){
                print(ayatLbl)
                ayatLbl.text = entry.ayat
            }
        }
    }
    
    override func awakeFromNib() {
       super.awakeFromNib()
        if (noteImg != nil){
            print(noteImg)
            noteImg.image = UIImage(named: "noted")
        }
        
        // display entry
        /*
        var entry: GemarEntry = GemarEntry(date: "", ayat: "", rhema: "") {
            didSet {
                print(dateLbl)
                print(entry.ayat)
                if(dateLbl != nil){
                    print(dateLbl)
                    dateLbl.text = entry.date
                }
                if(ayatLbl != nil){
                    print(ayatLbl)
                    ayatLbl.text = entry.ayat
                }
            }
        }*/
       //custom logic goes here
    }
}

extension GemarViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int{
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasource.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        /* Uncomment to break
        let cell = tableView.dequeueReusableCell(withIdentifier: "sate_cell", for:indexPath) as! GemarTableViewCell
        
        print(cell.subviews)
        cell.noteImg.image = UIImage(named: "noted")
        cell.dateLbl.text = datasource[indexPath.row].date
        cell.ayatLbl.text = datasource[indexPath.row].ayat
        //cell.update(for: datasource[indexPath.row])
        */
        
         let cell = tableView.dequeueReusableCell(withIdentifier: "sate_cell", for:indexPath) as! GemarTableViewCell
        cell.entry = datasource[indexPath.row]
        /*
        if cell.subviews.count == 2{
            //image
             let imageView:UIImageView = {
                 let iv = UIImageView()
                 iv.image = UIImage(named: "noted")
                 iv.contentMode = .scaleAspectFill
                 iv.layer.masksToBounds = true
                 return iv
             }()
             // tanggal
             let dateLbl: UILabel = {
                 let lbl = UILabel()
                 lbl.text = datasource[indexPath.row].date
                 lbl.font = UIFont.systemFont(ofSize: 14)
                 lbl.numberOfLines = 1
                 return lbl
             }()
             
             //ayat
            let ayatLbl: UILabel = {
                 let lbl = UILabel()
                 lbl.text = datasource[indexPath.row].ayat
                 lbl.font = UIFont.systemFont(ofSize: 14)
                 lbl.textColor = UIColor(red: 60/255, green: 60/255, blue: 60/255, alpha: 1)
                 lbl.numberOfLines = 1
                 return lbl
             }()
             
             cell.addSubview(imageView)
             cell.addSubview(dateLbl)
             cell.addSubview(ayatLbl)
        
             imageView.frame = CGRect(x: 20, y: 5, width: 40, height: 40)
             dateLbl.frame = CGRect(x: 70, y: 5, width: self.view.frame.width - 90 , height: 25)
             ayatLbl.frame = CGRect(x: 70, y: 25, width: self.view.frame.width - 90 , height: 25)
        }*/
        return cell
    }
    
    /*
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }*/
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        //open screen where we can see item info and delete
        let item = datasource[indexPath.row]
        guard let vc = storyboard?.instantiateViewController(identifier: "entryGemarVC") as? EntryGemarViewController else{
            return
        }
        vc.item = item
        vc.completionHandler = {
            [weak self] in self?.refresh()
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    /* Uncomment this when adding logic on infinite scrolling
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let currentOffset = scrollView.contentOffset.y
        let maxOffset = scrollView.contentSize.height - scrollView.frame.size.height
        
        if maxOffset -  currentOffset <= 40 {
            getSate()
        }
    }*/
    
    func refresh(){
        print("call refresh")
        getSate()
        gemarTable.reloadData()
    }
}
