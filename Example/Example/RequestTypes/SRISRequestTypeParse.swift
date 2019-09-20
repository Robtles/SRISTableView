//
//  SRISRequestTypeParse.swift
//  Example
//
//  Created by Rob on 20/09/2019.
//  Copyright © 2019 com.rob. All rights reserved.
//

import Parse
import SRISTableView



struct SRISParseRequest: SRISRequest {
    
    typealias ContentType = PFObject
    
    func load<Delegate>(delegate: Delegate, skipping: Int, cachingData: Bool, _ completion: @escaping ([PFObject]?, Error?) -> ()) where Delegate : SRISTableViewDelegate {
        self.performQuery(delegate: delegate, skipping: skipping, cachingData: cachingData, fromCache: delegate.shouldCacheData, completion)
    }
    
    func loadFromCache<Delegate>(delegate: Delegate, _ completion: @escaping ([PFObject]?, Error?) -> ()) where Delegate : SRISTableViewDelegate {
        self.performQuery(delegate: delegate, skipping: 0, cachingData: delegate.shouldCacheData, fromCache: false, completion)
    }
    
    private func performQuery<Delegate: SRISDelegate>(delegate: Delegate, skipping: Int, cachingData: Bool, fromCache: Bool, _ completion: @escaping ([PFObject]?, Error?) -> ()) {
        let query = PFQuery(className: delegate.className)
        if fromCache {
            query.fromLocalDatastore()
        }
        delegate.filterParameters.forEach { key, value in
            query.whereKey(key, equalTo: value)
        }
        if let sorting = delegate.querySorting {
            switch sorting.sorting {
            case .ascending:
                query.addAscendingOrder(sorting.key)
            case .descending:
                query.addDescendingOrder(sorting.key)
            }
        }
        query.limit = delegate.recordsPerRequest
        query.skip = skipping
        query.findObjectsInBackground { result, error in
            DispatchQueue.main.async {
                if cachingData {
                    result?.forEach({ object in
                        object.pinInBackground()
                    })
                }
                if let error = error {
                    completion(nil, error)
                } else if let result = result {
                    completion(result, nil)
                }
            }
        }
    }
    
}
