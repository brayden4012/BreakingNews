//
//  NewsArticleViewModel.swift
//  ADTCodingExercise
//
//  Created by Brayden Harris on 8/28/20.
//  Copyright © 2020 Brayden Harris. All rights reserved.
//

import UIKit

struct NewsArticleViewModel {
    var image: UIImage?
    var title: String
    var url: URL
    
    init(image: UIImage?, title: String, url: URL) {
        self.image = image
        self.title = title
        self.url = url
    }
}
