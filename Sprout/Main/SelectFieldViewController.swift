//
//  SelectFieldViewController.swift
//  Sprout
//
//  Created by Blanc on 2022/11/10.
//  Copyright © 2022 Blanc. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class SelectFieldViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let sectionCategory = CategoryField.allCases.map { $0.rawValue }
    let rowCategory = CategoryField.allCases.map { $0.subcategory }
    
    var selectedRow: [IndexPath] = []
    
    var selectedFieldCategory: PublishSubject<[String]> = PublishSubject()
    
    var tappedSectionIndex: Int = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTableView()
        tableViewBind()
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        let bufferCategory: [String] = selectedRow.map { sectionCategory[$0.section] + " - " + rowCategory[$0.section][$0.row] }
        selectedFieldCategory.onNext(bufferCategory)
        
    }
    
    @IBAction func backButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension SelectFieldViewController {
    
    func tableViewBind() {
        
        tableView.rx.itemSelected
            .do(onNext: { [weak self] indexPath in
                guard let `self` = self else { return }
                guard let cell = self.tableView.cellForRow(at: indexPath) else { return }
                self.tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
                cell.accessoryType = cell.isSelected ? .checkmark : .none
            })
            .subscribe(onNext: { [weak self] (indexPath) in
                guard let `self` = self else { return }
                self.selectedRow.append(indexPath)
            }).disposed(by: disposeBag)
        
        tableView.rx.itemDeselected
            .do(onNext: { [weak self] indexPath in
                guard let `self` = self else { return }
                guard let cell = self.tableView.cellForRow(at: indexPath) else { return }
                self.tableView.deselectRow(at: indexPath, animated: false)
                cell.accessoryType = cell.isSelected ? .checkmark : .none
            })
            .subscribe(onNext: { [weak self] (indexPath) in
                guard let `self` = self else { return }
                if let index = self.selectedRow.firstIndex(of: indexPath) {
                    self.selectedRow.remove(at: index)
                }
            }).disposed(by: disposeBag)
        
    }
    
    func setTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsMultipleSelection = true
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
    }
    
}

extension SelectFieldViewController: FieldSectionHeaderDelegate {
    func tappedSectionIndex(index: Int) {
        if (self.tappedSectionIndex == -1) {
            self.tappedSectionIndex = index
            tableViewExpandSection(index)
        } else {
            if (self.tappedSectionIndex == index) {
                tableViewCollapeSection(index)
            } else {
                tableViewCollapeSection(self.tappedSectionIndex)
                tableViewExpandSection(index)
            }
        }
    }
    
    func tableViewCollapeSection(_ section: Int) {
        let sectionData = rowCategory[section]
        
        self.tappedSectionIndex = -1
        
        if (sectionData.count == 0) {
            return
        } else {
            var indexesPath = [IndexPath]()
            for i in 0 ..< sectionData.count {
                let index = IndexPath(row: i, section: section)
                indexesPath.append(index)
            }
            self.tableView.beginUpdates()
            self.tableView.deleteRows(at: indexesPath, with: UITableView.RowAnimation.fade)
            self.tableView.endUpdates()
        }
    }
    
    func tableViewExpandSection(_ section: Int) {
        let sectionData = rowCategory[section]
        
        if (sectionData.count == 0) {
            return
        } else {
            var indexesPath = [IndexPath]()
            for i in 0 ..< sectionData.count {
                let index = IndexPath(row: i, section: section)
                indexesPath.append(index)
            }
            self.tappedSectionIndex = section
            self.tableView.beginUpdates()
            self.tableView.insertRows(at: indexesPath, with: UITableView.RowAnimation.fade)
            self.tableView.endUpdates()
            for i in indexesPath {
                if let cell = tableView.cellForRow(at: i) {
                    if selectedRow.contains(i) {
                        cell.accessoryType = .checkmark
                    } else {
                        cell.accessoryType = .none
                    }
                }
            }
        }
        
    }
}

extension SelectFieldViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let title = rowCategory[indexPath.section][indexPath.row]
        cell.textLabel?.text = title
        cell.textLabel?.font = .systemFont(ofSize: 13)
        cell.selectionStyle = .none
        cell.tintColor = .signatureNWhite
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionCategory.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == tappedSectionIndex {
            return rowCategory[section].count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = TableBasicSectionView()
        let title = CategoryField.allCases.map { $0.rawValue }[section]
        let isSelected = section == tappedSectionIndex
        view.updateView(title: title, index: section, isSelected: isSelected)
        view.delegate = self
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        cell.layoutMargins = .zero
//        cell.separatorInset = .zero
//        cell.preservesSuperviewLayoutMargins = false
//    }
}
