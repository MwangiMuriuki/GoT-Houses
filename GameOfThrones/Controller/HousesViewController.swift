//
//  HousesViewController.swift
//  GameOfThrones
//
//  Created by Ernest Mwangi on 12/10/2022.
//

import UIKit

class HousesViewController: UIViewController {

    @IBOutlet weak var housesTableView: UITableView!
    var activityIndicator = UIActivityIndicatorView(style: .medium)

    var isAppLaunch: Bool? = true

    var houseList = [HousesDataClass]()
    var cadetBranches = [String]()
    var cadetData: HousesDataClass?
    var cadetList = [HousesDataClass]()
    
    var pageNum = 1

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()

        if !isAppLaunch!{
            setupDispatchGroup()
        }
        else{
            fetchData(pageNumber: pageNum)
        }

    }

    func setupViews(){
        let nib = UINib(nibName: "HousesTableViewCell", bundle: nil)
        housesTableView?.register(nib, forCellReuseIdentifier: "HousesTableViewCell")
        housesTableView?.delegate = self
        housesTableView?.dataSource = self

        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.7041453178)
        activityIndicator.color = .white
        activityIndicator.layer.cornerRadius = 10
        view.addSubview(activityIndicator)
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        activityIndicator.heightAnchor.constraint(equalToConstant: 90).isActive = true
        activityIndicator.widthAnchor.constraint(equalToConstant: 90).isActive = true
        activityIndicator.startAnimating()
    }

    func fetchData(pageNumber: Int){

        let urlString = "\(Configs.baseURL)\(Configs.fetchHouses)?pageSize=\(30)&page=\(pageNum)"
        print("FullUrl: \(urlString)")
        if let fullUrl = URL(string: urlString){

            let task = Configs.session.dataTask(with: fullUrl) { [self] data, response, error in
                if error != nil {
                    activityIndicator.stopAnimating()
                    print("List Error: \(String(describing: error))")
                    return
                }

                if let safeData = data {
                    if let fetchedData = self.parseHouseJSON(housesListData: safeData){
                        
//                        self.houseList = fetchedData
                        self.houseList.append(contentsOf: fetchedData)

                        DispatchQueue.main.async { [self] in
                            activityIndicator.stopAnimating()
                            housesTableView.reloadData()
                        }
                    }
                }
            }
            task.resume()
        }
    }

    func parseHouseJSON(housesListData: Data) -> [HousesDataClass]?{
        do {
            let decodedHousesList = try JSONDecoder().decode([HousesDataClass].self, from: housesListData)

            return decodedHousesList

        } catch {
            print(error)
            return nil
        }
    }

    func setupDispatchGroup(){
        let dispatchGroup = DispatchGroup()
        
        for cadetUrl in cadetBranches{
            dispatchGroup.enter()
            activityIndicator.startAnimating()
            if let fullUrl = URL(string: cadetUrl){
                print("FullUrl: \(fullUrl)")
                let task = Configs.session.dataTask(with: fullUrl) {data, response, error in
                    if error != nil {
                        self.activityIndicator.stopAnimating()
                        print("List Error: \(String(describing: error))")
                        return
                    }

                    if let safeData = data {
                        if let fetchedData = parseCadetJSON(housesListData: safeData){

                            print("Dispatch Success \(fetchedData)")

                            self.houseList.append(fetchedData)
                            DispatchQueue.main.async { [self] in
                                activityIndicator.stopAnimating()
                                housesTableView.reloadData()
                            }
                        }
                    }
                }
                task.resume()
            }

            dispatchGroup.leave()
        }

        dispatchGroup.notify(queue: .main) {
            print("Dispatch Tasks done")
        }
    }

    }

    func parseCadetJSON(housesListData: Data) -> HousesDataClass?{
        do {
            let decodedHousesList = try JSONDecoder().decode(HousesDataClass.self, from: housesListData)

            return decodedHousesList

        } catch {
            print(error)
            return nil
        }
    }



extension HousesViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return houseList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = housesTableView.dequeueReusableCell(withIdentifier: "HousesTableViewCell", for: indexPath) as! HousesTableViewCell
        cell.configureCells(with: houseList[indexPath.row])
        cell.positionLabel.text = "\(indexPath.row + 1)"
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedHouseData = houseList[indexPath.row]
        let detailsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HouseDetailsViewController") as! HouseDetailsViewController
        detailsVC.isFromHomePage = true
        detailsVC.houseData = selectedHouseData
        navigationController?.pushViewController(detailsVC, animated: true)
        housesTableView.deselectRow(at: indexPath, animated: false)
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath:IndexPath) {

            if isAppLaunch!{
                let lastIndex = self.houseList.count - 1
                   if indexPath.row == lastIndex {
                       print("End of List")
                       activityIndicator.startAnimating()
                       pageNum = pageNum + 1
                       print("Next Page: \(pageNum)")
                       DispatchQueue.global().asyncAfter(deadline: .now() + 3, execute: { [self] in
                           fetchData(pageNumber: pageNum)
                       })
                   }
            }

        }

}

