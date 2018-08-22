//
//  HelpfulExtensions.swift
//  MemeMePart1
//
//  Created by Jawaune on 7/28/18.
//  Copyright © 2018 jaelong. All rights reserved.
//
//Refer to link below to see what it should look like
//https://docs.google.com/document/d/1G2onkzN_weWmiYErhQJw1lB9-zxM-2TQ0N5bNMAaI7I/pub?embedded=true

import Foundation
import  UIKit

public extension FileManager {
    
    static var userDirectory: URL {
        return self.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
}

extension UIImage {
    var data: Data {
        guard let image = UIImagePNGRepresentation(self) else { return Data.init()  }
        return image
    }
}

extension UIView {
    func setToHidden(_ bool: Bool = true){
        self.isHidden = bool
    }
}

extension Array where Element: Equatable {
    func removingDuplicates() -> Array {
        return reduce(into: []) { result, element in
            if !result.contains(element) {
                result.append(element)
            }
        }
    }
}

extension DataModel {
    static var memes: [URL]? {
        guard let urls = try? FileManager.default.contentsOfDirectory(at: self.path, includingPropertiesForKeys: nil, options: .skipsHiddenFiles) else { return nil }
        return urls
    }
}

