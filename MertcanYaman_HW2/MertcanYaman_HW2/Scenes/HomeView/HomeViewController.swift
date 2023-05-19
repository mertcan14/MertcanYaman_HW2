//
//  ViewController.swift
//  MertcanYaman_HW2
//
//  Created by mertcan YAMAN on 11.05.2023.
//
import UIKit
import NewsAPI

class HomeViewController: UIViewController {
    
    // MARK: - IBOutlet Definitions
    @IBOutlet weak var selectSectionImage: UIImageView!
    @IBOutlet weak var outerView: UIView!
    @IBOutlet weak var slideCollectionView: UICollectionView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    
    // MARK: - Variable Definitions
    var numberOfItemPerRow: CGFloat = 1
    var collectionViewFlowLayout: UICollectionViewFlowLayout!
    var slideCollectionViewFlowLayout: UICollectionViewFlowLayout!
    var homeViewModel: HomeViewModelProtocol! {
        didSet {
            homeViewModel.delegate = self
        }
    }
    
    // MARK: - Override Funcs in UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        setLoading()
        homeViewModel = HomeViewModel()
        homeViewModel.getDataMulti([Section.home])
        collectionViewRegister()
        setupCollectionViewLayout()
        setupNotificationCenter()
        setGestureRecognizer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if !NetworkMonitor.shared.isConnected {
            let sendVC = UIStoryboard(name: "NotConnectionView", bundle: nil).instantiateViewController(withIdentifier: "NotConnectionViewController") as! NotConnectionViewController
            sendVC.modalPresentationStyle = .fullScreen
            sendVC.modalTransitionStyle = .coverVertical
            present(sendVC, animated: true, completion: nil)
        }
        checkDeviceOrientation()
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
    
    override func viewWillDisappear(_ animated: Bool) {
        self.homeViewModel.timerStop()
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
    
    // MARK: - Sections Funcs
    /// Retrieves selected sections from SectionPopUp
    @objc func getSections(notification: Notification) {
        self.homeViewModel.timerStop()
        DispatchQueue.main.async {
            self.loadingView.startAnimating()
            self.loadingView.isHidden = false
            self.outerView.isHidden = true
            if let sections = notification.userInfo?.values.first as? [Section] {
                self.homeViewModel.getDataMulti(sections)
            }
        }
    }
    /// Brings up the SectionPopUp
    @objc func setSection() {
        let sectionPopUp = SectionPopUp()
        sectionPopUp.appear(sender: self)
    }
    
    // MARK: - SlideCollectionView Funcs
    @objc func goNextFromSlide() {
        self.homeViewModel.goNextFromSlideCollection()
    }
    
    @objc func goBackFromSlide() {
        self.homeViewModel.goBackFromSlideCollection()
    }
    
    // MARK: - CollectionView Funcs
    /// Resizes cells according to the Orientation of the device
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
    
    /// Resizes cells according to the number of cells in the row according to the device's Orientation
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
    
    private func checkDeviceOrientation() {
        switch UIDevice.current.orientation{
        case .portrait:
            numberOfItemPerRow = 1
        case .landscapeLeft:
            numberOfItemPerRow = 2
        case .landscapeRight:
            numberOfItemPerRow = 2
        default:
            numberOfItemPerRow = 1
        }
    }
    
    // MARK: - Setup Funcs
    private func setupNotificationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(getSections(notification:)), name: Notification.Name("FetchSections"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(goBackFromSlide), name: Notification.Name("GoBack"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(goNextFromSlide), name: Notification.Name("GoNext"), object: nil)
    }
    
    private func setGestureRecognizer() {
        let sectionSelect = UITapGestureRecognizer(target: self, action: #selector(setSection))
        self.selectSectionImage.addGestureRecognizer(sectionSelect)
    }
    
    private func setLoading() {
        loadingView.startAnimating()
        self.outerView.isHidden = true
        self.loadingView.isHidden = false
    }
    
    private func setupCollectionViewLayout() {
        self.collectionViewFlowLayout = UICollectionViewFlowLayout()
        collectionView.setCollectionViewLayout(self.collectionViewFlowLayout, animated: true)
        
        self.slideCollectionViewFlowLayout = UICollectionViewFlowLayout()
        slideCollectionView.setCollectionViewLayout(self.slideCollectionViewFlowLayout, animated: true)
    }
    private func alertFuncForErrorGetData() {
        let alert = UIAlertController(title: "Sorry", message: "Unexpected error occurred redirecting to home page", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Go Home", style: .default, handler: { action in
            switch action.style{
                case .default:
                self.homeViewModel.getDataMulti([Section.home])
            @unknown default:
                print("Error Alert Func")
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
}

// MARK: - CollectionView Extension
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
        let sendVC = UIStoryboard(name: "DetailView", bundle: nil).instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
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

// MARK: - HomeViewModelDelegate Extension
extension HomeViewController: HomeViewModelDelegate {
    func collectionViewScroll(indexPath: IndexPath) {
        self.slideCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    func collectionReloadData() {
        if homeViewModel.numberOfNewsPreview == 0 {
            DispatchQueue.main.async {
                self.setLoading()
                self.alertFuncForErrorGetData()
            }
        }else {
            DispatchQueue.main.async {
                self.loadingView.stopAnimating()
                self.collectionView.reloadData()
                self.slideCollectionView.reloadData()
                self.outerView.isHidden = false
                self.loadingView.isHidden = true
                self.homeViewModel.timerStart()
            }
        }
    }
}
