//
//  ImageCache.swift
//  RecipeList
//
//  Created by Seth Burger on 1/13/25.
//

import Foundation
import SwiftUI

protocol URLSessionProtocol {
    func data(from url: URL) async throws -> (Data, URLResponse)
}
extension URLSession: URLSessionProtocol {}

class ImageCache {
    static let shared = ImageCache()
    
    let cache = NSCache<NSURL, UIImage>()
    let fileManager = FileManager.default
    let diskCacheURL: URL
    
    // Split out for testing
    private var urlSession: URLSessionProtocol;
    
    init(urlSession: URLSessionProtocol? = nil) {
        if let session = urlSession {
            self.urlSession = session
        } else {
            // Custom URLSession with caching disabled
            let config = URLSessionConfiguration.default
            config.urlCache = nil // Disable built-in caching
            config.requestCachePolicy = .reloadIgnoringLocalCacheData
            self.urlSession = URLSession(configuration: config)
        }
        
        let cachesDirectory = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first!
        diskCacheURL = cachesDirectory.appendingPathComponent("ImageCache")
        
        if !fileManager.fileExists(atPath: diskCacheURL.path) {
            try? fileManager.createDirectory(at: diskCacheURL, withIntermediateDirectories: true)
        }
    }
    
    func clearDiskCache() {
        do {
            let files = try fileManager.contentsOfDirectory(at: diskCacheURL, includingPropertiesForKeys: nil)
            for file in files {
                try fileManager.removeItem(at: file)
            }
            print("Disk cache cleared.")
        } catch {
            print("Failed to clear disk cache: \(error)")
        }
    }
    
    func clearMemoryCache() {
        cache.removeAllObjects();
        print("Memory cache cleared.")
    }
    
    func getImage(for url: URL, _name: String = "") async throws -> UIImage {
        // Check in-memory cache
        if let cachedImage = cache.object(forKey: url as NSURL) {
            print("Image for '\(_name)' loaded from memory cache.")
            return cachedImage
        }
        
        // Check disk cache
        let fileURL = diskCacheURL.appendingPathComponent(uniqueFilename(for: url))
        if let data = try? Data(contentsOf: fileURL), let image = UIImage(data: data) {
            print("Image for '\(_name)' loaded from disk cache.")
            cache.setObject(image, forKey: url as NSURL) // Add to memory cache
            return image
        }
        
        // Fetch from network
        let (data, _) = try await urlSession.data(from: url)
        guard let image = UIImage(data: data) else {
            throw RecipeError.decodingError
        }
        
        print("Image for '\(_name)' fetched from network.")
        
        // Cache to memory and disk
        cache.setObject(image, forKey: url as NSURL)
        try? data.write(to: fileURL)
        
        return image
    }
    
    private func uniqueFilename(for url: URL) -> String {
        return url.absoluteString.addingPercentEncoding(withAllowedCharacters: .alphanumerics) ?? UUID().uuidString
    }
}
