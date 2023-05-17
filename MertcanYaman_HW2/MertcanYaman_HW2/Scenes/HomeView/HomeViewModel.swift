//
//  HomeViewModel.swift
//  MertcanYaman_HW2
//
//  Created by mertcan YAMAN on 13.05.2023.
//

import Foundation
import NewsAPI

protocol HomeViewModelDelegate: AnyObject {
    func collectionReloadData()
}

protocol HomeViewModelProtocol {
    var delegate: HomeViewModelDelegate? { get set }
    var numberOfNews: Int { get }
    var numberOfNewsPreview: Int { get }
    
    func getData(_ sections: [Section])
    func getNewsPreviews(_ index: Int) -> NewsPreview?
    func getNews(_ index: Int) -> News?
    func getSectionFromNews(_ index: Int) -> Section?
}

final class HomeViewModel {
    weak var delegate: HomeViewModelDelegate?
    let service: TopStoriesServiceProtocol = TopStoriesService()
    var news: [NewsSection] = []
    var newsPreviews: [NewsPreview] = [] {
        didSet {
            print("newsPreviews: \(newsPreviews.count)")
            self.delegate?.collectionReloadData()
        }
    }
    
    private func fetchDataSections(_ sections: [Section]) {
        self.news = []
        for section in sections {
            service.fetchTopStories(section) { result in
                switch result {
                case .success(let data):
                    for aData in data {
                        self.news.append(NewsSection(section: section, result: aData))
                    }
                case .failure(let error):
                    print(error)
                }
                if section == sections.last {
                    self.news.shuffle()
                    self.setArray()
                }
            }
        }
    }
    
    private func setArray() {
        var newsPreviewArray: [NewsPreview] = []
        var deleteNews: [Int] = []
        for index in 0 ..< news.count {
            if let small = news[index].result?.multimedia?[2].url, let large = news[index].result?.multimedia?[1].url, news[index].result?.title != "" {
                newsPreviewArray.append(NewsPreview(title: news[index].result?.title ?? "title", section: news[index].section ?? .home, author: news[index].result?.byline ?? "Anonim", largeImageName: large, smalImageName: small))
            }else {
                deleteNews.append(index)
            }
        }
        for deleteNew in deleteNews {
            self.news.remove(at: deleteNew)
        }
        newsPreviews = newsPreviewArray
    }
}

extension HomeViewModel: HomeViewModelProtocol {
    func getNews(_ index: Int) -> News? {
        if index >= 0 && index < self.news.count {
            return self.news[index].result
        }
        return nil
    }
    
    func getSectionFromNews(_ index: Int) -> Section? {
        if index >= 0 && index < numberOfNewsPreview {
            return self.news[index].section
        }
        return nil
    }
    
    func getNewsPreviews(_ index: Int) -> NewsPreview? {
        if index >= 0 && index < numberOfNewsPreview {
            return self.newsPreviews[index]
        }
        return nil
    }
    
    var numberOfNews: Int {
        self.news.count
    }
    
    var numberOfNewsPreview: Int {
        self.newsPreviews.count
    }
    
    func getData(_ sections: [Section]) {
        self.fetchDataSections(sections)
    }
}
