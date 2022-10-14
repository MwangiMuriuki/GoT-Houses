//
//  CharactersViewController.swift
//  GameOfThrones
//
//  Created by Ernest Mwangi on 13/10/2022.
//

import UIKit

class CharactersViewController: UIViewController {

    var activityIndicator = UIActivityIndicatorView(style: .medium)
    var passedUrl: String?
    var titleLabel: String?
    var swornMembersList = [String]()


    var charSpouse: String?
    var charMother: String?
    var charFather: String?
    var charAlliegences: [String]?
    var charTitles: [String]?
    var charSeries: [String]?
    var charBooks: [String]?
    var charPovBooks: [String]?
    var charPlayedBy: [String]?
    var charAliases: [String]?

    @IBOutlet weak var characterNameLabel: UILabel!
    @IBOutlet weak var characterGenderLabel: UILabel!
    @IBOutlet weak var characterCultureLabel: UILabel!
    @IBOutlet weak var charcterDOB: UILabel!
    @IBOutlet weak var characterDOD: UILabel!

    @IBOutlet weak var founderNameView: UIView!
    @IBOutlet weak var cultureView: UIView!
    @IBOutlet weak var dobView: UIView!
    @IBOutlet weak var dodView: UIView!
    @IBOutlet weak var titlesView: UIView!
    @IBOutlet weak var aliasesView: UIView!
    @IBOutlet weak var fatherView: UIView!
    @IBOutlet weak var motherView: UIView!
    @IBOutlet weak var spouseView: UIView!
    @IBOutlet weak var alliegenceView: UIView!
    @IBOutlet weak var booksView: UIView!
    @IBOutlet weak var povBooksView: UIView!
    @IBOutlet weak var tvSeriesView: UIView!
    @IBOutlet weak var playedByView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = titleLabel
        setUpViews()
        fetchData()
        setupTapGestures()
    }

    func setUpViews(){
        founderNameView.layer.cornerRadius = 5
        cultureView.layer.cornerRadius = 5
        dobView.layer.cornerRadius = 5
        dodView.layer.cornerRadius = 5
        titlesView.layer.cornerRadius = 5
        aliasesView.layer.cornerRadius = 5
        fatherView.layer.cornerRadius = 5
        motherView.layer.cornerRadius = 5
        spouseView.layer.cornerRadius = 5
        alliegenceView.layer.cornerRadius = 5
        booksView.layer.cornerRadius = 5
        povBooksView.layer.cornerRadius = 5
        tvSeriesView.layer.cornerRadius = 5
        playedByView.layer.cornerRadius = 5

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

    func setupTapGestures(){
        let alligencesTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(alliegenceTapHandler(tapGestureRecognizer:)))
        let titlesTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(titlesTapHandler(tapGestureRecognizer:)))
        let aliasesTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(aliasesTapHandler(tapGestureRecognizer:)))
        let seriesTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(seriesTapHandler(tapGestureRecognizer:)))
        let playedByTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(playedByTapHandler(tapGestureRecognizer:)))
        let booksTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(booksTapHandler(tapGestureRecognizer:)))
        let povBooksTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(povBooksTapHandler(tapGestureRecognizer:)))
        let fatherTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(fatherTapHandler(tapGestureRecognizer:)))
        let motherTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(motherTapHandler(tapGestureRecognizer:)))
        let spouseTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(spouseTapHandler(tapGestureRecognizer:)))

        alliegenceView.isUserInteractionEnabled = true
        titlesView.isUserInteractionEnabled = true
        aliasesView.isUserInteractionEnabled = true
        tvSeriesView.isUserInteractionEnabled = true
        playedByView.isUserInteractionEnabled = true
        titlesView.isUserInteractionEnabled = true
        fatherView.isUserInteractionEnabled = true
        motherView.isUserInteractionEnabled = true
        spouseView.isUserInteractionEnabled = true
        booksView.isUserInteractionEnabled = true
        povBooksView.isUserInteractionEnabled = true

        alliegenceView.addGestureRecognizer(alligencesTapGestureRecognizer)
        titlesView.addGestureRecognizer(titlesTapGestureRecognizer)
        aliasesView.addGestureRecognizer(aliasesTapGestureRecognizer)
        tvSeriesView.addGestureRecognizer(seriesTapGestureRecognizer)
        playedByView.addGestureRecognizer(playedByTapGestureRecognizer)
        fatherView.addGestureRecognizer(fatherTapGestureRecognizer)
        motherView.addGestureRecognizer(motherTapGestureRecognizer)
        spouseView.addGestureRecognizer(spouseTapGestureRecognizer)
        booksView.addGestureRecognizer(booksTapGestureRecognizer)
        povBooksView.addGestureRecognizer(povBooksTapGestureRecognizer)

    }

    func fetchData(){

        activityIndicator.startAnimating()
//        serviceManager.fetchAllHouses()

        let urlString = passedUrl
        print("FullUrl: \(String(describing: urlString))")
        if let fullUrl = URL(string: urlString!){

            let task = Configs.session.dataTask(with: fullUrl) { [self] data, response, error in
                if error != nil {
                    activityIndicator.stopAnimating()
                    print("List Error: \(String(describing: error))")
                    return
                }

                if let safeData = data {
                    if let fetchedData = self.parseCharacterJSON(characterData: safeData){
                        DispatchQueue.main.async { [self] in
                            loadFetchedData(charData: fetchedData)
                        }
                    }
                }
            }
            task.resume()
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

    func loadFetchedData(charData: CharactersDataClass){
        activityIndicator.stopAnimating()

        characterNameLabel.text = charData.name
        characterGenderLabel.text = "(" + charData.gender! + ")"
        characterCultureLabel.text = charData.culture
        charcterDOB.text = charData.born
        characterDOD.text = charData.died
        charAlliegences = charData.allegiances
        charTitles = charData.titles
        charAliases = charData.aliases
        charBooks = charData.books
        charPovBooks = charData.povBooks
        charSeries = charData.tvSeries
        charPlayedBy = charData.playedBy
        charSpouse = charData.spouse
        charFather = charData.father
        charMother = charData.mother

    }


    // MARK: - Alliegence Tap Handler
    @objc func alliegenceTapHandler(tapGestureRecognizer:UITapGestureRecognizer){
        let alliegenceData = charAlliegences
        if alliegenceData!.isEmpty || alliegenceData?.count == 0{
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
            listsVC.tableData = alliegenceData!
            listsVC.listTitle = "Alligences"
            navigationController?.pushViewController(listsVC, animated: true)
        }
    }

    // MARK: - Titles Tap Handler
    @objc func titlesTapHandler(tapGestureRecognizer:UITapGestureRecognizer){
        let titleData = charTitles
        if titleData!.isEmpty || titleData?.count == 0{
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
            listsVC.tableData = titleData!
            listsVC.listTitle = "Titles"
            navigationController?.pushViewController(listsVC, animated: true)
        }
    }

    // MARK: - Aliases Tap Handler
    @objc func aliasesTapHandler(tapGestureRecognizer:UITapGestureRecognizer){
        let aliasData = charAliases
        if aliasData!.isEmpty || aliasData?.count == 0{
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
            listsVC.tableData = aliasData!
            listsVC.listTitle = "Aliases"
            navigationController?.pushViewController(listsVC, animated: true)
        }
    }

    // MARK: - Series Tap Handler
    @objc func seriesTapHandler(tapGestureRecognizer:UITapGestureRecognizer){
        let tvSeriesData = charSeries
        if tvSeriesData!.isEmpty || tvSeriesData?.count == 0{
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
            listsVC.tableData = tvSeriesData!
            listsVC.listTitle = "TV Series"
            navigationController?.pushViewController(listsVC, animated: true)
        }
    }

    // MARK: - Played By Tap Handler
    @objc func playedByTapHandler(tapGestureRecognizer:UITapGestureRecognizer){
        let playedByData = charPlayedBy
        if playedByData!.isEmpty || playedByData?.count == 0{
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
            listsVC.tableData = playedByData!
            listsVC.listTitle = "Played By"
            navigationController?.pushViewController(listsVC, animated: true)
        }
    }

    // MARK: - Father Tap Handler
    @objc func fatherTapHandler(tapGestureRecognizer:UITapGestureRecognizer){
        let fatherData = charFather
        if fatherData!.isEmpty || fatherData?.count == 0{
            let alertMessage = "We currently don't have this data. Please try again later."
            let ac = UIAlertController(title: "Missing Data", message: alertMessage, preferredStyle: .alert)
            let submitAction = UIAlertAction(title: "Done", style: .default) { (action) in
                self.dismiss(animated: true)
            }
            ac.addAction(submitAction)
            present(ac, animated: true, completion: nil)
        }
        else{
//            let listsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ListsViewController") as! ListsViewController
//            listsVC.tableData = playedByData!
//            listsVC.listTitle = "Played By"
//            navigationController?.pushViewController(listsVC, animated: true)
        }
    }

    // MARK: - Mother Tap Handler
    @objc func motherTapHandler(tapGestureRecognizer:UITapGestureRecognizer){
        let motherData = charMother
        if motherData!.isEmpty || motherData?.count == 0{
            let alertMessage = "We currently don't have this data. Please try again later."
            let ac = UIAlertController(title: "Missing Data", message: alertMessage, preferredStyle: .alert)
            let submitAction = UIAlertAction(title: "Done", style: .default) { (action) in
                self.dismiss(animated: true)
            }
            ac.addAction(submitAction)
            present(ac, animated: true, completion: nil)
        }
        else{
//            let listsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ListsViewController") as! ListsViewController
//            listsVC.tableData = playedByData!
//            listsVC.listTitle = "Played By"
//            navigationController?.pushViewController(listsVC, animated: true)
        }
    }

    // MARK: - Spouse Tap Handler
    @objc func spouseTapHandler(tapGestureRecognizer:UITapGestureRecognizer){
        let spouseData = charSpouse
        if spouseData!.isEmpty || spouseData?.count == 0{
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
            charactersVC.passedUrl = spouseData
            navigationController?.pushViewController(charactersVC, animated: true)
        }
    }

    // MARK: - Books Tap Handler
    @objc func booksTapHandler(tapGestureRecognizer:UITapGestureRecognizer){
        let bookData = charBooks
        if bookData!.isEmpty || bookData?.count == 0{
            let alertMessage = "We currently don't have this data. Please try again later."
            let ac = UIAlertController(title: "Missing Data", message: alertMessage, preferredStyle: .alert)
            let submitAction = UIAlertAction(title: "Done", style: .default) { (action) in
                self.dismiss(animated: true)
            }
            ac.addAction(submitAction)
            present(ac, animated: true, completion: nil)
        }
        else{
            let bookListVC = UIStoryboard(name: "Books", bundle: nil).instantiateViewController(withIdentifier: "BookListViewController") as! BookListViewController
            bookListVC.passedBookList = bookData!
            navigationController?.pushViewController(bookListVC, animated: true)
        }
    }

    // MARK: - Pov Books Tap Handler
    @objc func povBooksTapHandler(tapGestureRecognizer:UITapGestureRecognizer){
        let povBookData = charPovBooks
        if povBookData!.isEmpty || povBookData?.count == 0{
            let alertMessage = "We currently don't have this data. Please try again later."
            let ac = UIAlertController(title: "Missing Data", message: alertMessage, preferredStyle: .alert)
            let submitAction = UIAlertAction(title: "Done", style: .default) { (action) in
                self.dismiss(animated: true)
            }
            ac.addAction(submitAction)
            present(ac, animated: true, completion: nil)
        }
        else{
            let bookListVC = UIStoryboard(name: "Books", bundle: nil).instantiateViewController(withIdentifier: "BookListViewController") as! BookListViewController
            bookListVC.passedBookList = povBookData!
            navigationController?.pushViewController(bookListVC, animated: true)
        }
    }

}
