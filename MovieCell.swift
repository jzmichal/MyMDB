//
//  CustomMovieCell.swift
//  MyMDB
//
//  Created by Justin Michal on 1/20/19.
//  Copyright © 2019 Justin Michal. All rights reserved.
//

import Firebase
import UIKit

class MovieCell: UITableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    let intRatings = ["1","2","3","4","5","6","7","8","9"]
    let decimalRatings = [".0",".1",".2",".3",".4",".5",".6",".7",".8",".9"]
    let moviePosterView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints =  false
        return view
    }()
    let movieTitle: UILabel = {
        let button = UILabel()
        button.backgroundColor =  UIColor(r: 50, g: 50, b:50)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.textColor = UIColor.white
        return button
    }()
    let movieRottenTomatoRating: UILabel = {
        let view = UILabel()
        view.textColor = UIColor.orange
        view.font = UIFont(name: "GillSans-Italic" , size: 12)
        view.translatesAutoresizingMaskIntoConstraints =  false
        
        return view
    }()
    let movieIMDBRating: UILabel = {
        let view = UILabel()
        view.textColor = UIColor.yellow
        view.font = UIFont(name: "GillSans-Italic" , size: 12)
        view.translatesAutoresizingMaskIntoConstraints =  false
        
        return view
    }()
    let rottenTomatoImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints =  false
        view.image = UIImage(named: "rottentomatoes")
        return view
    }()
    let iMDBImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints =  false
        view.image = UIImage(named: "imdb")
        return view
    }()
    let movieCast: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints =  false
        view.font = UIFont(name: "AvenirNextCondensed-Regular" , size: 12)
        view.textColor = UIColor.lightGray
        view.numberOfLines = 2
        return view
        
    }()
    let movieGenre: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints =  false
        view.font = UIFont(name: "AvenirNextCondensed-Regular" , size: 12)
        view.textColor = UIColor.lightGray
        return view
    }()
    let movieYear: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints =  false
        view.textColor = UIColor.white
        return view
    }()
    let movieDescription: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints =  false
        view.font = UIFont(name: "GillSans-Italic" , size: 12)
        view.textColor = UIColor.lightGray
        view.numberOfLines = 4
        return view
    }()
    
    let movieRatingButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor =  UIColor.clear
        button.setTitle("RATE", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor(r:43, g: 216, b: 49), for: .normal)
        button.titleLabel?.font = UIFont(name: "Copperplate" , size: 14)
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 0.5
        button.layer.borderColor = UIColor(r:43, g: 216, b:49).cgColor
        button.titleLabel?.textAlignment = .center
        return button
    }()
    let queueButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("+", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont(name: "Copperplate" , size: 14)
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 0.5
        button.setTitleColor(UIColor(r:45, g: 159, b:236), for: .normal)
        button.layer.borderColor = UIColor(r:45, g: 159, b:236).cgColor
        return button
    }()
    let trailerButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor =  UIColor.clear
        button.setTitle("Trailer", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont(name: "Copperplate" , size: 14)
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 0.5
        button.setTitleColor(UIColor.red, for: .normal)
        button.layer.borderColor = UIColor.red.cgColor
        return button
    }()
    let cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor =  UIColor.clear
        button.setTitle("cancel", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont(name: "Copperplate" , size: 14)
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 0.5
        button.setTitleColor(UIColor.orange, for: .normal)
        button.layer.borderColor = UIColor.orange.cgColor
        return button
    }()
    let saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor =  UIColor.clear
        button.setTitle("save", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont(name: "Copperplate" , size: 14)
            button.layer.cornerRadius = 5
        button.layer.borderWidth = 0.5
        button.setTitleColor(UIColor.orange, for: .normal)
        button.layer.borderColor = UIColor.orange.cgColor
        return button
    }()
    let userRatingPicker: UIPickerView = {
        let p = UIPickerView()
        p.translatesAutoresizingMaskIntoConstraints =  false
        p.backgroundColor = UIColor.clear
        return p
    }()
    var userMovieNotes: UITextField = {
        let tf = UITextField()
        tf.textAlignment = .left
        tf.textColor = UIColor.yellow
        tf.contentVerticalAlignment = .top
        tf.translatesAutoresizingMaskIntoConstraints =  false
        tf.font = UIFont(name: "Farah", size: 12)
        tf.attributedPlaceholder = NSAttributedString(string: "Optional Notes", attributes: [.foregroundColor : UIColor.white, .font : UIFont(name: "GillSans-LightItalic", size: 12)])
        return tf
    }()
    var movieTrailerURL: String = ""
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        userRatingPicker.dataSource = self
        userRatingPicker.delegate = self
        self.backgroundColor = UIColor(r: 50, g:50, b:50)
        contentView.addSubview(movieTitle)
        contentView.addSubview(movieCast)
        contentView.addSubview(movieIMDBRating)
        contentView.addSubview(moviePosterView)
        contentView.addSubview(movieRottenTomatoRating)
        contentView.addSubview(rottenTomatoImageView)
        contentView.addSubview(iMDBImageView)
        contentView.addSubview(movieGenre)
        contentView.addSubview(movieYear)
        contentView.addSubview(movieDescription)
        contentView.addSubview(movieRatingButton)
        contentView.addSubview(queueButton)
        contentView.addSubview(trailerButton)
        contentView.addSubview(cancelButton)
        contentView.addSubview(saveButton)
        contentView.addSubview(userMovieNotes)
        contentView.addSubview(userRatingPicker)

        
        contentView.isUserInteractionEnabled = true
        
        
        setupMoviePosterView()
        setupMovieTitle()
        setupIMDBImageView()
        setupRottenTomatoImageView()
        setupMovieGenre()
        setupMovieIMDBRating()
        setupMovieRottenTomatoRating()
        setupMovieYear()
        setupMovieDescription()
        setupMovieCast()
        setupMyRatingButton()
        setupAddToQueueButton()
        setupTrailerButton()
        setupSaveButton()
        setupCancelButton()
        setupRatingPicker()
        setupUserMovieNotes()
        setupRatingPicker()
        
        cancelButton.isHidden = true
        saveButton.isHidden = true
        userRatingPicker.isHidden = true
        userMovieNotes.isHidden = true
        
    }
    func fetchVideos(){
        
    }
    @objc func handleAddToWatchQueue() {
        
    }
    @objc func handleTrailer() {
        
    }
    
    @objc func handleUserMovieRating() {
        trailerButton.isHidden = true
        moviePosterView.isHidden = true
        movieYear.isHidden = true
        movieCast.isHidden = true
        movieGenre.isHidden = true
        movieTitle.isHidden = true
        movieDescription.isHidden = true
        movieIMDBRating.isHidden = true
        movieRatingButton.isHidden = true
        movieRottenTomatoRating.isHidden = true
        rottenTomatoImageView.isHidden = true
        iMDBImageView.isHidden = true
        queueButton.isHidden = true
        
        cancelButton.isHidden = false
        saveButton.isHidden = false
        userRatingPicker.isHidden = false
        userMovieNotes.isHidden = false
    }
    
    @objc func handleSave() {
        //set up the view
        trailerButton.isHidden = false
        moviePosterView.isHidden = false
        movieYear.isHidden = false
        movieCast.isHidden = false
        movieGenre.isHidden = false
        movieTitle.isHidden = false
        movieDescription.isHidden = false
        movieIMDBRating.isHidden = false
        movieRatingButton.isHidden = false
        movieRottenTomatoRating.isHidden = false
        rottenTomatoImageView.isHidden = false
        iMDBImageView.isHidden = false
        queueButton.isHidden = false
        
        cancelButton.isHidden = true
        saveButton.isHidden = true
        userRatingPicker.isHidden = true
        userMovieNotes.isHidden = true
        
        //save the users movie rating and notes to users database
        let userID = Auth.auth().currentUser?.uid
        let ref = Firebase.Database.database().reference(fromURL: "https://mymdb-c3989.firebaseio.com/")
        let usersReference = ref.child("users").child(userID!).child("Shows").child("Movies").child("Seen").child(movieTitle.text!)
        let one =  userRatingPicker.selectedRow(inComponent: 0)
        let two = userRatingPicker.selectedRow(inComponent: 1)
        let rating = intRatings[one] + intRatings[two]
        let notes = userMovieNotes.text
        let values = ["rating" : rating, "notes" : notes]
        usersReference.updateChildValues(values) { (err, ref) in
            if err != nil {
                print(err!)
                return
            }
        }
        //update rating button of movie to display the users rating
        self.movieRatingButton.titleLabel?.text = rating
    }
    @objc func handleCancel() {
        trailerButton.isHidden = false
        moviePosterView.isHidden = false
        movieYear.isHidden = false
        movieCast.isHidden = false
        movieGenre.isHidden = false
        movieTitle.isHidden = false
        movieDescription.isHidden = false
        movieIMDBRating.isHidden = false
        movieRatingButton.isHidden = false
        movieRottenTomatoRating.isHidden = false
        rottenTomatoImageView.isHidden = false
        iMDBImageView.isHidden = false
        queueButton.isHidden = false
        
        cancelButton.isHidden = true
        saveButton.isHidden = true
        userRatingPicker.isHidden = true
        userMovieNotes.isHidden = true
    }

    func setMovie(movie: Movie) {
        self.movieTitle.text = movie.title
        self.movieYear.text = " (\(movie.year))"
        self.movieCast.text = movie.cast
        self.movieGenre.text = movie.genre
        self.movieIMDBRating.text = movie.imdbRating
        self.movieRottenTomatoRating.text = movie.rottenTomatoestRating
        self.moviePosterView.image = movie.poster
        self.movieDescription.text = movie.description
        
        checkIfUserHasSeenMovie()
        //find out if user has rated movie. Two cases from here
        //1. He hasnt rated it. In this case we want to do do nothing and make sure our RATE button says rate
        //2. He has. In this case we want to display the users rating
    
    }
    func checkIfUserHasSeenMovie() {
        let userID = Auth.auth().currentUser?.uid
        
        Firebase.Database.database().reference(fromURL: "https://mymdb-c3989.firebaseio.com/").child("users").child(userID!).child("Shows").child("Movies").child("Seen").child(movieTitle.text!).observeSingleEvent(of: .value, with: {(snapshotView) in
            if let dictionary = snapshotView.value as? [String: AnyObject] {
                let userRating = dictionary["rating"] as! String
                let userNotes = dictionary["notes"] as! String
                self.movieRatingButton.titleLabel?.text = userRating
                self.userMovieNotes.text = userNotes
                let row1 = userRating.prefix(1)
                let row2 = userRating.suffix(2)
                print(row1, row2)
                //userRatingPicker.selectRow(<#T##row: Int##Int#>, inComponent: 0, animated: true)
            }
        }, withCancel: nil)
    }
    func setupUserRatingPicker() {
        userRatingPicker.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        userRatingPicker.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        userRatingPicker.heightAnchor.constraint(equalTo: contentView.heightAnchor).isActive = true
        
    }
    func setupSaveButton() {
        saveButton.addTarget(self, action: #selector(handleSave), for: .touchUpInside)
        saveButton.bottomAnchor.constraint(equalTo: contentView.centerYAnchor, constant: -5).isActive = true
        saveButton.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 1/3).isActive = true
        saveButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        saveButton.widthAnchor.constraint(equalToConstant: 70).isActive = true

        
    }
    func setupCancelButton() {
        cancelButton.addTarget(self, action: #selector(handleCancel), for: .touchUpInside)
        cancelButton.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 1/3).isActive = true
        cancelButton.topAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 5).isActive = true
        cancelButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        cancelButton.widthAnchor.constraint(equalToConstant: 70).isActive = true
    }
    func setupUserMovieNotes() {
        userMovieNotes.leftAnchor.constraint(equalTo: saveButton.rightAnchor, constant: 5).isActive = true
        userMovieNotes.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5).isActive = true
        userMovieNotes.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        userMovieNotes.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
    }
    func setupMoviePosterView() {
        //need x,y, height, width constraints
        moviePosterView.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        moviePosterView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        moviePosterView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 1/4).isActive = true
        moviePosterView.heightAnchor.constraint(equalTo: contentView.heightAnchor).isActive = true
        
    }
    func setupMovieTitle() {
        movieTitle.leftAnchor.constraint(equalToSystemSpacingAfter: moviePosterView.rightAnchor, multiplier: 1).isActive = true
        movieTitle.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        movieTitle.widthAnchor.constraint(lessThanOrEqualToConstant: 125).isActive = true
        movieTitle.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 1/4).isActive = true
        
    }
    func setupMovieYear() {
        movieYear.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        movieYear.leftAnchor.constraint(equalTo: movieTitle.rightAnchor).isActive = true
        movieYear.rightAnchor.constraint(lessThanOrEqualTo: queueButton.leftAnchor).isActive = true
        movieYear.heightAnchor.constraint(equalTo: movieTitle.heightAnchor).isActive = true
    }
    func setupIMDBImageView(){
        iMDBImageView.leftAnchor.constraint(equalToSystemSpacingAfter: moviePosterView.rightAnchor, multiplier: 1).isActive = true
        iMDBImageView.topAnchor.constraint(equalTo: movieTitle.bottomAnchor).isActive = true
        iMDBImageView.widthAnchor.constraint(equalToConstant: 27).isActive = true
        iMDBImageView.heightAnchor.constraint(equalToConstant: 27).isActive = true
    }
    func setupRottenTomatoImageView() {
        rottenTomatoImageView.leftAnchor.constraint(equalToSystemSpacingAfter: moviePosterView.rightAnchor, multiplier: 1).isActive = true
        rottenTomatoImageView.topAnchor.constraint(equalTo: iMDBImageView.bottomAnchor).isActive = true
        rottenTomatoImageView.widthAnchor.constraint(equalToConstant: 27).isActive = true
        rottenTomatoImageView.heightAnchor.constraint(equalToConstant: 27).isActive = true
    }
    func setupMovieIMDBRating() {
        movieIMDBRating.leftAnchor.constraint(equalToSystemSpacingAfter: iMDBImageView.rightAnchor, multiplier: 1).isActive = true
        movieIMDBRating.topAnchor.constraint(equalTo: movieTitle.bottomAnchor).isActive = true
        movieIMDBRating.widthAnchor.constraint(equalToConstant: 27).isActive = true
        movieIMDBRating.heightAnchor.constraint(equalToConstant: 27).isActive = true
    }
    func setupMovieRottenTomatoRating(){
        movieRottenTomatoRating.leftAnchor.constraint(equalToSystemSpacingAfter: rottenTomatoImageView.rightAnchor, multiplier: 1).isActive = true
        movieRottenTomatoRating.topAnchor.constraint(equalTo: movieIMDBRating.bottomAnchor).isActive = true
        movieRottenTomatoRating.widthAnchor.constraint(equalToConstant: 27).isActive = true
        movieRottenTomatoRating.heightAnchor.constraint(equalToConstant: 27).isActive = true
    }
    func setupMovieGenre() {
        movieGenre.leftAnchor.constraint(equalTo: movieIMDBRating.rightAnchor).isActive = true
        movieGenre.topAnchor.constraint(equalTo: movieTitle.bottomAnchor).isActive = true
        movieGenre.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        movieGenre.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 1/8).isActive = true
        
    }
    func setupMovieCast() {
        movieCast.leftAnchor.constraint(equalTo: movieIMDBRating.rightAnchor).isActive = true
        movieCast.topAnchor.constraint(equalTo: movieDescription.bottomAnchor).isActive = true
        movieCast.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        movieCast.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        
    }
    func setupMovieDescription(){
        movieDescription.leftAnchor.constraint(equalTo: movieRottenTomatoRating.rightAnchor).isActive = true
        movieDescription.topAnchor.constraint(equalTo: movieGenre.bottomAnchor).isActive = true
        movieDescription.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        movieDescription.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 2/4).isActive = true

    }
    func setupMyRatingButton() {
        movieRatingButton.addTarget(self, action: #selector(handleUserMovieRating), for: .touchUpInside)
        movieRatingButton.topAnchor.constraint(equalTo: rottenTomatoImageView.bottomAnchor).isActive = true
        movieRatingButton.centerXAnchor.constraint(equalTo: rottenTomatoImageView.rightAnchor).isActive = true
        movieRatingButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
        movieRatingButton.heightAnchor.constraint(equalToConstant: 27).isActive = true
        
    }
    func setupAddToQueueButton() {
        queueButton.addTarget(self, action: #selector(handleAddToWatchQueue), for: .touchUpInside)
        queueButton.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        queueButton.bottomAnchor.constraint(equalTo: movieGenre.topAnchor).isActive = true
        queueButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        queueButton.rightAnchor.constraint(equalTo: trailerButton.leftAnchor).isActive = true

    }
    func setupTrailerButton() {
        trailerButton.addTarget(self, action: #selector(handleTrailer), for: .touchUpInside)
        trailerButton.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        trailerButton.bottomAnchor.constraint(equalTo: movieGenre.topAnchor).isActive = true
        trailerButton.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        trailerButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
    }
    func setupRatingPicker() {
        userRatingPicker.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        userRatingPicker.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        userRatingPicker.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        userRatingPicker.rightAnchor.constraint(equalTo: cancelButton.leftAnchor, constant: 5).isActive = true
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("Init coder: has not been implemented")
    }
}
extension MovieCell: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return intRatings.count
        } else {
            return decimalRatings.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return intRatings[row]
        } else {
            return decimalRatings[row]
        }
    }
}
