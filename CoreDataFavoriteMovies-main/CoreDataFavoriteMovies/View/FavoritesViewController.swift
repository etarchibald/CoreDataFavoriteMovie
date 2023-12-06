//
//  FavoritesViewController.swift
//  CoreDataFavoriteMovies
//
//  Created by Parker Rushton on 11/3/22.
//

import UIKit

class FavoritesViewController: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var backgroundView: UIView!
    
    private var datasource: UITableViewDiffableDataSource<Int, Movie>!
    private lazy var searchController: UISearchController = {
        let sc = UISearchController(searchResultsController: nil)
        sc.searchResultsUpdater = self
        sc.delegate = self
        sc.obscuresBackgroundDuringPresentation = false
        sc.searchBar.placeholder = "Search your Favorites"
        sc.searchBar.delegate = self
        return sc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
        setUpDataSource()
        navigationItem.searchController = searchController
        fetchFavoirtes()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetchFavoirtes()
    }
    
}

private extension FavoritesViewController {
    
    func setUpTableView() {
        tableView.backgroundView = backgroundView
        tableView.register(UINib(nibName: MovieTableViewCell.reuseIdentifier, bundle: nil), forCellReuseIdentifier: MovieTableViewCell.reuseIdentifier)
    }
    
    func setUpDataSource() {
        datasource = UITableViewDiffableDataSource<Int, Movie>(tableView: tableView) { tableView, indexPath, movie in
            let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.reuseIdentifier) as! MovieTableViewCell
            cell.update(with: movie) {
                self.removeFavorite(movie)
            }
            return cell
        }
    }
    
    func fetchFavoirtes() {
        let fetchRequest = Movie.fetchRequest()
        let searchString = searchController.searchBar.text ?? ""
        if !searchString.isEmpty {
            let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchString)
            fetchRequest.predicate = predicate
        }
        let sortDescriptor = NSSortDescriptor(key: "favoritedAt", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        let results = try? PersistenceController.shared.viewContext.fetch(fetchRequest)
        applyNewSnapshot(from: results ?? [])
    }
    
    func applyNewSnapshot(from movies: [Movie]) {
        var snapShot = NSDiffableDataSourceSnapshot<Int, Movie>()
        snapShot.appendSections([0])
        snapShot.appendItems(movies)
        datasource?.apply(snapShot, animatingDifferences: true)
        tableView.backgroundView = movies.isEmpty ? backgroundView : nil
    }
    
    func removeFavorite(_ movie: Movie) {
        MovieController.shared.unFavoriteMovie(movie)
        var snapShot = datasource.snapshot()
        snapShot.deleteItems([movie])
        datasource?.apply(snapShot, animatingDifferences: true)
    }
    
}

extension FavoritesViewController: UISearchControllerDelegate, UISearchResultsUpdating, UISearchBarDelegate  {
    func updateSearchResults(for searchController: UISearchController) {
        if searchController.searchBar.text?.isEmpty == true {
            fetchFavoirtes()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        fetchFavoirtes()
    }
}
