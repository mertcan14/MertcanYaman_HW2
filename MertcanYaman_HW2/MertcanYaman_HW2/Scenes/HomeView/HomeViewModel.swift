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
    func collectionViewScroll(indexPath: IndexPath)
}

protocol HomeViewModelProtocol {
    var delegate: HomeViewModelDelegate? { get set }
    var numberOfNews: Int { get }
    var numberOfNewsPreview: Int { get }
    var currentCell: Int { get set }
    
    func timerStart()
    func getDataMulti(_ sections: [Section])
    func goBackFromSlideCollection()
    func goNextFromSlideCollection()
    func getNewsPreviews(_ index: Int) -> NewsPreview?
    func getNews(_ index: Int) -> NewsSection?
    func getSectionFromNews(_ index: Int) -> Section?
}

final class HomeViewModel {
    weak var delegate: HomeViewModelDelegate?
    let service: TopStoriesServiceProtocol = TopStoriesService()
    var currentCell = 0
    var news: [NewsSection] = [] {
        didSet {
            self.news.shuffle()
            self.setArray()
        }
    }
    var newsPreviews: [NewsPreview] = [] {
        didSet {
            self.delegate?.collectionReloadData()
        }
    }
    
    private func fetchDataMulti(_ sections: [Section]) {
        let group = DispatchGroup()
        var newsSection: [NewsSection] = []
        
        for section in sections {
            group.enter()
            service.fetchTopStories(section) { result in
                switch result {
                case .success(let data):
                    for aData in data {
                        newsSection.append(NewsSection(section: section, result: aData))
                    }
                    group.leave()
                case .failure(let error):
                    print(error)
                    group.leave()
                }
            }
        }
        group.wait()
        self.news = newsSection
    }
    
    private func setArray() {
        var newsPreviewArray: [NewsPreview] = []
        var deleteNews: [Int] = []
        for index in 0 ..< self.news.count {
            if let small = self.news[index].result?.multimedia?[2].url, let large = self.news[index].result?.multimedia?[1].url, self.news[index].result?.title != "" {
                newsPreviewArray.append(NewsPreview(title: self.news[index].result?.title ?? "title", section: self.news[index].section ?? .home, author: self.news[index].result?.byline ?? "Anonim", largeImageName: large, smalImageName: small))
            }else {
                deleteNews.append(index)
            }
        }
        for deleteNew in deleteNews {
            self.news.remove(at: deleteNew)
        }
        self.newsPreviews = newsPreviewArray
    }
    
    @objc func goBack() {
        currentCell -= 1
        let indexPath = IndexPath(item: currentCell, section: 0)
        self.delegate?.collectionViewScroll(indexPath: indexPath)
    }
    
    @objc func goNext() {
        if currentCell == 3 {
            currentCell = 0
            let indexPath = IndexPath(item: currentCell, section: 0)
            self.delegate?.collectionViewScroll(indexPath: indexPath)
        }else {
            currentCell += 1
            let indexPath = IndexPath(item: currentCell, section: 0)
            self.delegate?.collectionViewScroll(indexPath: indexPath)
        }
    }
    
    func startTimer() {
        _ = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(self.goNext), userInfo: nil, repeats: true);
    }
}

extension HomeViewModel: HomeViewModelProtocol {
    func timerStart() {
        self.startTimer()
    }
    
    func goBackFromSlideCollection() {
        self.goBack()
    }
    
    func goNextFromSlideCollection() {
        self.goNext()
    }
    
    func getDataMulti(_ sections: [Section]) {
        self.fetchDataMulti(sections)
    }
    
    func getNews(_ index: Int) -> NewsSection? {
        if index >= 0 && index < self.news.count {
            return self.news[index]
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
}
