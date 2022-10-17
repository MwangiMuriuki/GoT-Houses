//
//  MembersViewController.swift
//  GameOfThrones
//
//  Created by Ernest Mwangi on 14/10/2022.
//

import UIKit

class MembersViewController: UIViewController {

    @IBOutlet weak var membersTableView: UITableView!
    var activityIndicator = UIActivityIndicatorView(style: .medium)

    var passedMembersList = [String]()
    var swornMembersData: CharactersDataClass?
    var swornMembersList = [CharactersDataClass]()
    var bookCharacters = [String?]()
    var isBookCharacter: Bool? = false
    var pageTitle: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()

        if !isBookCharacter!{
            fetchMembers()
        }
        else{
            fetchBookCharacters()
        }

    }

    func setupViews(){

        self.title = pageTitle
        let nib = UINib(nibName: "HousesTableViewCell", bundle: nil)
        membersTableView?.register(nib, forCellReuseIdentifier: "HousesTableViewCell")
        membersTableView?.delegate = self
        membersTableView?.dataSource = self

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

    func fetchMembers(){
        let group = DispatchGroup()

        for memberUrl in passedMembersList{
            group.enter()
            activityIndicator.startAnimating()
            if let fullUrl = URL(string: memberUrl){
                print("FullUrl: \(fullUrl)")
                let task = Configs.session.dataTask(with: fullUrl) { [self]data, response, error in
                    if error != nil {
                        self.activityIndicator.stopAnimating()
                        print("List Error: \(String(describing: error))")
                        return
                    }

                    if let safeData = data {
                        if let fetchedData = parseMemberJSON(memberData: safeData){

                            print("Member Dispatch Success \(fetchedData)")

                            self.swornMembersList.append(fetchedData)
                            DispatchQueue.main.async { [self] in
                                activityIndicator.stopAnimating()
                                membersTableView.reloadData()
                            }
                        }
                    }
                }
                task.resume()
            }

            group.leave()

        }
    }

    func fetchBookCharacters(){
        let group = DispatchGroup()

        for characterUrl in bookCharacters{
            group.enter()
            activityIndicator.startAnimating()
            if let fullUrl = URL(string: characterUrl!){
                print("FullUrl: \(fullUrl)")
                let task = Configs.session.dataTask(with: fullUrl) { [self] data, response, error in
                    if error != nil {
                        activityIndicator.stopAnimating()
                        print("List Error: \(String(describing: error))")
                        return
                    }

                    if let safeData = data {
                        if let fetchedData = self.parseCharacterJSON(characterData: safeData){

                            self.swornMembersList.append(fetchedData)
                            DispatchQueue.main.async { [self] in
                                activityIndicator.stopAnimating()
                                membersTableView.reloadData()
                            }
                        }
                    }
                }
                task.resume()
            }
            group.leave()
        }

        group.notify(queue: .main) {
            print("Dispatch Tasks done")
        }
    }

    func parseCharacterJSON(characterData: Data) -> CharactersDataClass?{
        do {
            let decodedCharacterData = try JSONDecoder().decode(CharactersDataClass.self, from: characterData)

            return decodedCharacterData

        } catch {
            print("Error Fetching Data: \(error)")
            return nil
        }
    }

    func parseMemberJSON(memberData: Data) -> CharactersDataClass?{
        do {
            let decodedCharacterData = try JSONDecoder().decode(CharactersDataClass.self, from: memberData)

            return decodedCharacterData

        } catch {
            print("Error Fetching Data: \(error)")
            return nil
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension MembersViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return swornMembersList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = membersTableView.dequeueReusableCell(withIdentifier: "HousesTableViewCell", for: indexPath) as! HousesTableViewCell
//        cell.configureCells(with: houseList[indexPath.row])
        cell.positionLabel.text = "\(indexPath.row + 1)"
        cell.houseNameLabel.text = swornMembersList[indexPath.row].name
        cell.houseRegionLabel.text = swornMembersList[indexPath.row].gender
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedMemberData = swornMembersList[indexPath.row]
        let characterVC = UIStoryboard(name: "Characters", bundle: nil).instantiateViewController(withIdentifier: "CharactersViewController") as! CharactersViewController
        characterVC.passedUrl = selectedMemberData.url
        navigationController?.pushViewController(characterVC, animated: true)
        membersTableView.deselectRow(at: indexPath, animated: false)
    }


}
