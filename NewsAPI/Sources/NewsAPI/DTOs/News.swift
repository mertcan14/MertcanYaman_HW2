//
//  News.swift
//
//
//  Created by mertcan YAMAN on 11.05.2023.


import Foundation

public struct NewsResult: Decodable {
    public let status, copyright: String?
    public let section: Section?
    public let lastUpdated: Date?
    public let numResults: Int?
    public let results: [News]?
    
    enum CodingKeys: String, CodingKey {
        case status, copyright, section
        case lastUpdated = "last_updated"
        case numResults = "num_results"
        case results
    }
}

public struct News: Decodable {
    public let section: String?
    public let subsection: String?
    public let title, abstract: String?
    public let url: String?
    public let uri, byline: String?
    public let itemType: String?
    public let updatedDate, createdDate, publishedDate: Date?
    public let materialTypeFacet, kicker: String?
    public let desFacet, orgFacet, perFacet, geoFacet: [String]?
    public let multimedia: [Multimedia]?
    public let shortURL: String?
    
    enum CodingKeys: String, CodingKey {
        case section, subsection, title, abstract, url, uri, byline
        case itemType = "item_type"
        case updatedDate = "updated_date"
        case createdDate = "created_date"
        case publishedDate = "published_date"
        case materialTypeFacet = "material_type_facet"
        case kicker
        case desFacet = "des_facet"
        case orgFacet = "org_facet"
        case perFacet = "per_facet"
        case geoFacet = "geo_facet"
        case multimedia
        case shortURL = "short_url"
    }
}

public struct Multimedia: Decodable {
    public let url: String?
    public let format: String?
    public let height, width: Int?
    public let type: String?
    public let subtype: String?
    public let caption, copyright: String?
}

public enum Section: String, Decodable, CaseIterable {
    case arts = "arts"
    case automobiles = "automobiles"
    case books = "books"
    case business = "business"
    case fashion = "fashion"
    case food = "food"
    case health = "health"
    case home = "home"
    case insider = "insider"
    case magazine = "magazine"
    case movies = "movies"
    case nyregion = "nyregion"
    case obituaries = "obituaries"
    case opinion = "opinion"
    case politics = "politics"
    case realestate = "realestate"
    case science = "science"
    case sports = "sports"
    case sundayreview = "sundayreview"
    case technology = "technology"
    case theater = "theater"
    case tmagazine = "t-magazine"
    case travel = "travel"
    case upshot = "upshot"
    case us = "us"
    case world = "world"
    
    public func getColor() -> String {
        switch self {
        case .arts:
            return "#e76f51"
        case .automobiles:
            return "#f4a261"
        case .books:
            return "#e9c46a"
        case .business:
            return "#2a9d8f"
        case .fashion:
            return "#264653"
        case .food:
            return "#fb8500"
        case .health:
            return "#ffb703"
        case .home:
            return "#344e41"
        case .insider:
            return "#023047"
        case .magazine:
            return "#219ebc"
        case .movies:
            return "#8ecae6"
        case .nyregion:
            return "#3a86ff"
        case .obituaries:
            return "#8338ec"
        case .opinion:
            return "#fb5607"
        case .politics:
            return "#386641"
        case .realestate:
            return "#38a3a5"
        case .science:
            return "#8d99ae"
        case .sports:
            return "#540b0e"
        case .sundayreview:
            return "#e09f3e"
        case .technology:
            return "#3d5a80"
        case .theater:
            return "#0fa3b1"
        case .tmagazine:
            return "#e07a5f"
        case .travel:
            return "#affc41"
        case .upshot:
            return "#3c1642"
        case .us:
            return "#f07167"
        case .world:
            return "#00296b"
        }
    }
}
