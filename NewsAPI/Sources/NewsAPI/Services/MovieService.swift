//
//  MovieService.swift
//  
//
//  Created by mertcan YAMAN on 12.05.2023.
//

import Foundation

public enum TopStoriesUrl {
    private var baseURL: String { return "https://api.nytimes.com/svc/topstories/v2" }
    private var apiKey: String { return "DhprYHATMo1qSABilynMjQTpJYDIyUcW"}
    
    case section(String)
    
    private var fullPath: String {
        var endpoint:String
        switch self {
        case .section(let sectionName):
            endpoint = "/\(sectionName).json"
        }
        return baseURL + endpoint + "?api-key=" + apiKey
    }
    
    var url: URL {
        guard let url = URL(string: fullPath) else {
            preconditionFailure("The url used in \(TopStoriesUrl.self) is not valid")
        }
        return url
    }
}

public protocol TopStoriesServiceProtocol: AnyObject {
    func fetchTopStories(_ section: Section, completion: @escaping (Result<[News], Error>) -> Void)
}

public class TopStoriesService: TopStoriesServiceProtocol {
    public init() {}
    public func fetchTopStories(_ section: Section, completion: @escaping (Result<[News], Error>) -> Void) {
        let session = URLSession.shared
        let task = session.dataTask(with: TopStoriesUrl.section(section.rawValue).url) { data, response, error  in
            if let error = error {
                completion(.failure(error))
            }
            if let data = data {
                let decoder = Decoders.dateDecoder
                do {
                    let topStories = try decoder.decode(TopStoriesResponse.self, from: data)
                    completion(.success(topStories.results))
                }catch {
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
}
