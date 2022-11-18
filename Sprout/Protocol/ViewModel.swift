//
//  ViewModel.swift
//  Sprout
//
//  Created by 이정호 on 2022/11/16.
//

import Foundation
import RxSwift
import UIKit
import WeakMapTable

#if os(iOS)
private typealias OSViewController = UIViewController
#endif

private typealias AnyView = AnyObject
private enum MapTables {
    static let viewModel = WeakMapTable<AnyView, Any>()
    static let isReactorBinded = WeakMapTable<AnyView, Bool>()
}

public protocol _ObjCStoryboardView {
    func performBinding()
}

public protocol ViewModel: View, _ObjCStoryboardView { }

extension ViewModel {
    public var viewModel: ViewModel? {
        get { return MapTables.viewModel.value(forKey: self) as? ViewModel }
        set {
            MapTables.viewModel.setValue(newValue, forKey: self)
            self.isReactorBinded = false
            self.disposeBag = DisposeBag()
            self.performBinding()
        }
    }

    fileprivate var isReactorBinded: Bool {
        get { return MapTables.isReactorBinded.value(forKey: self, default: false) }
        set { MapTables.isReactorBinded.setValue(newValue, forKey: self) }
    }

    public func performBinding() {
        //DEBUG_LOG("enter the performBinding method")
        guard let viewModel = self.viewModel else { return DEBUG_LOG("viewModel nil") }
        guard !self.isReactorBinded else { return DEBUG_LOG("self.isReactorBinded") }
        guard !self.shouldDeferBinding(viewModel: viewModel) else { return DEBUG_LOG("self.shouldDeferBinding") }
        self.bind(viewModel: viewModel)
        self.isReactorBinded = true
    }

    fileprivate func shouldDeferBinding(viewModel: ViewModel) -> Bool {
        //DEBUG_LOG("shouldDeferBinding")
        return (self as? OSViewController)?.isViewLoaded == false
    }
}

extension OSViewController {
    @objc func _reactorkit_performBinding() {
        (self as? _ObjCStoryboardView)?.performBinding()
    }
}
