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
    
    @IBOutlet weak var detailImageView: UIImageView!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var sectionView: SectionView!
    @IBOutlet weak var myNavigationBar: UINavigationBar!
    
    var detailViewModel: DetailViewModelProtocol! {
        didSet {
            detailViewModel.delegate = self
        }
    }
    var newsModel: News?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sectionView.setup(newsModel?.section ?? "", backgroundColor: UIColor(red: 55/255, green: 71/255, blue: 79/255, alpha: 1))
        guard let news = newsModel else { return }
        detailViewModel = DetailViewModel(news: news)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        titleLabel.text = newsModel?.title
        contentLabel.text = newsModel?.abstract
        detailImageView.sd_setImage(with: detailViewModel.getImgUrlFromNews())
        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.shadowColor = .clear
            appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
            appearance.backgroundColor = UIColor(red: 55/255, green: 71/255, blue: 79/255, alpha: 1)
            
            myNavigationBar.scrollEdgeAppearance = appearance
            myNavigationBar.standardAppearance = appearance
            UIApplication.shared.statusBarStyle = .lightContent
            
            let app = UIApplication.shared
            let statusBarHeight: CGFloat = app.statusBarFrame.size.height
            
            let statusbarView = UIView()
            statusbarView.backgroundColor = UIColor(red: 55/255, green: 71/255, blue: 79/255, alpha: 1)
            view.addSubview(statusbarView)
            
            statusbarView.translatesAutoresizingMaskIntoConstraints = false
            statusbarView.heightAnchor
                .constraint(equalToConstant: statusBarHeight).isActive = true
            statusbarView.widthAnchor
                .constraint(equalTo: view.widthAnchor, multiplier: 1.0).isActive = true
            statusbarView.topAnchor
                .constraint(equalTo: view.topAnchor).isActive = true
            statusbarView.centerXAnchor
                .constraint(equalTo: view.centerXAnchor).isActive = true
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
    
    @IBAction func clickBackButton(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
}

extension DetailViewController: DetailViewModelDelegate {
    
}
