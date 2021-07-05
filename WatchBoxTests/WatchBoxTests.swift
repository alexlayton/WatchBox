//
//  WatchBoxTests.swift
//  WatchBoxTests
//
//  Created by Alex Layton on 04/07/2021.
//

import XCTest

struct TestingError: Error {
    let message: String
    
    init(_ message: String) {
        self.message = message
    }
    
    public var localizedDescription: String {
        return message
    }
}
