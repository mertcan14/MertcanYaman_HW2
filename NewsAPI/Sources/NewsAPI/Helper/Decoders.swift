//
//  Decoders.swift
//  
//
//  Created by mertcan YAMAN on 11.05.2023.
//

import Foundation

public enum Decoders {
    static let dateDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss-hh:ss"
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        return decoder
    }()
}
