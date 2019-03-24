//
//  PaginatableListTableViewController.swift
//  PaginatableList
//
//  Created by 加賀江 優幸 on 2019/03/24.
//  Copyright © 2019 yuutetu. All rights reserved.
//

import UIKit
import RxSwift
import DifferenceKit

// ひとまず簡単のために・・・
extension String: Differentiable {}

class PaginatableListTableViewController: UITableViewController {
    private var items: [String] = []
    // TODO: ここをPaginatableListTableViewControllerから見れないようにしたい
    private var serviceState = PaginatableListService.State.initialize() {
        didSet {
            let changeset = StagedChangeset<[String]>(source: oldValue.list, target: serviceState.list)
            // TODO: なぜか2ページ目移行が追加できない？
            tableView.reload(using: changeset, with: .fade) { [weak self] (items) in
                self?.items = items
            }
        }
    }
    private let service = PaginatableListService()
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        service.load(withState: serviceState, reload: true).subscribe(onSuccess: { [weak self] state in
            self?.serviceState = state
        }).disposed(by: disposeBag)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // next page Request
        if indexPath.row >= items.count - 5 {
            service.load(withState: serviceState).subscribe(onSuccess: { [weak self] state in
                self?.serviceState = state
            }).disposed(by: disposeBag)
        }

        let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell", for: indexPath)
        cell.textLabel?.text = items[indexPath.row]
        return cell
    }
}
