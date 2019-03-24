//
//  PaginatableListAPI.swift
//  PaginatableList
//
//  Created by 加賀江 優幸 on 2019/03/24.
//  Copyright © 2019 yuutetu. All rights reserved.
//

import RxSwift
import RxCocoa

struct Response {
    let list: [String]
    let pagination: Pagination
}

struct Pagination {
    let page: Int
}

protocol PaginatableListAPI {
    func request() -> Single<Response>
}

class PaginatableListMockAPI: PaginatableListAPI {
    func request() -> Single<Response> {
        // TODO: しっかり連打対策しなきゃならない
        // TODO: Threadによるブロック処理もまともにやってない
        return Single.just(
            Response(
                list: (0..<10).map{ String($0) }, // TODO: ページに合わせたデータを返す
                pagination: Pagination(page: 1) // TODO: 次のページを返す
            )
        )
    }
}
