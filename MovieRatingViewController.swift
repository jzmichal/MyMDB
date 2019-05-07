//
//  MovieRatingViewController.swift
//  MyMDB
//
//  Created by Justin Michal on 1/22/19.
//  Copyright © 2019 Justin Michal. All rights reserved.
//
//Purpose of this class is once a user clicks on the rate button, this view is shown where the user can
//rate and write notes about the movie to save to their profile

import UIKit
import Firebase
class MovieRatingViewController: UIViewController {

    let intRatings = ["1","2","3","4","5","6","7","8","9"]
    let decimalRatings = [".0",".1",".2",".3",".4",".5",".6",".7",".8",".9"]
    var myInt: String!
    var myFloat: String!
    var ratingPicker: UIPickerView = {
        let p = UIPickerView()
        p.translatesAutoresizingMaskIntoConstraints =  false
        p.backgroundColor = UIColor.clear
        return p
        
    }()
    var myNotes: UITextField = {
        let tf = UITextField()
        tf.textColor = UIColor.white
        tf.translatesAutoresizingMaskIntoConstraints =  false
        tf.attributedPlaceholder = NSAttributedString(string:"Notes (Optional)", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        return tf
    }()
    var movieTitle: String!
    var moviePoster: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints =  false
        //view.contentMode = .scaleAspectFit
        return view
    }()
    var myRating: String!
    init(title: String, poster: UIImage, rating: String, notes: String) {
        self.movieTitle = title
        self.moviePoster.image = poster
        self.myRating = rating
        self.myNotes.text = notes
//        if rating != "" {
//            self.myRating = rating
//            let intRating = Int(rating.prefix(0))
//            let decimalRating = Int(rating.suffix(2))
//            print(intRating)
//            print(decimalRating)
//            self.ratingPicker.selectRow(intRating! - 1, inComponent: 0, animated: true)
//            self.ratingPicker.selectRow(decimalRating! , inComponent: 1, animated: true)
//        }
        
        if notes != "" {
            self.myNotes.attributedPlaceholder = NSAttributedString(string: notes, attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        }
        
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        view.backgroundColor = UIColor(r: 50, g: 50, b: 50)
        self.ratingPicker.dataSource = self
        self.ratingPicker.delegate = self
        super.viewDidLoad()
        self.view.addSubview(myNotes)
        self.view.addSubview(moviePoster)
        self.view.addSubview(ratingPicker)

        setupPosterView()
        setupRatingPicker()
        setupMyNotesTextField()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(HandleSave))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(HandleCancel))
        self.navigationController?.navigationBar.barTintColor =  UIColor(r: 50, g: 50, b: 50)
        self.navigationItem.title = movieTitle
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
    }

    @objc func HandleCancel(){
        self.navigationController?.popViewController(animated: true)
    }
    @objc func HandleSave() {

        let userID = Auth.auth().currentUser?.uid
        let ref = Firebase.Database.database().reference(fromURL: "https://mymdb-c3989.firebaseio.com/")
        let usersReference = ref.child("users").child(userID!).child("Shows").child("Movies").child("Seen").child(movieTitle)
        self.myRating = myInt + myFloat
        let values = ["rating" : self.myRating, "notes" : self.myNotes.text]
        usersReference.updateChildValues(values) { (err, ref) in
            if err != nil {
                print(err!)
                return
            }
        }
        self.navigationController?.popViewController(animated: true)
        
    }
    func setupInputsContainerView() {
        
    }
    func setupPosterView() {
        moviePoster.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        moviePoster.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        moviePoster.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1/2).isActive = true
        moviePoster.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1/2).isActive = true
    }
    
    func setupRatingPicker() {
        ratingPicker.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        ratingPicker.topAnchor.constraint(equalTo: moviePoster.bottomAnchor).isActive = true
        //ratingPicker.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        ratingPicker.heightAnchor.constraint(equalTo: moviePoster.heightAnchor).isActive = true
        ratingPicker.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }

    func setupMyNotesTextField() {
        myNotes.topAnchor.constraint(equalTo: ratingPicker.centerYAnchor).isActive = true
        myNotes.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        myNotes.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        myNotes.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
    }
}
extension MovieRatingViewController: UIPickerViewDelegate, UIPickerViewDataSource {
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
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        // use the row to get the selected row from the picker view
        // using the row extract the value from your datasource (array[row])
        if component == 0 {
            self.myInt = intRatings[row]
        }
        else {
            self.myFloat = decimalRatings[row]
        }

    }
}
