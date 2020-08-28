//
//  NewsArticleCell.swift
//  ADTCodingExercise
//
//  Created by Brayden Harris on 8/28/20.
//  Copyright © 2020 Brayden Harris. All rights reserved.
//

import UIKit

class NewsArticleCell: UITableViewCell {

    @IBOutlet weak var articleImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func prepareForReuse() {
        articleImageView.image = nil
        titleLabel.text = nil
    }
    
    func configure(with viewModel: NewsArticleViewModel) {
        articleImageView.image = viewModel.image ?? UIImage(named: "news-placeholder")
        titleLabel.text = viewModel.title
    }

}
