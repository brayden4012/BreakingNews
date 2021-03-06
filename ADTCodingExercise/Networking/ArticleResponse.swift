//
//  ArticleResponse.swift
//  ADTCodingExercise
//
//  Created by Brayden Harris on 8/28/20.
//  Copyright © 2020 Brayden Harris. All rights reserved.
//

import Foundation

struct ArticleResponse: Decodable {
    var status: String?
    var totalResults: Int?
    var articles: [Article]
}
