//
//  PaginatableListTableViewController.swift
//  PaginatableList
//
//  Created by 加賀江 優幸 on 2019/03/24.
//  Copyright © 2019 yuutetu. All rights reserved.
//

import UIKit
import RxSwift

class PaginatableListTableViewController: UITableViewController {
    private var serviceState = PaginatableListService.State.initialize()
    private let service = PaginatableListService()
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        service.load(withState: serviceState, reload: true).subscribe(onSuccess: { [weak self] state in
            self?.serviceState = state
            self?.tableView.reloadData() // TODO: DifferenceKitでいい感じにする
        }).disposed(by: disposeBag)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return serviceState.list.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // next page Request
        if indexPath.row >= serviceState.list.count - 2 {
            // TODO: 連打対策していないため、すばやくスクロールしたら二重でリクエストされる・・・
            service.load(withState: serviceState).subscribe(onSuccess: { [weak self] state in
                self?.serviceState = state
                self?.tableView.reloadData() // TODO: DifferenceKitでいい感じにする
            }).disposed(by: disposeBag)
        }

        let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell", for: indexPath)
        cell.textLabel?.text = serviceState.list[indexPath.row]
        return cell
    }
}
