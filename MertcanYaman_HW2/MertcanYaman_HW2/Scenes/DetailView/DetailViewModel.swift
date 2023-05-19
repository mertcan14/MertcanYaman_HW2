//
//  DetailViewModel.swift
//  MertcanYaman_HW2
//
//  Created by mertcan YAMAN on 15.05.2023.
//

import Foundation
import NewsAPI

protocol DetailViewModelProtocol {
    func getDetailUrl() -> URL?
    func getImgUrlFromNews() -> URL?
}

final class DetailViewModel {
    var news: News
    
    init(news: News) {
        self.news = news
    }
}

extension DetailViewModel: DetailViewModelProtocol {
    /// Return the URL of the detail news
    func getDetailUrl() -> URL? {
        guard let url = self.news.url else { return nil }
        return URL(string: url)
    }
    
    /// Return the URL of the image of the news
    func getImgUrlFromNews() -> URL? {
        guard let url = self.news.multimedia?[1].url else { return nil }
        return URL(string: url)
    }
}
