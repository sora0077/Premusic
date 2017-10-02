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
    private var prevSearchText = ""

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
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.register(Cell.self, forCellReuseIdentifier: "Result")
        view.addSubview(tableView)

        searchController.dimsBackgroundDuringPresentation = false
        searchController.delegate = self
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
        func indexPaths(_ values: [Int]) -> [IndexPath] {
            return values.map { IndexPath(row: $0, section: 0) }
        }
        tableView.beginUpdates()
        tableView.reloadRows(at: indexPaths(diff.modifications), with: .automatic)
        tableView.insertRows(at: indexPaths(diff.insertions), with: .automatic)
        tableView.deleteRows(at: indexPaths(diff.deletions), with: .automatic)
        tableView.endUpdates()
    }

    func showLoadSongsTrigger() {
        guard !canLoadSongs else { return }
        canLoadSongs = true
        tableView.beginUpdates()
        tableView.insertRows(at: [IndexPath(row: 0, section: 1)], with: .bottom)
        tableView.endUpdates()
    }

    func hideLoadSongsTrigger() {
        guard canLoadSongs else { return }
        canLoadSongs = false
        tableView.beginUpdates()
        tableView.deleteRows(at: [IndexPath(row: 0, section: 1)], with: .top)
        tableView.endUpdates()
    }

    func showLoadingSongs() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }

    func hideLoadingSongs() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
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
            let cell = tableView.dequeueReusableCell(withIdentifier: "Result", for: indexPath) as! Cell  // swiftlint:disable:this force_cast
            cell.artworkImageView.setImage(with: song.attributes?.artwork, size: 200)
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
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch sections[indexPath.section] {
        case .songs: return 200
        case .loadSongs: return 44
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch sections[indexPath.section] {
        case .songs:()
        case .loadSongs: _loadSongs.onNext(())
        }
    }
}

extension SearchViewController: UISearchControllerDelegate {
    func didDismissSearchController(_ searchController: UISearchController) {
        searchController.searchBar.text = prevSearchText
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        prevSearchText = searchText
        presenter.search(.songs(from: searchText))
    }
}
