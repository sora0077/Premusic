//
//  SearchViewController.swift
//  Premusic
//
//  Created by 林達也 on 2017/09/28.
//  Copyright © 2017年 jp.sora0077. All rights reserved.
//

import UIKit
import PremusicCore

extension UIScrollView {

}

final class SearchViewController: UIViewController {
    private enum Section {
        case songs, loadSongs
    }
    private lazy var presenter: Module.SearchResources.Presenter = .init(input: self, output: self)

    private let tableView = UITableView()
    private let searchController = UISearchController(searchResultsController: nil)
    private let sections: [Section] = [.songs, .loadSongs]
    private var canLoadSongs = false

    private let _loadSongs = PublishSubject<Void>()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "検索"

        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(closeAction))

        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false

        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableView.frame = view.bounds
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        view.addSubview(tableView)

        searchController.searchBar.delegate = self
    }

    @objc
    private func closeAction() {
        dismiss(animated: true, completion: nil)
    }
}

extension SearchViewController: SearchResourcesPresenterInput, SearchResourcesPresenterOutput {
    var loadSongs: Observable<Void> { return _loadSongs }

    func showSongs(_ songs: List<Entity.Song>?) {
        tableView.reloadData()
    }

    func showSongs(_ songs: List<Entity.Song>?, diff: Presenter.Diff) {
        tableView.reloadData()
    }

    func showEmpty() {
        tableView.reloadData()
    }

    func showLoadSongs() {
        canLoadSongs = true
        tableView.reloadData()
//        tableView.reloadSections(IndexSet(integer: 1), with: .bottom)
    }

    func hideLoadSongs() {
        canLoadSongs = false
        tableView.reloadData()
//        tableView.reloadSections(IndexSet(integer: 1), with: .top)
    }
}

extension SearchViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch sections[section] {
        case .songs: return presenter.songs?.count ?? 0
        case .loadSongs: return canLoadSongs ? 1 : 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch sections[indexPath.section] {
        case .songs:
            let song = presenter.songs[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            cell.textLabel?.text = song.attributes?.name
            cell.imageView?.setImage(with: song.attributes?.artwork, size: 50)
            return cell
        case .loadSongs:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            cell.textLabel?.text = "読み込む"
            cell.imageView?.image = nil
            return cell
        }
    }
}

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch sections[indexPath.section] {
        case .songs:()
        case .loadSongs: _loadSongs.onNext(())
        }
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        presenter.search(.songs(from: searchText))
    }
}
