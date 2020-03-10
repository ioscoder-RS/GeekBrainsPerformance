//
//  PhotoCashFunctions.swift
//  GeekbrainsUI
//
//  Created by raskin-sa on 09/03/2020.
//  Copyright © 2020 raskin-sa. All rights reserved.
//


import UIKit
import PromiseKit
import Alamofire


/// Функция кэширования изображений с использованием PromiseKit
// usage:  public func photo(urlString: String) -> Promise<UIImage>
class PhotoCashFunctions {
    
    private let cacheLifetime: TimeInterval = 60*60*24*7
    private static var memoryCache = [String: UIImage]()
    private let isolationQueue = DispatchQueue(label: "GeekbrainsUI.cache.isolation")
    
    private var imageCacheUrl: URL? {
        let dirname = "Images"
        
        //получение доступа к нашей директории в песочнице (.userDomainMask)
        guard let cacheDir = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else { return nil }
        //получение полного имени директории (.../[dirname])
        let url = cacheDir.appendingPathComponent(dirname, isDirectory: true)
        
        //если нет дириктории - создаем ее
        if !FileManager.default.fileExists(atPath: url.path) {
            do {
                try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
            } catch {
                return nil
            }
        }
        
        return url
    }
    
    private func getFilePath(urlString: String) -> URL? {
        let filename = urlString.split(separator: "/").last ?? "default.png"
        guard let imageCacheUrl = self.imageCacheUrl else { return nil }
        return imageCacheUrl.appendingPathComponent(String(filename))
    }
    
    private func saveImageToFilesystem(urlString: String, image: UIImage) {
        guard let data = image.pngData(),
            let fileUrl = getFilePath(urlString: urlString) else { return }
        
        try? data.write(to: fileUrl)
    }
    
    private func loadImageFromFilesystem(urlString: String) -> UIImage? {
        guard let fileUrl = getFilePath(urlString: urlString),
            let info = try? FileManager.default.attributesOfItem(atPath: fileUrl.path),
            let modificationDate = info[.modificationDate] as? Date,
            cacheLifetime > Date().distance(to: modificationDate),
            let image = UIImage(contentsOfFile: fileUrl.path) else { return nil }
        
        isolationQueue.async {
            PhotoCashFunctions.memoryCache[urlString] = image
        }
        
        return image
    }
    
    /// Loads image from the Internet and converts it lo Promise wrapper
    /// - Parameter urlString: image url

    private func loadImage(urlString: String) -> Promise<UIImage> {
  
        let promise = Promise<Data>(resolver: { resolver -> Void in
            Alamofire.request(urlString).responseData(queue: .global()) { response in
                switch response.result {
                case let .success(data):
                    resolver.fulfill(data)
                case let .failure(error):
                    resolver.reject(error)
                }
            }
            })

        return promise
            .map { guard let image = UIImage(data: $0) else { throw PMKError.badInput }; return image }
            .get(on: isolationQueue) { PhotoCashFunctions.memoryCache[urlString] = $0 }
            .get { self.saveImageToFilesystem(urlString: urlString, image: $0) }
    }
    
    
    public func photo(urlString: String) -> Promise<UIImage>  {
        
        // 1. memory cache
        if let image = PhotoCashFunctions.memoryCache[urlString] {
            return Promise.value(image)
        } else if let image = loadImageFromFilesystem(urlString: urlString) {
            // 2. filesystem
            return Promise.value(image)
        }
        // 3. Internet
        return loadImage(urlString: urlString)
    }
}


