//
//  GameOfThronesTests.swift
//  GameOfThronesTests
//
//  Created by Ernest Mwangi on 12/10/2022.
//

import XCTest
@testable import GameOfThrones

final class GameOfThronesTests: XCTestCase {

    var testSession: URLSession!

    override func setUpWithError() throws {
        try super.setUpWithError()
        testSession = URLSession(configuration: .default)
    }

    override func tearDownWithError() throws {
        testSession = nil
        try super.tearDownWithError()
    }

    func testValidApiCallGetsStatusCode200() throws {

        let urlString = "\(Configs.baseURL)\(Configs.fetchHouses)?pageSize=\(30)&page=\(1)"
        let url = URL(string: urlString)!

        let promise = expectation(description: "Status code: 200")

        let dataTask = testSession.dataTask(with: url) { _, response, error in
        
          if let error = error {
            XCTFail("Error: \(error.localizedDescription)")
            return
          } else if let statusCode = (response as? HTTPURLResponse)?.statusCode {
            if statusCode == 200 {
              promise.fulfill()
            } else {
              XCTFail("Status code: \(statusCode)")
            }
          }
        }
        dataTask.resume()
        wait(for: [promise], timeout: 5)
    }

    func testInValidApiCallGetsStatusCode200() throws {

        let urlString = "\(Configs.baseURL)\(Configs.fetchHouses)test?pageSize=\(30)&page=\(1)"
        let url = URL(string: urlString)!
        var statusCode: Int?
        var responseError: Error?

        let promise = expectation(description: "Status code: 200")

        let dataTask = testSession.dataTask(with: url) { _, response, error in

          if let error = error {
            XCTFail("Error: \(error.localizedDescription)")
            return
          } else if let statusCode = (response as? HTTPURLResponse)?.statusCode {
            if statusCode == 200 {
              promise.fulfill()
            } else {
              XCTFail("Status code: \(statusCode)")
            }
          }
        }
        dataTask.resume()
        wait(for: [promise], timeout: 5)

        XCTAssertNil(responseError)
        XCTAssertEqual(statusCode, 200)
    }


    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
