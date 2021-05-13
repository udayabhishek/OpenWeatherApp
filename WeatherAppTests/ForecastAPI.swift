//
//  ForecastAPI.swift
//  WeatherAppTests
//
//  Created by Uday Kumar Abhishek . (Service Transformation) on 13/05/21.
//

import XCTest
@testable import WeatherApp

class ForecastAPI: XCTestCase {

    var sutSession: URLSession!
    
    override func setUpWithError() throws {
        sutSession = URLSession(configuration: .default)
    }

    override func tearDownWithError() throws {
        sutSession = nil
    }


    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    
     func testForcastDataForCityNameForSuccess() throws {
         //given
         let urlString = "http://api.openweathermap.org/data/2.5/forecast?q=paris&appid=\(Constant.APP_ID)&unit=metric"
         
         let url = URL(string: urlString)!
         
         let promise = expectation(description: "Status code: 200")
         
         //when
         let dataTask = sutSession.dataTask(with: url) { (_, response, error) in
             if let error = error {
                 XCTFail("Error: \(error.localizedDescription)")
                 return
             }
             else if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                 if statusCode == 200 {
                     promise.fulfill()
                 }
                 else {
                     XCTFail("Status Code: \(statusCode)")
                 }
             }
         }
         dataTask.resume()
         
         wait(for: [promise], timeout: 5)
     }
     
    
     func testForcastDataForLatLonNameForSuccess() throws {
         //given
         let urlString = "http://api.openweathermap.org/data/2.5/forecast?lat=0&lon=0&appid=\(Constant.APP_ID)&unit=metric"
         
         let url = URL(string: urlString)!
         
         let promise = expectation(description: "Status code: 200")
         
         //when
         let dataTask = sutSession.dataTask(with: url) { (_, response, error) in
             if let error = error {
                 XCTFail("Error: \(error.localizedDescription)")
                 return
             }
             else if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                 if statusCode == 200 {
                     promise.fulfill()
                 }
                 else {
                     XCTFail("Status Code: \(statusCode)")
                 }
             }
         }
         dataTask.resume()
         
         wait(for: [promise], timeout: 5)
     }
     

    func testForcastDataForWrongCityNameForSuccess() throws {
        //given
        let urlString = "http://api.openweathermap.org/data/2.5/forecast?q=QWQWQWQWQWQ&appid=\(Constant.APP_ID)&unit=metric"
        
        let url = URL(string: urlString)!
        
        let promise = expectation(description: "Status code: 200")
        
        //when
        let dataTask = sutSession.dataTask(with: url) { (_, response, error) in
            if let error = error {
                XCTFail("Error: \(error.localizedDescription)")
                return
            }
            else if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if statusCode >= 400 {
                    promise.fulfill()
                }
                else {
                    XCTFail("Status Code: \(statusCode)")
                }
            }
        }
        dataTask.resume()
        
        wait(for: [promise], timeout: 5)
    }
    
   
    func testForcastDataForWrongLatLonNameForSuccess() throws {
        //given
        let urlString = "http://api.openweathermap.org/data/2.5/forecast?lat=4343434343&lon=0404030493&appid=\(Constant.APP_ID)&unit=metric"
        
        let url = URL(string: urlString)!
        
        let promise = expectation(description: "Status code: 200")
        
        //when
        let dataTask = sutSession.dataTask(with: url) { (_, response, error) in
            if let error = error {
                XCTFail("Error: \(error.localizedDescription)")
                return
            }
            else if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if statusCode >= 400 {
                    promise.fulfill()
                }
                else {
                    XCTFail("Status Code: \(statusCode)")
                }
            }
        }
        dataTask.resume()
        
        wait(for: [promise], timeout: 5)
    }
    
}
