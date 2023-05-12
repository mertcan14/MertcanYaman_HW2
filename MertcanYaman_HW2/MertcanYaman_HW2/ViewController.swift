//
//  ViewController.swift
//  MertcanYaman_HW2
//
//  Created by mertcan YAMAN on 11.05.2023.
//

import UIKit
import NewsAPI

class ViewController: UIViewController {

    let service: TopStoriesServiceProtocol = TopStoriesService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        service.fetchTopStories(.home) { result in
            switch result {
            case .success(let data):
                print(data)
            case .failure(let error):
                print(error)
            }
        }
    }
}

