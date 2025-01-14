//
//  ImageCacheTests.swift
//  RecipeList
//
//  Created by Seth Burger on 1/14/25.
//

import XCTest
@testable import RecipeList

final class ImageCacheTests: XCTestCase {
    var imageCache: ImageCache!
    let sampleImageURL = URL(string: "https://example.com/sample-image.jpg")!
    let sampleImage = UIImage(systemName: "star")!

    override func setUp() {
        super.setUp()
        imageCache = ImageCache()
    }

    override func tearDown() {
        imageCache.clearDiskCache()
        imageCache.clearMemoryCache()
        imageCache = nil
        super.tearDown()
    }

    func testInMemoryCaching() async throws {
        // Cache the image
        let key = sampleImageURL as NSURL
        imageCache.cache.setObject(sampleImage, forKey: key)

        // Retrieve the image
        let cachedImage = imageCache.cache.object(forKey: key)

        XCTAssertNotNil(cachedImage, "Image should be retrieved from memory cache.")
        XCTAssertEqual(cachedImage, sampleImage, "Retrieved image should match the cached image.")
        
        imageCache.clearMemoryCache();
        XCTAssertNil(imageCache.cache.object(forKey: key), "Image should be deleted from memory cache.")
    }

    func testNetworkFetchingAndCaching() async throws {
        // Create the mock session and configure it
        let session = URLSessionMock()
        session.data = sampleImage.pngData() // Mock the image data
        
        // Inject the mock session into ImageCache
        let localCache = ImageCache(urlSession: session)
        
        // Fetch the image
        let fetchedImage = try await localCache.getImage(for: sampleImageURL)
        
        XCTAssertNotNil(fetchedImage, "Image should be fetched from the network.")
        XCTAssertEqual(fetchedImage.pngData()?.count, sampleImage.pngData()?.count, "Fetched image should match the expected image.")
    }
}
