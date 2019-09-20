//
//  SRISTableViewRequest.swift
//  SRISTableView
//
//  Created by Rob on 19/09/2019.
//  Copyright © 2019 com.rob. All rights reserved.
//

import UIKit


public typealias SRISRequest = SRISTableViewRequestType

public protocol SRISTableViewRequestType {
    
    /// The content type associated
    associatedtype ContentType where ContentType: Equatable

    /// Called only if delegate.shouldLoadCacheDataFirst is set to true.
    func loadFromCache<Delegate: SRISDelegate>(delegate: Delegate, _ completion: @escaping ([ContentType]?, Error?) -> ())
    
    /// How to fetch data from network
    func load<Delegate: SRISDelegate>(delegate: Delegate, skipping: Int, cachingData: Bool, _ completion: @escaping ([ContentType]?, Error?) -> ())
    
}

public extension SRISRequest {
    
    func loadFromCache<Delegate: SRISDelegate>(delegate: Delegate, _ completion: @escaping ([ContentType]?, Error?) -> ()) {}
    
}
