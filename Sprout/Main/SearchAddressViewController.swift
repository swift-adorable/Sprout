//
//  SearchAddressViewController.swift
//  Sprout
//
//  Created by Blanc on 2022/11/10.
//  Copyright © 2022 Blanc. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SearchAddressViewController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var searchController = UISearchController(searchResultsController: nil)
    
    var selectedAddress: PublishSubject<KakaoRestAPIModel.AddressSearch.Document> = PublishSubject()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        configureInit()
        
    }
    
    @IBAction func backButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

//extension SearchAddressViewController {
//    func bind(reactor: SearchAddressReactor) {
//        //MARK: Bindable With Reactor
//        reactor.state
//            .map { $0.addressList }
//            .do(onNext: { [weak self] data in
//                guard let `self` = self else { return }
//                if data.count <= 0 {
//                    let view = self.viewWithLabel(message: "검색 결과가 없습니다.")
//                    self.tableView.tableHeaderView = nil
//                    self.tableView.tableFooterView = view
//                } else {
//                    guard let keyword = self.searchController.searchBar.text else { return }
//                    let text = " '\(keyword)' 검색 결과"
//                    let view = self.viewWithLabel(message: text, textAlignment: .left)
//                    self.tableView.tableHeaderView = view
//                    self.tableView.tableFooterView = nil
//                }
//            })
//            .bind(to: tableView.rx.items) { (tableView, indexPath, dataSource) -> UITableViewCell in
//                let cell = UITableViewCell()
//                cell.textLabel?.text = dataSource.addressName
//                cell.selectionStyle = .none
//                return cell
//            }.disposed(by: disposeBag)
//
//        //MARK: Bindable With IBOutlet
//        searchController.searchBar.rx.searchButtonClicked
//            .withLatestFrom(searchController.searchBar.rx.text.orEmpty)
//            .map { SearchAddressReactor.Action.searchAddress(keyWord: $0, page: reactor.page) }
//            .bind(to: reactor.action)
//            .disposed(by: disposeBag)
//
//        tableView.rx.itemSelected
//            .withLatestFrom(reactor.state) { ($0, $1) }
//            .map { ($0.0, $0.1.addressList) }
//            .filter { $0.1.count > 0 }
//            .subscribe { [weak self] (indexPath, addressList) in
//                guard let `self` = self else { return }
//                DEBUG_LOG(addressList[indexPath.row])
//                self.selectedAddress.onNext(addressList[indexPath.row])
//                self.navigationController?.popViewController(animated: true)
//            }.disposed(by: disposeBag)
//
//        tableView.rx.willDisplayCell.map { $1 }
//            .withLatestFrom(reactor.state) { ($0, $1) }
//            .filter { !$0.1.isEnd }
//            .filter { $0.0.item == $0.1.addressList.count - 1 }
//            .map { _ in SearchAddressReactor.Action.loadNextPage }
//            .bind(to: reactor.action)
//            .disposed(by: disposeBag)
//
//    }
//}
//
//extension SearchAddressViewController {
//
//    func configureInit() {
//        self.reactor = SearchAddressReactor()
//
//        searchController.searchBar.sizeToFit()
//        searchController.obscuresBackgroundDuringPresentation = false
//        searchController.hidesNavigationBarDuringPresentation = true
//        searchController.searchBar.placeholder = "동/읍/면으로 검색 (ex. 서초동)"
//        navigationItem.searchController = self.searchController
//        navigationItem.hidesSearchBarWhenScrolling = false
//
//        tableView.rx.setDelegate(self).disposed(by: disposeBag)
//    }
//
//}
//
//extension SearchAddressViewController: UITableViewDelegate {
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableView.automaticDimension
//    }
//
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        cell.layoutMargins = .zero
//        cell.separatorInset = .zero
//        cell.preservesSuperviewLayoutMargins = false
//    }
//}
