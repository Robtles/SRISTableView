//
//  SRISRequestTypeFake.swift
//  Example
//
//  Created by Rob on 20/09/2019.
//  Copyright © 2019 com.rob. All rights reserved.
//

import SRISTableView


struct FakeTimeError: Error {}

class SRISFakeRequest: NSObject, SRISRequest {
    
    typealias ContentType = Int
    
    var alreadyFetched = 0
    
    let alreadyLoadedCache = [3, 9, 11, 16, 17, 33]
    
    let tableData: [Int] = Array(0...100).shuffled()
    
    func load<Delegate>(delegate: Delegate, skipping: Int, cachingData: Bool, _ completion: @escaping ([Int]?, Error?) -> ()) where Delegate : SRISTableViewDelegate {
        let sortedTableData = self.tableData.sorted()
        let chunk = sortedTableData.suffix(sortedTableData.count - skipping).prefix(delegate.recordsPerRequest)
        SRISTableViewDelayer.delay(0.25) {
            self.alreadyFetched += chunk.count
            completion(Array(chunk), nil)
        }
    }
    
}
