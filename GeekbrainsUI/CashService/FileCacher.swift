//
//  FileCacher.swift
//  GeekbrainsUI
//
//  Created by raskin-sa on 21/01/2020.
//  Copyright © 2020 raskin-sa. All rights reserved.
//


//MARK: пока нигде не вызывается
//MARK: записывает файл если не находит его по заданному пути

//import Foundation
//
//enum CacheWriterStatus{
//    case success
//    case fileExist
//    case memoryException
//}
//
//class Cacher {
//    let fileManager = FileManager.default
//
//    func writeFile(file: Data, filename: String) -> CacheWriterStatus{
//        let documentsDirectory = fileManager.urls(for: .documentDirectory,
//                                                  in: .userDomainMask).first!
//
//        let filePath = documentsDirectory.appendingPathComponent(filename)
//
//        if !fileManager.fileExists(atPath: filePath.path) {
//            do{
//                try file.write(to: filePath)
//            }catch{
//                return .memoryException
//            }
//        } else {return .fileExist}
//
//        return .success
//    }//func writeFile
//
//}//class Cacher
