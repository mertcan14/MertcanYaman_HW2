//
//  DetailViewModel.swift
//  MertcanYaman_HW2
//
//  Created by mertcan YAMAN on 15.05.2023.
//

import Foundation
import NewsAPI

protocol DetailViewModelDelegate: AnyObject {
    
}

protocol DetailViewModelProtocol {
    var delegate: DetailViewModelDelegate? { get set }
    
    func getDetailUrl() -> URL?
    func getImgUrlFromNews() -> URL?
}

final class DetailViewModel {
    var delegate: DetailViewModelDelegate?
    var news: News
    
    init(news: News) {
        self.news = news
    }
}

extension DetailViewModel: DetailViewModelProtocol {
    func getDetailUrl() -> URL? {
        guard let url = self.news.url else { return nil }
        return URL(string: url)
    }
    
    func getImgUrlFromNews() -> URL? {
        guard let url = self.news.multimedia?[1].url else { return nil }
        return URL(string: url)
    }
}
