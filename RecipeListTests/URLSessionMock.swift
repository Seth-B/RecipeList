//
//  URLSessionMock.swift
//  RecipeList
//
//  Created by Seth Burger on 1/14/25.
//
import Foundation
@testable import RecipeList

final class URLSessionMock: URLSessionProtocol {
    var data: Data?
    var error: Error?
    
    func data(from url: URL) async throws -> (Data, URLResponse) {
        if let error = error {
            throw error
        }
        return (data ?? Data(), URLResponse())
    }
}
