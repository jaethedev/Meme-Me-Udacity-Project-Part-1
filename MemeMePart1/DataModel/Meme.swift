//
//  Meme.swift
//  MemeMePart1
//
//  Created by Jawaune on 6/4/18.
//  Copyright © 2018 jaelong. All rights reserved.
//
//Refer to link below to see what it should look like
//https://docs.google.com/document/d/1G2onkzN_weWmiYErhQJw1lB9-zxM-2TQ0N5bNMAaI7I/pub?embedded=true


import Foundation
import UIKit


struct Meme: Equatable {
    var topText = ""
    var bottomText = ""
    var imageData = Data()
    var memedImageData = Data()
    
    var combinedText: String {
        return topText + " " + bottomText
    }
    
    enum CodingKeys: String, CodingKey {
        case topText
        case bottomText
        case imageData
        case memedImageData
    }
}

extension Meme {
    var image: UIImage {
        guard let image =  UIImage(data: imageData) else { return #imageLiteral(resourceName: "Default")}
        return image
    }
    var memedImage: UIImage {
        guard let image = UIImage(data: memedImageData) else { return #imageLiteral(resourceName: "Default")}
        return image
    }
}
extension Meme: Encodable {
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(topText, forKey: .topText)
        try container.encode(bottomText, forKey: .bottomText)
        try container.encode(memedImageData, forKey: .memedImageData)
    }
    
}

extension Meme: Decodable {
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        topText = try values.decode(String.self, forKey: .topText)
        bottomText = try values.decode(String.self, forKey: .bottomText)
        memedImageData = try values.decode(Data.self, forKey: .memedImageData)
    }
}

class DataModel {
    var memes = [Meme]()
    var meme = Meme()
    static let path = DataModel.folder()
    init() {
        createSubDirectory()
        loadMemes()
    }
    //Gets path
    func documentsDirectory ()-> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    static func folder() -> URL {
        guard let folder = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("MemeObjects") else { fatalError()}
        return folder
    }
    
    func createSubDirectory() {
        try? FileManager.default.createDirectory(at: documentsDirectory().appendingPathComponent("MemeObjects"), withIntermediateDirectories: false, attributes: nil)
    }
    
     static func persistMeme(meme: Meme){
        let jsonEncoder = JSONEncoder()
        let randomFilename = UUID().uuidString
        do {
            let data = try jsonEncoder.encode(meme)
            try data.write(to: folder().appendingPathComponent(randomFilename).appendingPathExtension("jae"), options: .atomic)
        } catch {
            debugPrint("Couldn't encode here's the error \(error)")
        }
    }
    
    func loadMemes() {
        let path = DataModel.path
        print(path)
        let decoder = JSONDecoder()
        guard  let contents = DataModel.memes else { return }
        var data = Data()
        guard let pathExtension = contents.first?.pathExtension else { return }
        
        for url in contents where url.pathExtension == pathExtension {
            do {
                data = try Data(contentsOf: url)
                meme = try decoder.decode(Meme.self, from: data)
            } catch {
                debugPrint("Error from Decoding \(error)")
            }
            memes.append(meme)
            memes = memes.removingDuplicates()
        }
    }
}

