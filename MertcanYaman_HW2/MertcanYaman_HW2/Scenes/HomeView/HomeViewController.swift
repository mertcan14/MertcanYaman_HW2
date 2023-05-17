//
//  ViewController.swift
//  MertcanYaman_HW2
//
//  Created by mertcan YAMAN on 11.05.2023.
//
import UIKit
import NewsAPI

class HomeViewController: UIViewController {
    
    var numberOfItemPerRow: CGFloat = 1
    var collectionViewFlowLayout: UICollectionViewFlowLayout!
    var slideCollectionViewFlowLayout: UICollectionViewFlowLayout!
    var homeViewModel: HomeViewModelProtocol! {
        didSet {
            homeViewModel.delegate = self
        }
    }
    
    @IBOutlet weak var selectSectionImage: UIImageView!
    @IBOutlet weak var outerView: UIView!
    @IBOutlet weak var slideCollectionView: UICollectionView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        homeViewModel = HomeViewModel()
        homeViewModel.getDataMulti([Section.home])
        collectionViewRegister()
        setupCollectionViewLayout()
        loadingView.startAnimating()
        setupNotificationCenter()
        setGestureRecognizer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.shadowColor = .clear
            appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
            appearance.backgroundColor = UIColor(red: 137/255, green: 36/255, blue: 31/255, alpha: 1)
            
            navigationController?.navigationBar.scrollEdgeAppearance = appearance
            navigationController?.navigationBar.standardAppearance = appearance
        } else {
            // Fallback on earlier versions
        }
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.homeViewModel.timerStart()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        updateCollectionViewItemSize()
        updateSlideCollectionViewItemSize()
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        if UIApplication.shared.statusBarOrientation.isLandscape {
            self.numberOfItemPerRow = 2
        } else {
            self.numberOfItemPerRow = 1
        }
    }
    
    @objc func getSections(notification: Notification) {
        DispatchQueue.main.async {
            self.loadingView.startAnimating()
            self.loadingView.isHidden = false
            self.outerView.isHidden = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            if let sections = notification.userInfo?.values.first as? [Section] {
                self.homeViewModel.getDataMulti(sections)
            }
        }
    }
    
    @objc func setSection() {
        let sectionPopUp = SectionPopUp()
        sectionPopUp.appear(sender: self)
    }
    
    @objc func goNextFromSlide() {
        self.homeViewModel.goNextFromSlideCollection()
    }
    
    @objc func goBackFromSlide() {
        self.homeViewModel.goBackFromSlideCollection()
    }
    
    private func setupCollectionViewLayout() {
        self.collectionViewFlowLayout = UICollectionViewFlowLayout()
        collectionView.setCollectionViewLayout(self.collectionViewFlowLayout, animated: true)
        
        self.slideCollectionViewFlowLayout = UICollectionViewFlowLayout()
        slideCollectionView.setCollectionViewLayout(self.slideCollectionViewFlowLayout, animated: true)
    }
    
    private func updateSlideCollectionViewItemSize() {
        let lineSpacing: CGFloat = 4
        let width = self.view.safeAreaLayoutGuide.layoutFrame.width - 4
        let height = 200
        
        slideCollectionViewFlowLayout.itemSize = CGSize(width: Int(width), height: height)
        slideCollectionViewFlowLayout.scrollDirection = .horizontal
        slideCollectionViewFlowLayout.minimumLineSpacing = lineSpacing
        slideCollectionViewFlowLayout.sectionInset.left = 2
        slideCollectionViewFlowLayout.sectionInset.right = 2
        slideCollectionView.decelerationRate = UIScrollView.DecelerationRate.fast
    }
    
    private func updateCollectionViewItemSize() {
        let lineSpacing: CGFloat = 0
        let interItemSpacing:CGFloat = 5
        let width = ((self.view.safeAreaLayoutGuide.layoutFrame.width - (self.numberOfItemPerRow - 1) * interItemSpacing)) / self.numberOfItemPerRow
        let height = 130
        
        collectionViewFlowLayout.itemSize = CGSize(width: Int(width), height: height)
        collectionViewFlowLayout.sectionInset = UIEdgeInsets.zero
        collectionViewFlowLayout.scrollDirection = .vertical
        collectionViewFlowLayout.minimumLineSpacing = lineSpacing
        collectionViewFlowLayout.minimumInteritemSpacing = lineSpacing
    }
    
    private func collectionViewRegister(){
        collectionView.register(UINib(nibName: "SmallNewsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SmallNewsCollectionViewCell")
        slideCollectionView.register(UINib(nibName: "SlideNewsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SlideNewsCollectionViewCell")
    }
    
    private func setupNotificationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(getSections(notification:)), name: Notification.Name("FetchSections"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(goBackFromSlide), name: Notification.Name("GoBack"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(goNextFromSlide), name: Notification.Name("GoNext"), object: nil)
    }
    
    private func setGestureRecognizer() {
        let sectionSelect = UITapGestureRecognizer(target: self, action: #selector(setSection))
        self.selectSectionImage.addGestureRecognizer(sectionSelect)
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
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SmallNewsCollectionViewCell", for: indexPath) as! SmallNewsCollectionViewCell
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
        let sendVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        if collectionView == self.collectionView {
            sendVC.newsModel = homeViewModel.getNews(indexPath.row + 4)
        }else {
            sendVC.newsModel = homeViewModel.getNews(indexPath.row)
        }
        sendVC.modalPresentationStyle = .fullScreen
        sendVC.modalTransitionStyle = .coverVertical
        present(sendVC, animated: true, completion: nil)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let width = scrollView.frame.width
        self.homeViewModel.currentCell = Int(scrollView.contentOffset.x / width)
    }
}

extension HomeViewController: HomeViewModelDelegate {
    func collectionViewScroll(indexPath: IndexPath) {
        self.slideCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
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
