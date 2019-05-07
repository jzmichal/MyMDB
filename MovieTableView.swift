//
//  MovieTableView.swift
//  MyMDB
//
//  Created by Justin Michal on 1/31/19.
//  Copyright © 2019 Justin Michal. All rights reserved.
//

import UIKit

class MovieTableView: UITableView {
    var movies : [Movie]?
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


