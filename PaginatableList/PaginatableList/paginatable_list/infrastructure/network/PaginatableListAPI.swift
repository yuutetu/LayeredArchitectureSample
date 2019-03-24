//
//  PaginatableListAPI.swift
//  PaginatableList
//
//  Created by 加賀江 優幸 on 2019/03/24.
//  Copyright © 2019 yuutetu. All rights reserved.
//

import RxSwift
import RxCocoa

let perPage = 100

struct Response {
    let list: [String]
    let pagination: Pagination
}

struct Pagination {
    let page: Int
}

protocol PaginatableListAPI {
    func request(with pagination: Pagination?) -> Single<Response>
}

class PaginatableListMockAPI: PaginatableListAPI {
    func request(with pagination: Pagination? = nil) -> Single<Response> {
        let page = (pagination?.page ?? 0)
        let base = page * perPage
        return Single.just(
            Response(
                list: (base..<base+perPage).map{ String($0) },
                pagination: Pagination(page: page + 1)
            )
        )
    }
}
