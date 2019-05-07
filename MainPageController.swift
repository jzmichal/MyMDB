//
//  ViewController.swift
//  MyMDB
//
//  Created by Justin Michal on 1/11/19.
//  Copyright © 2019 Justin Michal. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
class MainPageController: UIViewController {
    var genres: [String] = []
    var genreTableViews: [UITableView] = []
    var inTheatersMovies: [Movie] = []
    var recommendedMovies: [Movie] = []
    var listOfMoviesPerGenre: [[Movie]] = []
    var currGenreTable: UITableView?
    lazy var mainThreeTabsSegmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["In Theaters", "Recommended", "Genres"])
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.tintColor = UIColor.white
        sc.selectedSegmentIndex = 0
        sc.addTarget(self, action: #selector(handleMainThreeTabsUpdate), for: .valueChanged)
        return sc
    }()
    lazy var inTheatersTableView: UITableView = {
        let t = UITableView(frame: .zero, style: .plain)
        t.translatesAutoresizingMaskIntoConstraints = false
        t.tag = -1
        t.delegate = self
        t.dataSource = self
        t.isScrollEnabled = true
        t.isUserInteractionEnabled = true
        t.rowHeight = view.frame.height / 6
        t.allowsSelection = false
        return t
    }()
    lazy var genresTableView: UITableView = {
        let t = UITableView(frame: .zero, style: .plain)
        t.translatesAutoresizingMaskIntoConstraints = false
        t.tag = -3
        t.delegate = self
        t.dataSource = self
        t.isScrollEnabled = true
        t.isUserInteractionEnabled = true
        return t
    }()
    lazy var recommendedTableView: UITableView = {
        let t = UITableView(frame: .zero, style: .plain)
        t.translatesAutoresizingMaskIntoConstraints = false
        t.tag = -2
        t.delegate = self
        t.dataSource = self
        t.isScrollEnabled = true
        t.isUserInteractionEnabled = true
        t.allowsSelection = false
        t.rowHeight = view.frame.height / 6
        return t
    }()
    lazy var searchBar: UISearchBar = {
        let bar = UISearchBar()
        let myAcc =  UIImage(named: "myAccountIcon")
        bar.translatesAutoresizingMaskIntoConstraints = false
        bar.barTintColor = UIColor(r: 50, g: 50, b: 50)
        //bar.barStyle = .blackTranslucent
        return bar
        
    }()
    lazy var myAccButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let myAcc =  UIImage(named: "myAccountIcon")
        button.setImage(myAcc, for: .normal)
        return button
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(r: 50, g: 50, b: 50)
        checkIfUserIsLoggedIn()
        self.navigationController?.navigationBar.isHidden = true
        view.addSubview(genresTableView)
        view.addSubview(inTheatersTableView)
        view.addSubview(mainThreeTabsSegmentedControl)
        view.addSubview(recommendedTableView)
        view.addSubview(searchBar)
        view.addSubview(myAccButton)
        
        setupMainThreeTabs()
        setupNavBar()
        setupTableViews()
        setupMyAccButton()
    }

    func checkIfUserIsLoggedIn() {
        if Auth.auth().currentUser?.uid == nil {
            //user is not logged in
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
        }
    }
    @objc
    func handleLogout() {
        
        do {
            try Auth.auth().signOut()
        } catch let logoutError {
            print(logoutError)
        }
        let loginController = LoginController()
        present(loginController, animated: true, completion: nil)
    }

    let movieCache = NSCache<NSString, Movie>()
    
    func handleMyAccount(){
        
    }
    
    @objc func handleMainThreeTabsUpdate() {
        let currentTableViewIndex = mainThreeTabsSegmentedControl.selectedSegmentIndex
        if currentTableViewIndex == 0 {
            self.currGenreTable?.isHidden = true
            self.inTheatersTableView.reloadData()
            self.inTheatersTableView.isHidden = false
            self.genresTableView.isHidden = true
            self.recommendedTableView.isHidden = true
        }
        else if currentTableViewIndex == 1 {
            self.currGenreTable?.isHidden = true
            self.recommendedTableView.reloadData()
            self.inTheatersTableView.isHidden = true
            self.genresTableView.isHidden = true
            self.recommendedTableView.isHidden = false
            }
        else {
            self.genresTableView.reloadData()
            self.inTheatersTableView.isHidden = true
            self.genresTableView.isHidden = false
            self.recommendedTableView.isHidden = true
        }
    }
    func setupMainThreeTabs() {
        //need x,y, height, width constraints
        mainThreeTabsSegmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        mainThreeTabsSegmentedControl.topAnchor.constraint(equalTo: searchBar.bottomAnchor).isActive = true
        mainThreeTabsSegmentedControl.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        mainThreeTabsSegmentedControl.heightAnchor.constraint(equalToConstant: 24).isActive = true
    }
    func setupTableViews() {
        inTheatersTableView.topAnchor.constraint(equalTo: mainThreeTabsSegmentedControl.bottomAnchor).isActive = true
        inTheatersTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        inTheatersTableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        inTheatersTableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        inTheatersTableView.register(MovieCell.self, forCellReuseIdentifier: "MovieCell")
        ApiService.sharedInstance.fetchInTheaters() { (movies) in
            DispatchQueue.main.async {
                self.inTheatersMovies = movies
                self.inTheatersTableView.reloadData()
            }
        }
        
        genresTableView.topAnchor.constraint(equalTo: mainThreeTabsSegmentedControl.bottomAnchor).isActive = true
        genresTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        genresTableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        genresTableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        self.genresTableView.register(UITableViewCell.self, forCellReuseIdentifier: "genreCell")
        self.genresTableView.isHidden = true
        ApiService.sharedInstance.fetchGenres() { (genres) in
            self.genres = genres.0
            ApiService.sharedInstance.fetchMoviesForGenre(genreIds: genres.1) { (movieListForGenre) in
                for movieList in movieListForGenre {
                    self.listOfMoviesPerGenre.append(movieList)
                }
                DispatchQueue.main.async {
                    //self.setupGenreTables()
                }
            }
        }

        
        recommendedTableView.topAnchor.constraint(equalTo: mainThreeTabsSegmentedControl.bottomAnchor, constant: 10).isActive = true
        recommendedTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        recommendedTableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        recommendedTableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        recommendedTableView.register(MovieCell.self, forCellReuseIdentifier: "MovieCell")
        ApiService.sharedInstance.fetchRecommended() { (movies) in
            self.recommendedMovies = movies
        }
        
    }
    func setupGenreTables() {
        var i = 0
        for movieList in listOfMoviesPerGenre {
            self.listOfMoviesPerGenre.append(movieList)
            let t = UITableView(frame: .zero, style: .plain)
            t.translatesAutoresizingMaskIntoConstraints = false
            t.tag = i
            t.delegate = self
            t.dataSource = self
            t.isScrollEnabled = true
            t.isUserInteractionEnabled = true
            t.allowsSelection = false
            t.rowHeight = self.view.frame.height / 6
            self.view.addSubview(t)
            t.topAnchor.constraint(equalTo: self.mainThreeTabsSegmentedControl.bottomAnchor).isActive = true
            t.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
            t.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
            t.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
            t.register(MovieCell.self, forCellReuseIdentifier: "MovieCell")
            i += 1
            t.isHidden = true
            self.genreTableViews.append(t)
            t.reloadData()
        }
        
    }
    func setupNavBar() {
        searchBar.topAnchor.constraint(equalTo: view.topAnchor, constant: 10).isActive = true
        searchBar.heightAnchor.constraint(equalToConstant: 60).isActive = true
        searchBar.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        searchBar.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 4/5).isActive = true
        
    }
    func setupMyAccButton() {
        myAccButton.leftAnchor.constraint(equalTo: searchBar.rightAnchor, constant: 12).isActive = true
        myAccButton.topAnchor.constraint(equalTo: searchBar.topAnchor, constant: 17).isActive = true
        myAccButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        myAccButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    @objc func handleSearch() {
        
    }
    @objc func handleMyAcc() {
        
    }
}

extension MainPageController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == -3 {
            return self.genres.count
        }
        else if tableView.tag == -2 {
            return self.recommendedMovies.count
        }
        else if tableView.tag == -1 {
            return self.inTheatersMovies.count
        }
        else {
            return self.listOfMoviesPerGenre[tableView.tag].count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView.tag == -3 {
            let row = self.genres[indexPath.row]
            let cell = genresTableView.dequeueReusableCell(withIdentifier: "genreCell", for: indexPath)
            cell.backgroundColor = view.backgroundColor
            cell.textLabel?.text = row
            cell.textLabel?.textColor = UIColor.white
            return cell
            
        }
        else if tableView.tag == -2 {
            let movie = self.recommendedMovies[indexPath.row]
            let cell = recommendedTableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
            cell.setMovie(movie: movie)
            return cell
        }
        else if tableView.tag == -1 {
            let movie = self.inTheatersMovies[indexPath.row]
            let cell = inTheatersTableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
            cell.setMovie(movie: movie)
            return cell
        }
        else {
            let table = self.genreTableViews[tableView.tag]
            let movie = listOfMoviesPerGenre[tableView.tag][indexPath.row]
            let cell = table.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
            cell.setMovie(movie: movie)
            return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("here")
        if tableView.tag == -3 {
            let newTableView = genreTableViews[indexPath.row]
            genresTableView.isHidden = true
            newTableView.isHidden = false
            self.currGenreTable = newTableView
            
        }
    }
}
    


