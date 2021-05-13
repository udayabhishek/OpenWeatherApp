//
//  NetworkReachabilityTests.swift
//  WeatherAppTests
//
//  Created by Uday Kumar Abhishek . (Service Transformation) on 13/05/21.
//

import XCTest
import SystemConfiguration

@testable import WeatherApp

class NetworkReachabilityTests: XCTestCase {

    var sut: sockaddr_in!
    override func setUpWithError() throws {
        sut = sockaddr_in()
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    func testReachabilty() throws {
        var result = false
        sut.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        sut.sin_family = sa_family_t(AF_INET)

        guard let defaultRouteReachability = withUnsafePointer(to: &sut, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            result = false
            return
            
        }

        var flags: SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            result = false
        }
        if flags.isEmpty {
            result = false
        }

        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        result = isReachable && !needsConnection
        XCTAssertTrue(result)
    }
}
