//
//  ViewController.swift
//  Premusic
//
//  Created by 林達也 on 2017/07/27.
//  Copyright © 2017年 jp.sora0077. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RealmSwift
import PremusicCore

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            let vc = StorefrontSelectViewController()
            self.present(vc, animated: true, completion: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

final class StorefrontSelectViewController: UIViewController {
    private lazy var presenter: SelectStorefront.Presenter = try! .init(input: self, output: self)  // swiftlint:disable:this force_try
    private let _select = PublishSubject<ThreadSafeReference<Entity.Storefront>>()

    private let tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        presenter.viewDidLoad()

        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableView.frame = view.bounds
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        view.addSubview(tableView)
    }
}

extension StorefrontSelectViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.storefronts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = presenter.storefronts[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = item.attributes?.name
        return cell
    }
}

extension StorefrontSelectViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        _select.onNext(presenter.storefronts[indexPath.row].ref)
    }
}

extension StorefrontSelectViewController: SelectStorefrontPresenterInput, SelectStorefrontPresenterOutput {
    var select: Observable<ThreadSafeReference<Entity.Storefront>> { return _select }

    func showStorefronts(_ storefronts: Results<Entity.Storefront>) {
        tableView.reloadData()
    }

    func showStorefronts(_ storefronts: Results<Entity.Storefront>, deletions: [Int], insertions: [Int], modifications: [Int]) {
        tableView.reloadData()
    }

    func selectStorefront(_ storefront: Entity.Storefront) {
        print(storefront)

//        dismiss(animated: true, completion: nil)
    }
}
