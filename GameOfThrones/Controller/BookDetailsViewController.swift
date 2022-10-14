//
//  BookDetailsViewController.swift
//  GameOfThrones
//
//  Created by Ernest Mwangi on 14/10/2022.
//

import UIKit

class BookDetailsViewController: UIViewController {

    var passedBookData: BooksDataClass?
    @IBOutlet weak var pagesLabel: UILabel!
    @IBOutlet weak var isbnLabel: UILabel!
    @IBOutlet weak var publisherLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var mediaTypeLabel: UILabel!
    @IBOutlet weak var releaseLabel: UILabel!

    @IBOutlet weak var pagesView: UIView!
    @IBOutlet weak var isbnView: UIView!
    @IBOutlet weak var publisherView: UIView!
    @IBOutlet weak var countryView: UIView!
    @IBOutlet weak var mediaTypeView: UIView!
    @IBOutlet weak var releasedView: UIView!
    @IBOutlet weak var authorsView: UIView!
    @IBOutlet weak var charactersView: UIView!
    @IBOutlet weak var povCharactersView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = passedBookData?.name

        loadViewData()
        setupViews()
        setupTapGestures()
    }

    func setupViews(){
        pagesView.layer.cornerRadius = 5
        isbnView.layer.cornerRadius = 5
        publisherView.layer.cornerRadius = 5
        countryView.layer.cornerRadius = 5
        mediaTypeView.layer.cornerRadius = 5
        releasedView.layer.cornerRadius = 5
        authorsView.layer.cornerRadius = 5
        charactersView.layer.cornerRadius = 5
        povCharactersView.layer.cornerRadius = 5
    }

    func loadViewData(){
        pagesLabel.text = "\(passedBookData?.numberOfPages ?? 0)"
        isbnLabel.text = passedBookData?.isbn
        publisherLabel.text = passedBookData?.publisher
        countryLabel.text = passedBookData?.country
        mediaTypeLabel.text = passedBookData?.mediaType
        releaseLabel.text = passedBookData?.released
    }

    func setupTapGestures(){
        let charactersTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(charactersTapHandler(tapGestureRecognizer:)))
        let povCharactersTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(povCharactersTapHandler(tapGestureRecognizer:)))
        let authorsTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(authorsTapHandler(tapGestureRecognizer:)))


        authorsView.addGestureRecognizer(authorsTapGestureRecognizer)
        charactersView.addGestureRecognizer(charactersTapGestureRecognizer)
        povCharactersView.addGestureRecognizer(povCharactersTapGestureRecognizer)

    }

    // MARK: - Authors Tap Handler
    @objc func authorsTapHandler(tapGestureRecognizer:UITapGestureRecognizer){
        let authors = passedBookData?.authors
        if authors!.isEmpty || authors?.count == 0{
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
            listsVC.tableData = authors!
            listsVC.listTitle = "Authors"
            navigationController?.pushViewController(listsVC, animated: true)
        }
    }

    // MARK: - Characters Tap Handler
    @objc func charactersTapHandler(tapGestureRecognizer:UITapGestureRecognizer){
        let bookCharactersUrl = passedBookData?.characters
        if bookCharactersUrl!.isEmpty || bookCharactersUrl?.count == 0{
            let alertMessage = "We currently don't have this data. Please try again later."
            let ac = UIAlertController(title: "Missing Data", message: alertMessage, preferredStyle: .alert)
            let submitAction = UIAlertAction(title: "Done", style: .default) { (action) in
                self.dismiss(animated: true)
            }
            ac.addAction(submitAction)
            present(ac, animated: true, completion: nil)
        }
        else{
            let charactersVC = UIStoryboard(name: "SwornMembers", bundle: nil).instantiateViewController(withIdentifier: "MembersViewController") as! MembersViewController
            charactersVC.isBookCharacter = true
            charactersVC.pageTitle = "Characters"
            charactersVC.bookCharacters = bookCharactersUrl!
            navigationController?.pushViewController(charactersVC, animated: true)
        }
    }

    // MARK: - POV Characters Tap Handler
    @objc func povCharactersTapHandler(tapGestureRecognizer:UITapGestureRecognizer){
        let bookCharactersUrl = passedBookData?.povCharacters
        if bookCharactersUrl!.isEmpty || bookCharactersUrl?.count == 0{
            let alertMessage = "We currently don't have this data. Please try again later."
            let ac = UIAlertController(title: "Missing Data", message: alertMessage, preferredStyle: .alert)
            let submitAction = UIAlertAction(title: "Done", style: .default) { (action) in
                self.dismiss(animated: true)
            }
            ac.addAction(submitAction)
            present(ac, animated: true, completion: nil)
        }
        else{
            let charactersVC = UIStoryboard(name: "SwornMembers", bundle: nil).instantiateViewController(withIdentifier: "MembersViewController") as! MembersViewController
            charactersVC.isBookCharacter = true
            charactersVC.pageTitle = "POV Characters"
            charactersVC.bookCharacters = bookCharactersUrl!
            navigationController?.pushViewController(charactersVC, animated: true)
        }
    }

}
