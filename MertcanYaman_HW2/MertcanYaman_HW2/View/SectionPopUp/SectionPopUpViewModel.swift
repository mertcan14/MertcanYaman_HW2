//
//  SectionPopUpViewModel.swift
//  MertcanYaman_HW2
//
//  Created by mertcan YAMAN on 19.05.2023.
//

import Foundation
import NewsAPI

protocol SectionPopUpViewModelDelegate: AnyObject {
    
}

protocol SectionPopUpViewModelProtocol {
    var delegate: SectionPopUpViewModelDelegate? { get set }
    var numberOfItemSelectedSection: Int { get }
    var numberOfItemSection: Int { get }
    
    func fetchSections()
    func getSelectedSections() -> [Section]
    func checkSelectedSection(_ index: Int) -> Bool
    func getSection(_ index: Int) -> Section?
    func appendToSelectedSections(_ index: Int)
    func removeToSelectedSections(_ index: Int)
}

final class SectionPopUpViewModel {
    var delegate: SectionPopUpViewModelDelegate?
    var sections: [Section] = []
    var selectedSections: [Section] = []
    
    private func getSections() {
        for section in Section.allCases {
            if section != .home {
                sections.append(section)
            }
        }
    }
    
    private func appendSelectedSection(_ index: Int) {
        selectedSections.append(sections[index])
    }
    
    private func removeSelectedSection(_ cellIndex: Int) {
        if let index = selectedSections.firstIndex(of: sections[cellIndex]) {
            selectedSections.remove(at: index)
        }
    }
    
    private func checkSelectedInSection(_ index: Int) -> Bool {
        return selectedSections.contains(sections[index])
    }
}

extension SectionPopUpViewModel: SectionPopUpViewModelProtocol {
    func removeToSelectedSections(_ index: Int) {
        self.removeSelectedSection(index)
    }
    
    func appendToSelectedSections(_ index: Int) {
        self.appendSelectedSection(index)
    }
    
    func getSection(_ index: Int) -> Section? {
        if index >= 0 && index < self.numberOfItemSection {
            return sections[index]
        }
        return nil
    }
    
    func checkSelectedSection(_ index: Int) -> Bool {
        self.checkSelectedInSection(index)
    }
    
    func getSelectedSections() -> [Section] {
        return selectedSections
    }
    
    var numberOfItemSelectedSection: Int {
        self.selectedSections.count
    }
    
    var numberOfItemSection: Int {
        self.sections.count
    }
    
    func fetchSections() {
        self.getSections()
    }
}
