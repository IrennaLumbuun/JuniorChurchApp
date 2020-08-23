//
//  HomeViewController.swift
//  JCR3
//
//  Created by Irenna Nicole on 23/07/20.
//  Copyright © 2020 Irenna Lumbuun. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class HomeViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    

    @IBOutlet weak var newsUpdateSearchBar: UISearchBar!
    @IBOutlet weak var inboxUpdateBtn: UIButton!
    @IBOutlet weak var profileBtn: UIButton!
    @IBOutlet weak var radioBtn: UIButton!
    @IBOutlet weak var gemarBtn: UIButton!
    @IBOutlet weak var btnGroupCollectionView: UICollectionView!
    @IBOutlet weak var mainTableView: UITableView!
    @IBOutlet weak var mainBtnView: UIView!
    
    //setting up scrollable button group here
    private let cellId = "btnCell"
    
    //setting up scrollable main table here
    var mainTableData = [NotifEntry]()
    
    
    override func viewDidLayoutSubviews() {
        Utilities.styleView(v: mainBtnView)
        Utilities.styleCircularButton(btn: profileBtn)
        Utilities.styleCircularButton(btn: radioBtn)
        Utilities.styleCircularButton(btn: gemarBtn)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //setup()
        
        // for up scrollable Main Table
        mainTableView.delegate = self
        mainTableView.dataSource = self
        
        //for scrollable button group
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        btnGroupCollectionView.backgroundColor = UIColor.clear
        btnGroupCollectionView.collectionViewLayout = layout
        btnGroupCollectionView.translatesAutoresizingMaskIntoConstraints = false
        btnGroupCollectionView.register(BtnCell.self, forCellWithReuseIdentifier: "btnCell")
        
        getDataForMainTable()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //in a weird case where user is has not set up their name yet
        if Auth.auth().currentUser?.displayName == nil {
            self.transitionToDaftar()
        }
    }
    
    func transitionToDaftar(){
        let daftarVC = storyboard?.instantiateViewController(identifier: Constants.Storyboard.daftarViewController) as? DaftarViewController
        
        view.window?.rootViewController = daftarVC
        view.window?.makeKeyAndVisible()
    }
    
    // This function append data for main table view
    // (I assume) in reality we would retrieve data from firebase instead of hardcoding this. But I'm not sure. We'll see what they come up with.
    func getDataForMainTable(){
        self.mainTableData.append(NotifEntry(img: "dm", header:"Ibadah Raya", subHeader: "Youtube GBI Modernland", text:"Minggu, 19 Juli 2020 \nMulai pukul 07.00 WIB \nwww.youtube.com/gbimodernlandr3"))
        self.mainTableData.append(NotifEntry(img: "dm", header:"Receive the Fire", subHeader: "Of the Third pentacost", text:"Pdt Kristina Faraknimela \n24 Juli 2020 \n7 PM | Youtube GBI Modernland"))
        self.mainTableData.append(NotifEntry(img: "dm", header:"Social Media", subHeader: "Follow and Share", text:"JC Center \nOffice lorem ipsum placeholder note \nlorem ipsum placeholder note"))
        self.mainTableData.append(NotifEntry(img: "dm", header:"Welcome", subHeader: "Come Join Us", text:"JCR3 Apps"))
    }
    
    // These function below render buttons to View
    //override func for collection view layout
    let btnName: [String] = ["Live Streaming", "Warrior Bride", "SBS COOL", "Dukungan Doa"]
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 14 * btnName[indexPath.row].count, height: 35)
       }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath as IndexPath) as! BtnCell
        
        let button = UIButton()
        button.tag = indexPath.row
        button.setTitle(btnName[indexPath.row], for: .normal)
        button.backgroundColor = UIColor.white
        button.setTitleColor(UIColor.black, for: .normal)
        button.addTarget(self, action: #selector(self.btnClicked), for: UIControl.Event.touchUpInside)

        // frame and padding
        button.frame = CGRect(x: 10, y: 10, width: 14 * btnName[indexPath.row].count, height: 20)
        button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        button.titleEdgeInsets = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        //button.sizeToFit()
        button.layer.cornerRadius = 10
        
        //add shadow
        button.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        button.layer.shadowOffset = CGSize(width: 0.0, height: 1)
        button.layer.shadowOpacity = 1.0
        button.layer.shadowRadius = 1.0
        button.layer.masksToBounds = false
        
        cell.btn = button
        cell.setupViews()
        return cell
    }

    @objc func btnClicked(sender : UIButton) {
        //get buttonName
        let btnTag = sender.tag
        // 0 -> pop up with link
        if btnTag == 0 {
            let popUp = storyboard?.instantiateViewController(identifier: Constants.Storyboard.liveStreamPopUp) as? StreamingPopUpViewController
            self.addChild(popUp!)
            popUp!.view.frame = self.view.frame
            self.view.addSubview(popUp!.view)
            popUp?.didMove(toParent: self)
            
        }
        // 1 -> auto download warrior bride
        if btnTag == 1 {
            Database.database().reference().child("Dashboard").observeSingleEvent(of: .value, with: { (snapshot) in
                  // Get user value
                    let data = snapshot.value as? NSDictionary
                    var url = data?["Warrior"] as? String ?? ""
                    url = url.replacingOccurrences(of: "\\/", with: "/").replacingOccurrences(of:"\"", with: "")
                    let toOpen = URL(string: url)
                    UIApplication.shared.open((toOpen)!)
                  }) {(error) in
                    print("error")
                    print(error.localizedDescription)
                }
            }
        
        if btnTag == 2 {
            Database.database().reference().child("Dashboard").observeSingleEvent(of: .value, with: { (snapshot) in
              // Get user value
                let data = snapshot.value as? NSDictionary
                var url = data?["SBS"] as? String ?? ""
                url = url.replacingOccurrences(of: "\\/", with: "/").replacingOccurrences(of:"\"", with: "")
                let toOpen = URL(string: url)
                UIApplication.shared.open((toOpen)!)
              }) {(error) in
                print("error")
                print(error.localizedDescription)
            }
        }
    
        if btnTag == 3 {
            let dukunganDoaVC = storyboard?.instantiateViewController(identifier: Constants.Storyboard.dukunganDoaViewController) as? DukunganDoaViewController
            
            view.window?.rootViewController = dukunganDoaVC
            view.window?.makeKeyAndVisible()
        }
    }
    
}

class BtnCell: UICollectionViewCell {
    var btn: UIButton!
    
    override init(frame:CGRect) {
        super.init(frame:frame)
        //setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        addSubview(btn)
    }
    
}

class NotifEntry {
    @objc dynamic var img: String = ""
    @objc dynamic var header: String = ""
    @objc dynamic var subHeader: String = ""
    @objc dynamic var text: String = ""
    
    init(img: String, header: String, subHeader: String, text: String) {
        self.img = img
        self.header = header
        self.subHeader = subHeader
        self.text = text
    }
}

extension HomeViewController:UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int{
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mainTableData.count
    }
    //Edit this if needed. Or figure out a way to use AirTable because apparently that's what Ko Anton wants
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "main_cell", for:indexPath)
        cell.textLabel?.text = " \(mainTableData[indexPath.row].header)\n\(mainTableData[indexPath.row].subHeader) "
        cell.textLabel?.numberOfLines = 0
        return cell
    }
    /* Uncomment this to set height if needed
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }*/
}
