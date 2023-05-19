//
//  SectionPopUp.swift
//  MertcanYaman_HW2
//
//  Created by mertcan YAMAN on 16.05.2023.
//

import UIKit
import NewsAPI

class SectionPopUp: UIViewController {
    
    // MARK: - IBOutlet Definitions
    @IBOutlet weak var remianingChoice: UILabel!
    @IBOutlet weak var sectionCollectionView: UICollectionView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var backView: UIView!
    
    // MARK: - Variable Definitions
    var numberOfItemPerRow: CGFloat = 3
    var collectionViewFlowLayout: UICollectionViewFlowLayout!
    var sectionViewModel: SectionPopUpViewModelProtocol! {
        didSet {
            sectionViewModel.delegate = self
        }
    }
    
    init() {
        super.init(nibName: "SectionPopUp", bundle: nil)
        self.modalPresentationStyle = .overFullScreen
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Override Funcs in UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
        setupCollectionViewLayout()
        sectionViewModel = SectionPopUpViewModel()
        setCollectionView()
        self.sectionViewModel.fetchSections()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(goBack))
        backView.addGestureRecognizer(tap)
    }

    override func viewDidAppear(_ animated: Bool) {
        let size = contentView.frame.size
        if size.width > size.height {
            numberOfItemPerRow = 5
            updateCollectionViewItemSize()
        }else {
            numberOfItemPerRow = 3
            updateCollectionViewItemSize()
        }
    }
    
    override func viewDidLayoutSubviews() {
        updateCollectionViewItemSize()
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        if UIApplication.shared.statusBarOrientation.isLandscape {
            self.numberOfItemPerRow = 5
        } else {
            self.numberOfItemPerRow = 3
        }
    }
    
    @IBAction func submitButtonClicked(_ sender: Any) {
        hide()
        if sectionViewModel.numberOfItemSelectedSection != 0 {
            NotificationCenter.default.post(name: Notification.Name("FetchSections"), object: nil, userInfo: ["section": sectionViewModel.getSelectedSections()])
        }
    }
    
    @objc func goBack() {
        hide()
    }
    // MARK: - Configure PopUp
    func configView() {
        self.view.backgroundColor = .clear
        self.backView.backgroundColor = .black.withAlphaComponent(0.6)
        self.backView.alpha = 0
        self.contentView.alpha = 0
        self.contentView.layer.cornerRadius = 10
    }
    
    func appear(sender: UIViewController) {
        sender.present(self, animated: false) {
            self.show()
        }
    }
    
    private func show() {
        UIView.animate(withDuration: 1, delay: 0.2) {
            self.backView.alpha = 1
            self.contentView.alpha = 1
        }
    }
    
    func hide() {
        UIView.animate(withDuration: 1, delay: 0, options: .curveEaseOut) {
            self.backView.alpha = 0
            self.contentView.alpha = 0
        } completion: { _ in
            self.dismiss(animated: false)
            self.removeFromParent()
        }
    }
    // MARK: - Configure CollectionView
    private func setupCollectionViewLayout() {
        self.collectionViewFlowLayout = UICollectionViewFlowLayout()
        sectionCollectionView.setCollectionViewLayout(self.collectionViewFlowLayout, animated: true)
    }
    
    private func updateCollectionViewItemSize() {
        let lineSpacing: CGFloat = 0
        let interItemSpacing:CGFloat = 5
        let width = ((self.contentView.frame.width - (self.numberOfItemPerRow - 1) * interItemSpacing)) / self.numberOfItemPerRow
        
        collectionViewFlowLayout.itemSize = CGSize(width: Int(width), height: Int(width))
        collectionViewFlowLayout.sectionInset = UIEdgeInsets.zero
        collectionViewFlowLayout.scrollDirection = .vertical
        collectionViewFlowLayout.minimumLineSpacing = lineSpacing
        collectionViewFlowLayout.minimumInteritemSpacing = lineSpacing
    }
    
    private func setCollectionView() {
        sectionCollectionView.dataSource = self
        sectionCollectionView.delegate = self
        sectionCollectionView.register(UINib(nibName: "SectionCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SectionCollectionViewCell")
    }
    
    private func setRemianingChoice() {
        if sectionViewModel.numberOfItemSelectedSection == 3 {
            DispatchQueue.main.async {
                self.remianingChoice.text = "You have no choice left"
            }
        }else {
            DispatchQueue.main.async {
                self.remianingChoice.text = "You have a maximum of \(3 - self.sectionViewModel.numberOfItemSelectedSection) choices"
            }
        }
    }
}

// MARK: - CollectionView Extension
extension SectionPopUp: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sectionViewModel.numberOfItemSection
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = sectionCollectionView.dequeueReusableCell(withReuseIdentifier: "SectionCollectionViewCell", for: indexPath) as! SectionCollectionViewCell
        guard let section = sectionViewModel.getSection(indexPath.row) else { return cell }
        if sectionViewModel.checkSelectedSection(indexPath.row) {
            cell.setup(section, backgroundColor: section.getColor(), isSelected: false)
        }else {
            cell.setup(section, backgroundColor: section.getColor(), isSelected: true)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if !sectionViewModel.checkSelectedSection(indexPath.row) && sectionViewModel.numberOfItemSelectedSection < 3 {
            sectionViewModel.appendToSelectedSections(indexPath.row)
        }else {
            sectionViewModel.removeToSelectedSections(indexPath.row)
        }
        setRemianingChoice()
        sectionCollectionView.reloadData()
    }
}

// MARK: - SectionPopUpViewModelDelegate Extension
extension SectionPopUp: SectionPopUpViewModelDelegate {
    
}
