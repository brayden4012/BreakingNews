//
//  ArticleService.swift
//  ADTCodingExercise
//
//  Created by Brayden Harris on 8/28/20.
//  Copyright © 2020 Brayden Harris. All rights reserved.
//

import UIKit

class ArticleService {
    static let headlinesUrlString = "https://newsapi.org/v2/top-headlines?country=us&apiKey=1437be957ba74f9e93cf1688a28a05ac"
    
    func getArticles(url: URL, completion: @escaping ([Article], Error?) -> Void) {
        
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let data = data else {
                print("Could not retrieve data from \(url)")
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let response = try decoder.decode(ArticleResponse.self, from: data)
                completion(response.articles, nil)
            } catch (let error) {
                completion([], error)
            }
        }.resume()
    }
    
    func fetchArticleImage(imageUrlString: String, completion: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: imageUrlString) else {
            completion(nil)
            return
        }
        
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                print(error.localizedDescription)
                completion(nil)
                return
            }
            
            guard let data = data else {
                print("Could not retrieve data from \(url)")
                completion(nil)
                return
            }
            
            let image = UIImage(data: data)
            guard let articleImage = image else {
                completion(nil)
                return
            }
            completion(articleImage)
        }.resume()
    }
}
