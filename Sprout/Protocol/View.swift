//
//  View.swift
//  Sprout
//
//  Created by 이정호 on 2022/11/16.
//

import Foundation
#if !os(Linux)
import RxSwift
import WeakMapTable

private typealias AnyView = AnyObject

private enum MapTables {
    static let viewModel = WeakMapTable<AnyView, Any>()
    static let input = WeakMapTable<AnyView, Any>()
    static let output = WeakMapTable<AnyView, Any>()
}

public protocol View: AnyObject {
    associatedtype ViewModel: ViewModelType
    
    var disposeBag: DisposeBag { get set }

    var viewModel: ViewModel? { get set }
    
    var input: ViewModel.Input? { get set }
    var output: ViewModel.Output? { get set }

    func bind(viewModel: ViewModel)
    
}

extension View {
    public var viewModel: ViewModel? {
        get { return MapTables.viewModel.value(forKey: self) as? ViewModel }
        set {
            MapTables.viewModel.setValue(newValue, forKey: self)
            self.disposeBag = DisposeBag()
            if let viewModel = newValue {
                self.bind(viewModel: viewModel)
            }
        }
    }
    
    public var input: ViewModel.Input? {
        get { return MapTables.input.value(forKey: self) as? ViewModel.Input }
        set {
            MapTables.input.setValue(newValue, forKey: self)
            self.disposeBag = DisposeBag()
            if let input = newValue, let viewModel = self.viewModel {
                DEBUG_LOG("ViewModel Input set new value")
                self.output = viewModel.transform(input)
            }
        }
    }
    
    public var output: ViewModel.Output? {
        get { return MapTables.output.value(forKey: self) as? ViewModel.Output }
        set {
            MapTables.output.setValue(newValue, forKey: self)
            self.disposeBag = DisposeBag()
        }
    }
}
#endif
