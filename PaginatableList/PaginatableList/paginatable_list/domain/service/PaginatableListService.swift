//
//  PaginatableListService.swift
//  PaginatableList
//
//  Created by 加賀江 優幸 on 2019/03/24.
//  Copyright © 2019 yuutetu. All rights reserved.
//

import RxSwift

class PaginatableListService {
    struct State {
        let list: [String]
        let pagination: Pagination?

        static func initialize() -> State {
            return State(list: [], pagination: nil)
        }
    }

    private let api: PaginatableListAPI = PaginatableListMockAPI()

    func load(withState state: State, reload: Bool = false) -> Single<State> {
        return api.request() // TODO: state.paginationを反映させる
            .map({ response -> State in
                State(
                    list: reload ? response.list : state.list + response.list,
                    pagination: response.pagination
                )
            })
    }
}
