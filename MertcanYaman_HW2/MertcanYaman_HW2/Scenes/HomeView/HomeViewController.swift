//
//  ViewController.swift
//  MertcanYaman_HW2
//
//  Created by mertcan YAMAN on 11.05.2023.
//
import UIKit

class HomeViewController: UIViewController {
    
    var numberOfItemPerRow: CGFloat = 1
    var collectionViewFlowLayout: UICollectionViewFlowLayout!
    var slideCollectionViewFlowLayout: UICollectionViewFlowLayout!
    var homeViewModel: HomeViewModelProtocol! {
        didSet {
            homeViewModel.delegate = self
        }
    }
    
    @IBOutlet weak var outerView: UIView!
    @IBOutlet weak var slideCollectionView: UICollectionView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        homeViewModel = HomeViewModel()
        collectionView.register(UINib(nibName: "NewsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "NewsCollectionViewCell")
        slideCollectionView.register(UINib(nibName: "SlideNewsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SlideNewsCollectionViewCell")
        homeViewModel.getData()
        setupCollectionViewLayout()
        loadingView.startAnimating()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.shadowColor = .clear
            appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
            appearance.backgroundColor = UIColor(red: 55/255, green: 71/255, blue: 79/255, alpha: 1)
            
            navigationController?.navigationBar.scrollEdgeAppearance = appearance
            navigationController?.navigationBar.standardAppearance = appearance
        } else {
            // Fallback on earlier versions
        }
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        updateCollectionViewItemSize()
        updateSlideCollectionViewItemSize()
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: { context in
            if UIApplication.shared.statusBarOrientation.isLandscape {
                self.numberOfItemPerRow = 2
            } else {
                self.numberOfItemPerRow = 1
            }
            self.updateCollectionViewItemSize()
            self.updateSlideCollectionViewItemSize()
        })
    }
    
    private func setupCollectionViewLayout() {
        self.collectionViewFlowLayout = UICollectionViewFlowLayout()
        collectionView.setCollectionViewLayout(self.collectionViewFlowLayout, animated: true)
        
        self.slideCollectionViewFlowLayout = UICollectionViewFlowLayout()
        slideCollectionView.setCollectionViewLayout(slideCollectionViewFlowLayout, animated: true)
    }
    
    private func updateSlideCollectionViewItemSize() {
        let lineSpacing: CGFloat = 24
        let width = slideCollectionView.frame.width - 24
        let height = 200
        
        slideCollectionViewFlowLayout.itemSize = CGSize(width: Int(width), height: height)
        slideCollectionViewFlowLayout.scrollDirection = .horizontal
        slideCollectionViewFlowLayout.minimumLineSpacing = lineSpacing
        slideCollectionViewFlowLayout.sectionInset.left = 12
        slideCollectionViewFlowLayout.sectionInset.right = 12
        slideCollectionView.decelerationRate = UIScrollView.DecelerationRate.fast
    }
    
    private func updateCollectionViewItemSize() {
        let lineSpacing: CGFloat = 2
        let interItemSpacing:CGFloat = 5
        let width = ((collectionView.frame.width - (self.numberOfItemPerRow - 1) * interItemSpacing)) / self.numberOfItemPerRow
        let height = 180
        
        collectionViewFlowLayout.itemSize = CGSize(width: Int(width), height: height)
        collectionViewFlowLayout.sectionInset = UIEdgeInsets.zero
        collectionViewFlowLayout.scrollDirection = .vertical
        collectionViewFlowLayout.minimumLineSpacing = lineSpacing
        collectionViewFlowLayout.minimumInteritemSpacing = lineSpacing
    }
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.collectionView {
            return self.homeViewModel.numberOfNewsPreview - 4
        }else {
            return 4
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.collectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NewsCollectionViewCell", for: indexPath) as! NewsCollectionViewCell
            guard let model = homeViewModel.getNewsPreviews(indexPath.row + 4) else { return cell }
            cell.setup(model)
            return cell
        }else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SlideNewsCollectionViewCell", for: indexPath) as! SlideNewsCollectionViewCell
            guard let model = homeViewModel.getNewsPreviews(indexPath.row) else { return cell }
            cell.setup(model, left: indexPath.row == 0 ? false : true, right: indexPath.row == 3 ? false : true)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.collectionView {
            let sendVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
            sendVC.newsModel = homeViewModel.getNews(indexPath.row + 4)
            sendVC.modalPresentationStyle = .fullScreen
            sendVC.modalTransitionStyle = .coverVertical
            present(sendVC, animated: true, completion: nil)
        }else {
            let sendVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
            sendVC.newsModel = homeViewModel.getNews(indexPath.row)
            sendVC.modalPresentationStyle = .fullScreen
            sendVC.modalTransitionStyle = .coverVertical
            present(sendVC, animated: true, completion: nil)
        }
    }
}

extension HomeViewController: HomeViewModelDelegate {
    func collectionReloadData() {
        DispatchQueue.main.async {
            self.loadingView.stopAnimating()
            self.collectionView.reloadData()
            self.slideCollectionView.reloadData()
            self.outerView.isHidden = false
            self.loadingView.isHidden = true
        }
    }
}
