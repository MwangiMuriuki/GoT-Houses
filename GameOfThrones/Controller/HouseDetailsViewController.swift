//
//  HouseDetailsViewController.swift
//  GameOfThrones
//
//  Created by Ernest Mwangi on 13/8/2022.
//

import UIKit

class HouseDetailsViewController: UIViewController {

    var houseData: HousesDataClass?
    var isFromHomePage: Bool?
    var passedOverLordUrl: String?
    var activityIndicator = UIActivityIndicatorView(style: .medium)

    @IBOutlet weak var regionView: UIView!
    @IBOutlet weak var coatOfArmsView: UIView!
    @IBOutlet weak var wordsView: UIView!
    @IBOutlet weak var founderView: UIView!
    @IBOutlet weak var foundedView: UIView!
    @IBOutlet weak var overlordView: UIView!
    @IBOutlet weak var currentLordView: UIView!
    @IBOutlet weak var heirView: UIView!
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var seatsView: UIView!
    @IBOutlet weak var weaponsView: UIView!
    @IBOutlet weak var cadetView: UIView!
    @IBOutlet weak var membersView: UIView!


    @IBOutlet weak var regionLabel: UILabel!
    @IBOutlet weak var coatOfArmsLabel: UILabel!
    @IBOutlet weak var wordsLabel: UILabel!
    @IBOutlet weak var foundedLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        getControllerSource()
        setupTapGestures()

        // Do any additional setup after loading the view.
    }

    func setupViews(){
        self.title = houseData?.name
        regionView.layer.cornerRadius = 5
        coatOfArmsView.layer.cornerRadius = 5
        wordsView.layer.cornerRadius = 5
        founderView.layer.cornerRadius = 5
        foundedView.layer.cornerRadius = 5
        overlordView.layer.cornerRadius = 5
        currentLordView.layer.cornerRadius = 5
        heirView.layer.cornerRadius = 5
        titleView.layer.cornerRadius = 5
        seatsView.layer.cornerRadius = 5
        weaponsView.layer.cornerRadius = 5
        cadetView.layer.cornerRadius = 5
        membersView.layer.cornerRadius = 5

        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.7041453178)
        activityIndicator.color = .white
        activityIndicator.layer.cornerRadius = 10
        view.addSubview(activityIndicator)
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        activityIndicator.heightAnchor.constraint(equalToConstant: 90).isActive = true
        activityIndicator.widthAnchor.constraint(equalToConstant: 90).isActive = true
    }

    func getControllerSource(){
        if isFromHomePage!{
            loadViewData()
        }
        else{
            fetchHouseData()
        }
    }

    func loadViewData(){
        var houseRegion = houseData?.region
        var houseCoatOfArms = houseData?.coatOfArms
        var houseWords = houseData?.words
        var houseFounded = houseData?.founded

        if houseRegion == ""{
            houseRegion = "N/A"
        }
        if houseCoatOfArms == ""{
            houseCoatOfArms = "N/A"
        }
        if houseWords == ""{
            houseWords = "N/A"
        }
        if houseFounded == ""{
            houseFounded = "N/A"
        }

        regionLabel.text = houseRegion
        coatOfArmsLabel.text = houseCoatOfArms
        wordsLabel.text = houseWords
        foundedLabel.text = houseFounded
    }

    func fetchHouseData(){
        activityIndicator.startAnimating()
//        serviceManager.fetchAllHouses()

        let urlString = passedOverLordUrl
        print("FullUrl: \(String(describing: urlString))")
        if let fullUrl = URL(string: urlString!){

            let task = Configs.session.dataTask(with: fullUrl) { [self] data, response, error in
                if error != nil {
                    activityIndicator.stopAnimating()
                    print("List Error: \(String(describing: error))")
                    return
                }

                if let safeData = data {
                    if let fetchedData = self.parseHouseJSON(housesListData: safeData){

                        self.houseData = fetchedData

                        DispatchQueue.main.async { [self] in
                            activityIndicator.stopAnimating()
                            loadViewData()
//                            regionLabel.text = houseData?.region ?? ""
//                            coatOfArmsLabel.text = houseData?.coatOfArms ?? "N/A"
//                            wordsLabel.text = houseData?.words ?? "N/A"
//                            foundedLabel.text = houseData?.founded ?? "N/A"
                        }
                    }
                }
            }
            task.resume()
        }
    }

    func parseHouseJSON(housesListData: Data) -> HousesDataClass?{
        do {
            let decodedHousesList = try JSONDecoder().decode(HousesDataClass.self, from: housesListData)

            return decodedHousesList

        } catch {
            print(error)
            return nil
        }
    }

    // MARK: - Setup Tap Gestures
    func setupTapGestures(){
        let currentLordTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(currentLordTapHandler(tapGestureRecognizer:)))
        let founderTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(founderTapHandler(tapGestureRecognizer:)))
        let heirTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(heirTapHandler(tapGestureRecognizer:)))
        let titlesTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(titlesTapHandler(tapGestureRecognizer:)))
        let seatsTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(seatsTapHandler(tapGestureRecognizer:)))
        let weaponsTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(weaponsTapHandler(tapGestureRecognizer:)))
        let overLordTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(overLordTapHandler(tapGestureRecognizer:)))
        let cadetTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(cadetTapHandler(tapGestureRecognizer:)))
        let membersTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(membersTapHandler(tapGestureRecognizer:)))


        currentLordView.isUserInteractionEnabled = true
        founderView.isUserInteractionEnabled = true
        heirView.isUserInteractionEnabled = true
        overlordView.isUserInteractionEnabled = true
        titleView.isUserInteractionEnabled = true

        currentLordView.addGestureRecognizer(currentLordTapGestureRecognizer)
        founderView.addGestureRecognizer(founderTapGestureRecognizer)
        heirView.addGestureRecognizer(heirTapGestureRecognizer)
        titleView.addGestureRecognizer(titlesTapGestureRecognizer)
        seatsView.addGestureRecognizer(seatsTapGestureRecognizer)
        weaponsView.addGestureRecognizer(weaponsTapGestureRecognizer)
        overlordView.addGestureRecognizer(overLordTapGestureRecognizer)
        cadetView.addGestureRecognizer(cadetTapGestureRecognizer)
        membersView.addGestureRecognizer(membersTapGestureRecognizer)

    }


    // MARK: - Current Lord Tap Handler
    @objc func currentLordTapHandler(tapGestureRecognizer:UITapGestureRecognizer){
        let singleCharacterUrl = houseData?.currentLord
        if singleCharacterUrl!.isEmpty || singleCharacterUrl == ""{
            let alertMessage = "We currently don't have this data. Please try again later."
            let ac = UIAlertController(title: "Missing Data", message: alertMessage, preferredStyle: .alert)
            let submitAction = UIAlertAction(title: "Done", style: .default) { (action) in
                self.dismiss(animated: true)
            }
            ac.addAction(submitAction)
            present(ac, animated: true, completion: nil)
        }
        else{
            let charactersVC = UIStoryboard(name: "Characters", bundle: nil).instantiateViewController(withIdentifier: "CharactersViewController") as! CharactersViewController
            charactersVC.passedUrl = singleCharacterUrl
            charactersVC.titleLabel = "Current Lord"
            navigationController?.pushViewController(charactersVC, animated: true)
        }
    }

    // MARK: - Founder Tap Handler

    @objc func founderTapHandler(tapGestureRecognizer:UITapGestureRecognizer){
        let founderUrl = houseData?.founder
        if founderUrl!.isEmpty || founderUrl == ""{
            let alertMessage = "We currently don't have this data. Please try again later."
            let ac = UIAlertController(title: "Missing Data", message: alertMessage, preferredStyle: .alert)
            let submitAction = UIAlertAction(title: "Done", style: .default) { (action) in
                self.dismiss(animated: true)
            }
            ac.addAction(submitAction)
            present(ac, animated: true, completion: nil)
        }
        else{
            let charactersVC = UIStoryboard(name: "Characters", bundle: nil).instantiateViewController(withIdentifier: "CharactersViewController") as! CharactersViewController
            charactersVC.passedUrl = founderUrl
            charactersVC.titleLabel = "Founder"
            navigationController?.pushViewController(charactersVC, animated: true)
        }
    }

    // MARK: - Heir Tap Handler

    @objc func heirTapHandler(tapGestureRecognizer:UITapGestureRecognizer){
        let heirUrl = houseData?.heir
        if heirUrl!.isEmpty || heirUrl == ""{
            let alertMessage = "We currently don't have this data. Please try again later."
            let ac = UIAlertController(title: "Missing Data", message: alertMessage, preferredStyle: .alert)
            let submitAction = UIAlertAction(title: "Done", style: .default) { (action) in
                self.dismiss(animated: true)
            }
            ac.addAction(submitAction)
            present(ac, animated: true, completion: nil)
        }
        else{
            let charactersVC = UIStoryboard(name: "Characters", bundle: nil).instantiateViewController(withIdentifier: "CharactersViewController") as! CharactersViewController
            charactersVC.passedUrl = heirUrl
            charactersVC.titleLabel = "Heir"
            navigationController?.pushViewController(charactersVC, animated: true)
        }
    }

    // MARK: - Titles Tap Handler

    @objc func titlesTapHandler(tapGestureRecognizer:UITapGestureRecognizer){
        let houseTitles = houseData?.titles
        if houseTitles!.isEmpty || houseTitles?.count == 0{
            let alertMessage = "We currently don't have this data. Please try again later."
            let ac = UIAlertController(title: "Missing Data", message: alertMessage, preferredStyle: .alert)
            let submitAction = UIAlertAction(title: "Done", style: .default) { (action) in
                self.dismiss(animated: true)
            }
            ac.addAction(submitAction)
            present(ac, animated: true, completion: nil)
        }
        else{
            let listsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ListsViewController") as! ListsViewController
            listsVC.tableData = houseTitles!
            listsVC.listTitle = "Titles"
            navigationController?.pushViewController(listsVC, animated: true)
        }
    }

    // MARK: - Seats Tap Handler

    @objc func seatsTapHandler(tapGestureRecognizer:UITapGestureRecognizer){
        let houseTitles = houseData?.seats
        if houseTitles!.isEmpty || houseTitles?.count == 0{
            let alertMessage = "We currently don't have this data. Please try again later."
            let ac = UIAlertController(title: "Missing Data", message: alertMessage, preferredStyle: .alert)
            let submitAction = UIAlertAction(title: "Done", style: .default) { (action) in
                self.dismiss(animated: true)
            }
            ac.addAction(submitAction)
            present(ac, animated: true, completion: nil)
        }
        else{
            let listsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ListsViewController") as! ListsViewController
            listsVC.tableData = houseTitles!
            listsVC.listTitle = "Seats"
            navigationController?.pushViewController(listsVC, animated: true)
        }
    }

    // MARK: - Ancestral Weapons Tap Handler

    @objc func weaponsTapHandler(tapGestureRecognizer:UITapGestureRecognizer){
        let houseTitles = houseData?.ancestralWeapons
        if houseTitles!.isEmpty || houseTitles?.count == 0{
            let alertMessage = "We currently don't have this data. Please try again later."
            let ac = UIAlertController(title: "Missing Data", message: alertMessage, preferredStyle: .alert)
            let submitAction = UIAlertAction(title: "Done", style: .default) { (action) in
                self.dismiss(animated: true)
            }
            ac.addAction(submitAction)
            present(ac, animated: true, completion: nil)
        }
        else{
            let listsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ListsViewController") as! ListsViewController
            listsVC.tableData = houseTitles!
            listsVC.listTitle = "Ancestry Weapons"
            navigationController?.pushViewController(listsVC, animated: true)
        }
    }

    // MARK: - Over Lord Tap Handler

    @objc func overLordTapHandler(tapGestureRecognizer:UITapGestureRecognizer){
        let houseTitles = houseData?.titles
        if houseTitles!.isEmpty || houseTitles?.count == 0{
            let alertMessage = "We currently don't have this data. Please try again later."
            let ac = UIAlertController(title: "Missing Data", message: alertMessage, preferredStyle: .alert)
            let submitAction = UIAlertAction(title: "Done", style: .default) { (action) in
                self.dismiss(animated: true)
            }
            ac.addAction(submitAction)
            present(ac, animated: true, completion: nil)
        }
        else{
            let overLordUrl = houseData?.overlord
            let detailsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HouseDetailsViewController") as! HouseDetailsViewController
            detailsVC.isFromHomePage = false
            detailsVC.passedOverLordUrl = overLordUrl
            navigationController?.pushViewController(detailsVC, animated: true)
        }
    }

    // MARK: - Cadet Tap Handler

    @objc func cadetTapHandler(tapGestureRecognizer:UITapGestureRecognizer){
        let cadetBranchesData = houseData?.cadetBranches
        if cadetBranchesData!.isEmpty || cadetBranchesData?.count == 0{
            let alertMessage = "We currently don't have this data. Please try again later."
            let ac = UIAlertController(title: "Missing Data", message: alertMessage, preferredStyle: .alert)
            let submitAction = UIAlertAction(title: "Done", style: .default) { (action) in
                self.dismiss(animated: true)
            }
            ac.addAction(submitAction)
            present(ac, animated: true, completion: nil)
        }
        else{
            let houseListVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HousesViewController") as! HousesViewController
            houseListVC.isAppLaunch = false
            houseListVC.cadetBranches = cadetBranchesData!
            navigationController?.pushViewController(houseListVC, animated: true)
        }
    }

    // MARK: - Sworn Members Tap Handler

    @objc func membersTapHandler(tapGestureRecognizer:UITapGestureRecognizer){
        let swornMembersData = houseData?.swornMembers
        if swornMembersData!.isEmpty || swornMembersData?.count == 0 {
            let alertMessage = "We currently don't have this data. Please try again later."
            let ac = UIAlertController(title: "Missing Data", message: alertMessage, preferredStyle: .alert)
            let submitAction = UIAlertAction(title: "Done", style: .default) { (action) in
                self.dismiss(animated: true)
            }
            ac.addAction(submitAction)
            present(ac, animated: true, completion: nil)
        }
        else{
            let membersVC = UIStoryboard(name: "SwornMembers", bundle: nil).instantiateViewController(withIdentifier: "MembersViewController") as! MembersViewController
            membersVC.pageTitle = "Sworn Members"
            membersVC.passedMembersList = swornMembersData!
            navigationController?.pushViewController(membersVC, animated: true)
        }
    }

}
