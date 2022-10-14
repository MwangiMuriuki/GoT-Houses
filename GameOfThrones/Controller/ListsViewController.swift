//
//  ListsViewController.swift
//  GameOfThrones
//
//  Created by Ernest Mwangi on 14/10/2022.
//

import UIKit

class ListsViewController: UIViewController {

    @IBOutlet weak var listsTableView: UITableView!
    var tableData = [String]()
    var listTitle: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = listTitle
        setupViews()
    }

    func setupViews(){
        let nib = UINib(nibName: "ListViewTableViewCell", bundle: nil)
        listsTableView?.register(nib, forCellReuseIdentifier: "ListViewTableViewCell")
        listsTableView?.delegate = self
        listsTableView?.dataSource = self
    }

}

extension ListsViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count

    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = listsTableView.dequeueReusableCell(withIdentifier: "ListViewTableViewCell", for: indexPath) as! ListViewTableViewCell
        var itemData = tableData[indexPath.row]

        if itemData == ""{
            itemData = "N/A"
        }
        cell.itemLabel.text = itemData
        return cell
    }


}
