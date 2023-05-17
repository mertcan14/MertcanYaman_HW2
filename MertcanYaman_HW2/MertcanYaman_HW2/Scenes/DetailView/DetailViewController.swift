//
//  DetailViewController.swift
//  MertcanYaman_HW2
//
//  Created by mertcan YAMAN on 14.05.2023.
//

import UIKit
import NewsAPI
import SafariServices

class DetailViewController: UIViewController, SFSafariViewControllerDelegate {
    
    @IBOutlet weak var newsDateLabel: UILabel!
    @IBOutlet weak var newsAuthor: UILabel!
    @IBOutlet weak var backImageButton: UIImageView!
    @IBOutlet weak var detailImageView: UIImageView!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var sectionView: SectionView!
    
    var detailViewModel: DetailViewModelProtocol! {
        didSet {
            detailViewModel.delegate = self
        }
    }
    var newsModel: NewsSection?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sectionView.setup(newsModel?.section ?? .home)
        guard let news = newsModel?.result else { return }
        detailViewModel = DetailViewModel(news: news)
        
        let goBack = UITapGestureRecognizer(target: self, action: #selector(goBack))
        self.backImageButton.addGestureRecognizer(goBack)
        
        detailImageView.clipsToBounds = true
        detailImageView.layer.cornerRadius = 18
        detailImageView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        newsDateLabel.text = "\(newsModel!.result!.publishedDate!)"
        newsAuthor.text = newsModel?.result?.byline
        titleLabel.text = newsModel?.result?.title
        contentLabel.text = newsModel?.result?.abstract
        detailImageView.sd_setImage(with: detailViewModel.getImgUrlFromNews())
        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.shadowColor = .clear
            appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
            appearance.backgroundColor = UIColor(red: 55/255, green: 71/255, blue: 79/255, alpha: 1)

            UIApplication.shared.statusBarStyle = .lightContent
            
            let app = UIApplication.shared
        } else {
            let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView
            statusBar?.backgroundColor = UIColor.red
        }
    }
    @IBAction func goWebButtunClicked(_ sender: Any) {
        guard let url = self.detailViewModel.getDetailUrl() else { return }
        let vc = SFSafariViewController(url: url, entersReaderIfAvailable: true)
        vc.delegate = self
        
        present(vc, animated: true)
    }
    
    @objc func goBack() {
        dismiss(animated: true)
    }
}

extension DetailViewController: DetailViewModelDelegate {
    
}
