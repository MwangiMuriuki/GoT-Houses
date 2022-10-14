//
//  ServiceCallManager.swift
//  GameOfThrones
//
//  Created by Ernest Mwangi on 12/10/2022.
//

import Foundation


struct ServiceCallManager{

    var delegate: ServiceCallManagerDelegate?

    let baseURL = "https://anapioficeandfire.com/api/"
    let session = URLSession(configuration: .default)
    let fetchHouses = "houses"
    let fetchCharacters = "characters"
    let fetchBooks = "books"

    func fetchAllHouses(){
        let urlString = "\(baseURL)\(fetchHouses)"
        print("FullUrl: \(urlString)")
        if let fullUrl = URL(string: urlString){

            let task = session.dataTask(with: fullUrl) { data, response, error in
                if error != nil {
                    print("List Error: \(String(describing: error))")
                    self.delegate?.errorResponse(error: error!.localizedDescription)
                    return
                }

                if let safeData = data {
                    if let fetchedData = self.parseHouseJSON(housesListData: safeData){
//                        self.delegate?.successResponse(response: fetchedData)

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

}

protocol ServiceCallManagerDelegate{
    func successResponse(response: Data)
    func errorResponse(error: String)
}
