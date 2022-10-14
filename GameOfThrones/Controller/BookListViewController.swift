//
//  BookListViewController.swift
//  GameOfThrones
//
//  Created by Ernest Mwangi on 14/10/2022.
//

import UIKit

class BookListViewController: UIViewController {

    var passedBookList = [String]()
    var bookList = [BooksDataClass]()
    var bookListDataClass: BooksDataClass?
    var activityIndicator = UIActivityIndicatorView(style: .medium)

    @IBOutlet weak var booksTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        fetchBooks()
        // Do any additional setup after loading the view.
    }

    func setupViews(){
        self.title = "Books"
        let nib = UINib(nibName: "HousesTableViewCell", bundle: nil)
        booksTableView?.register(nib, forCellReuseIdentifier: "HousesTableViewCell")
        booksTableView?.delegate = self
        booksTableView?.dataSource = self

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

    func fetchBooks(){
        let group = DispatchGroup()

        for bookURL in passedBookList{
            group.enter()
            activityIndicator.startAnimating()
            if let fullUrl = URL(string: bookURL){
                print("FullUrl: \(fullUrl)")
                let task = Configs.session.dataTask(with: fullUrl) { [self]data, response, error in
                    if error != nil {
                        self.activityIndicator.stopAnimating()
                        print("List Error: \(String(describing: error))")
                        return
                    }

                    if let safeData = data {
                        if let fetchedData = parseBooksJSON(bookData: safeData){

                            print("Book Dispatch Success \(fetchedData)")

                            self.bookList.append(fetchedData)
                            DispatchQueue.main.async { [self] in
                                activityIndicator.stopAnimating()
                                booksTableView.reloadData()
                            }
                        }
                    }
                }
                task.resume()
            }

            group.leave()

        }
    }

    func parseBooksJSON(bookData: Data) -> BooksDataClass?{
        do {
            let decodedCharacterData = try JSONDecoder().decode(BooksDataClass.self, from: bookData)

            return decodedCharacterData

        } catch {
            print("Error Fetching Data: \(error)")
            return nil
        }
    }

}

extension BookListViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = booksTableView.dequeueReusableCell(withIdentifier: "HousesTableViewCell", for: indexPath) as! HousesTableViewCell
        cell.positionLabel.text = "\(indexPath.row + 1)"
        cell.houseNameLabel.text = bookList[indexPath.row].name
        cell.houseRegionLabel.text = "\(String(describing: bookList[indexPath.row].numberOfPages))"
        cell.houseRegionLabel.text = "\(bookList[indexPath.row].numberOfPages ?? 0) Pages"
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let bookData = bookList[indexPath.row]
        let bookDetailsVC = UIStoryboard(name: "Books", bundle: nil).instantiateViewController(withIdentifier: "BookDetailsViewController") as! BookDetailsViewController
        bookDetailsVC.passedBookData = bookData
        navigationController?.pushViewController(bookDetailsVC, animated: true)
        booksTableView.deselectRow(at: indexPath, animated: true)
    }


}
