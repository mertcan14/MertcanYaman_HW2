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
    
    // MARK: - IBOutlet Definitions
    @IBOutlet weak var newsDateLabel: UILabel!
    @IBOutlet weak var newsAuthor: UILabel!
    @IBOutlet weak var backImageButton: UIImageView!
    @IBOutlet weak var detailImageView: UIImageView!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var sectionView: SectionView!
    
    // MARK: - Variable Definitions
    var detailViewModel: DetailViewModelProtocol!// MARK: - Variable Definitions
    var newsModel: NewsSection?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let section = newsModel?.section, let news = newsModel?.result else { return }
        sectionView.setup(section)
        detailViewModel = DetailViewModel(news: news)
               
        configureGestureRecognizer()
        configureDetailImageView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        configureScreen()
        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.shadowColor = .clear
            appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
            appearance.backgroundColor = UIColor(red: 55/255, green: 71/255, blue: 79/255, alpha: 1)

            UIApplication.shared.statusBarStyle = .lightContent
        } else {
            let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView
            statusBar?.backgroundColor = UIColor.red
        }
    }
    
    /// Go to detail news with SFSafari
    @IBAction func goWebButtunClicked(_ sender: Any) {
        guard let url = self.detailViewModel.getDetailUrl() else { return }
        let vc = SFSafariViewController(url: url, entersReaderIfAvailable: true)
        vc.delegate = self
        present(vc, animated: true)
    }
    
    // MARK: - Private Funcs
    private func configureScreen() {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en")
        formatter.dateStyle = .full
        formatter.timeStyle = .short
        newsDateLabel.text = "\(formatter.string(from: newsModel!.result!.publishedDate!))"
        newsAuthor.text = newsModel?.result?.byline
        titleLabel.text = newsModel?.result?.title
        contentLabel.text = newsModel?.result?.abstract
        detailImageView.sd_setImage(with: detailViewModel.getImgUrlFromNews())
    }
    
    /// Goes back by giving backImage the ability click
    private func configureGestureRecognizer() {
        let goBack = UITapGestureRecognizer(target: self, action: #selector(goBack))
        self.backImageButton.addGestureRecognizer(goBack)
    }
    
    /// rounding the lower left and lower right edges of the detailImageView
    private func configureDetailImageView() {
        detailImageView.clipsToBounds = true
        detailImageView.layer.cornerRadius = 18
        detailImageView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    }
    
    @objc func goBack() {
        dismiss(animated: true)
    }
}
