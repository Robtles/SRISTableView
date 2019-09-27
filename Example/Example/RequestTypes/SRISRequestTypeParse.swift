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
    
    func load<Delegate>(delegate: Delegate, skipping: Int, cachingData: Bool, _ completion: @escaping ([PFObject]?, Error?) -> ()) where Delegate : SRISTableViewDelegate {
        self.performQuery(delegate: delegate, skipping: skipping, cachingData: cachingData, fromCache: false, completion)
    }
    
    func loadFromCache<Delegate>(delegate: Delegate, _ completion: @escaping ([PFObject]?, Error?) -> ()) where Delegate : SRISTableViewDelegate {
        self.performQuery(delegate: delegate, skipping: 0, cachingData: delegate.shouldCacheData, fromCache: true, completion)
    }
    
    private func performQuery<Delegate: SRISDelegate>(delegate: Delegate, skipping: Int, cachingData: Bool, fromCache: Bool, _ completion: @escaping ([PFObject]?, Error?) -> ()) {
        let query = PFQuery(className: delegate.className)
        if fromCache {
            query.fromPin()
        }
        delegate.filterParameters.forEach { filter in
            switch filter.condition {
            case .containedIn:
                if let arrayValue = filter.value as? [Any] {
                    query.whereKey(filter.key, containedIn: arrayValue)
                }
            case .containsString:
                if let stringValue = filter.value as? String {
                    query.whereKey(filter.key, contains: stringValue)
                }
            case .equalTo:
                query.whereKey(filter.key, equalTo: filter.value)
            case .greaterThan:
                query.whereKey(filter.key, greaterThan: filter.value)
            case .greaterThanOrEqual:
                query.whereKey(filter.key, greaterThanOrEqualTo: filter.value)
            case .keyDoesNotExists:
                query.whereKeyDoesNotExist(filter.key)
            case .keyExists:
                query.whereKeyExists(filter.key)
            case .lessThan:
                query.whereKey(filter.key, lessThan: filter.value)
            case .lessThanOrEqual:
                query.whereKey(filter.key, lessThanOrEqualTo: filter.value)
            case .notContainedIn:
                if let arrayValue = filter.value as? [Any] {
                    query.whereKey(filter.key, notContainedIn: arrayValue)
                }
            case .notEqualTo:
                query.whereKey(filter.key, notEqualTo: filter.value)
            }
        }
        delegate.querySorting.forEach { sorting in
            switch sorting.sorting {
            case .ascending:
                query.addAscendingOrder(sorting.key)
            case .descending:
                query.addDescendingOrder(sorting.key)
            }
        }
        query.skip = skipping
        query.limit = fromCache ? .max : delegate.recordsPerRequest
        query.findObjectsInBackground { result, error in
            DispatchQueue.main.async {
                if cachingData {
                    PFObject.pinAll(inBackground: result)
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
