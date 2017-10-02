//
//  SearchViewController.swift
//  Premusic
//
//  Created by 林達也 on 2017/09/28.
//  Copyright © 2017年 jp.sora0077. All rights reserved.
//

import UIKit
import PremusicCore
import AutolayoutHelper

extension UIScrollView {

}

final class SearchViewController: UIViewController {
    private enum Section {
        case songs, loadSongs
    }
    private lazy var presenter: Module.SearchResources.Presenter = .init(input: self, output: self)

    private let collectionView = UICollectionView(frame: .zero,
                                                  collectionViewLayout: UICollectionViewFlowLayout())
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

        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.frame = view.bounds
        collectionView.backgroundColor = .white
        collectionView.alwaysBounceVertical = true
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(Cell.self, forCellWithReuseIdentifier: "Result")
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        view.addSubview(collectionView)

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
        collectionView.reloadData()
    }

    func showSongs(_ songs: List<Entity.Song>?, diff: Presenter.Diff) {
        func indexPaths(_ values: [Int]) -> [IndexPath] {
            return values.map { IndexPath(row: $0, section: 0) }
        }
        collectionView.performBatchUpdates({
            collectionView.reloadItems(at: indexPaths(diff.modifications))
            collectionView.insertItems(at: indexPaths(diff.insertions))
            collectionView.deleteItems(at: indexPaths(diff.deletions))
        }, completion: nil)
    }

    func showLoadSongsTrigger() {
        guard !canLoadSongs else { return }
        collectionView.performBatchUpdates({
            canLoadSongs = true
            collectionView.insertItems(at: [IndexPath(row: 0, section: 1)])
        }, completion: nil)
    }

    func hideLoadSongsTrigger() {
        guard canLoadSongs else { return }
        collectionView.performBatchUpdates({
            canLoadSongs = false
            collectionView.deleteItems(at: [IndexPath(row: 0, section: 1)])
        }, completion: nil)
    }

    func showLoadingSongs() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }

    func hideLoadingSongs() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}

extension SearchViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch sections[section] {
        case .songs: return presenter.songs?.count ?? 0
        case .loadSongs: return canLoadSongs ? 1 : 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch sections[indexPath.section] {
        case .songs:
            let song = presenter.songs[indexPath.row]
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Result", for: indexPath) as! Cell  // swiftlint:disable:this force_cast
            cell.artworkImageView.setImage(with: song.attributes?.artwork, size: 200)
            return cell
        case .loadSongs:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
            cell.backgroundColor = .blue
            return cell
        }
    }
}

extension SearchViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch sections[indexPath.section] {
        case .songs: return CGSize(width: 200, height: 200)
        case .loadSongs: return CGSize(width: 44, height: 44)
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
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
