//
//  HomeViewModel.swift
//  MertcanYaman_HW2
//
//  Created by mertcan YAMAN on 13.05.2023.
//

import Foundation
import NewsAPI

// MARK: HomeViewModel Delegate
protocol HomeViewModelDelegate: AnyObject {
    func collectionReloadData()
    func collectionViewScroll(indexPath: IndexPath)
}

// MARK: HomeViewModel Protocol
protocol HomeViewModelProtocol {
    var delegate: HomeViewModelDelegate? { get set }
    var numberOfNews: Int { get }
    var numberOfNewsPreview: Int { get }
    var currentCell: Int { get set }
    
    func timerStart()
    func timerStop()
    func getDataMulti(_ sections: [Section])
    func goBackFromSlideCollection()
    func goNextFromSlideCollection()
    func getNewsPreviews(_ index: Int) -> NewsPreview?
    func getNews(_ index: Int) -> NewsSection?
    func getSectionFromNews(_ index: Int) -> Section?
}

// MARK: HomeViewModel
final class HomeViewModel {
    weak var delegate: HomeViewModelDelegate?
    let service: TopStoriesServiceProtocol = TopStoriesService()
    var currentCell = 0
    var timer: Timer = Timer()
    var news: [NewsSection] = []
    var newsPreviews: [NewsPreview] = [] {
        didSet {
            self.delegate?.collectionReloadData()
        }
    }
    
    /// Sends one or more requests to the API
    private func fetchDataMulti(_ sections: [Section]) {
        let group = DispatchGroup()
        self.news = []
        for section in sections {
            group.enter()
            service.fetchTopStories(section) { result in
                switch result {
                case .success(let data):
                    for aData in data {
                        self.news.append(NewsSection(section: section, result: aData))
                    }
                    group.leave()
                case .failure(let error):
                    print(error)
                    group.leave()
                }
            }
        }
        group.wait()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { 
            self.news.shuffle()
            self.setNewsPreviews()
        }
    }
    
    /// Converts from NewsSection to NewsPreview
    private func setNewsPreviews() {
        var newsPreviewArray: [NewsPreview] = []
        var deleteNews: [Int] = []
        var deletedNews: Int = 0
        for index in 0 ..< self.news.count {
            if let small = self.news[index].result?.multimedia?[2].url, let large = self.news[index].result?.multimedia?[1].url, self.news[index].result?.title != "" {
                newsPreviewArray.append(NewsPreview(title: self.news[index].result?.title ?? "title", section: self.news[index].section ?? .home, author: self.news[index].result?.byline ?? "Anonim", largeImageName: large, smalImageName: small))
            }else {
                deleteNews.append(index)
            }
        }
        for deleteNew in deleteNews {
            self.news.remove(at: deleteNew - deletedNews)
            deletedNews += 1
        }
        self.newsPreviews = newsPreviewArray
    }
    
    /// Go to previous cell in the slide collection view
    @objc func goBack() {
        currentCell -= 1
        let indexPath = IndexPath(item: currentCell, section: 0)
        self.delegate?.collectionViewScroll(indexPath: indexPath)
    }
    
    /// Go to next cell in the slide collection view
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
    
    /// Start timer for auto slide
    private func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 6.0, target: self, selector: #selector(self.goNext), userInfo: nil, repeats: true);
    }
    
    private func stopTimer() {
        timer.invalidate()
    }
}

// MARK: HomeViewModel Extension
extension HomeViewModel: HomeViewModelProtocol {
    func timerStop() {
        self.stopTimer()
    }
    
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
