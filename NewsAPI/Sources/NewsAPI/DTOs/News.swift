//
//  News.swift
//
//
//  Created by mertcan YAMAN on 11.05.2023.


import Foundation

public struct NewsResult: Decodable {
    public let status, copyright: String?
    public let section: Section
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

public enum Section: String, Decodable {
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
}
