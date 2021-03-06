//
//  WeatherAPITests.swift
//  WeatherAppTests
//
//  Created by Uday Kumar Abhishek . (Service Transformation) on 13/05/21.
//

import XCTest
@testable import WeatherApp

class WeatherAPITests: XCTestCase {
    var sutSession: URLSession!
    
    override func setUpWithError() throws {
        sutSession = URLSession(configuration: .default)
    }

    override func tearDownWithError() throws {
        sutSession = nil
    }

    func testWeatherDataForCityNameForSuccess() throws {
        //given
        let urlString = "http://api.openweathermap.org/data/2.5/weather?q=paris&appid=\(Constant.APP_ID)&unit=metric"
        let url = URL(string: urlString)!
        let promise = expectation(description: "Status code: 200")
        
        //when
        let dataTask = sutSession.dataTask(with: url) { (_, response, error) in
            
            //then
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
    
    func testWeatherDataForLatLonNameForSuccess() throws {
        //given
        let urlString = "http://api.openweathermap.org/data/2.5/weather?lat=0&lon=0&appid=\(Constant.APP_ID)&unit=metric"
        let url = URL(string: urlString)!
        let promise = expectation(description: "Status code: 200")
        
        //when
        let dataTask = sutSession.dataTask(with: url) { (_, response, error) in
            
            //then
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

  
    
    func testWeatherDataForWrongCityNameForSuccess() throws {
        //given
        let urlString = "http://api.openweathermap.org/data/2.5/weather?q=QWQWQWQWQWQ&appid=\(Constant.APP_ID)&unit=metric"
        let url = URL(string: urlString)!
        let promise = expectation(description: "Status code: 400 and above")
        
        //when
        let dataTask = sutSession.dataTask(with: url) { (_, response, error) in
            
            //then
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
    
    func testWeatherDataForWrongLatLonNameForSuccess() throws {
        //given
        let urlString = "http://api.openweathermap.org/data/2.5/weather?lat=2121212&lon=1212121&appid=\(Constant.APP_ID)&unit=metric"
        let url = URL(string: urlString)!
        let promise = expectation(description: "Status code: 400 and above")
        
        //when
        let dataTask = sutSession.dataTask(with: url) { (_, response, error) in
            
            //then
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
