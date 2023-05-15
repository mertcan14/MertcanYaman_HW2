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
    
    func getData()
    func getNewsPreviews(_ index: Int) -> NewsPreview?
    func getNews(_ index: Int) -> News?
    func getSectionFromNews(_ index: Int) -> String?
}

final class HomeViewModel {
    weak var delegate: HomeViewModelDelegate?
    let service: TopStoriesServiceProtocol = TopStoriesService()
    var news: [News] = [] {
        didSet {
            setArray()
        }
    }
    var newsPreviews: [NewsPreview] = [] {
        didSet {
            self.delegate?.collectionReloadData()
        }
    }
    
    private func fetchData() {
        service.fetchTopStories(.home) { result in
            switch result {
            case .success(let data):
                self.news = data
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func setArray() {
        var newsPreviewArray: [NewsPreview] = []
        for newsObj in news {
            newsPreviewArray.append(NewsPreview(title: newsObj.title ?? "", section: newsObj.section ?? "", imageName: ""))
        }
        newsPreviews = newsPreviewArray
    }
}

extension HomeViewModel: HomeViewModelProtocol {
    func getNews(_ index: Int) -> News? {
        if index >= 0 && index < self.news.count {
            return self.news[index]
        }
        return nil
    }
    
    func getSectionFromNews(_ index: Int) -> String? {
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
    
    func getData() {
        self.fetchData()
    }
}
