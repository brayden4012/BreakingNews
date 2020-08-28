//
//  ViewController.swift
//  ADTCodingExercise
//
//  Created by Brayden Harris on 8/28/20.
//  Copyright © 2020 Brayden Harris. All rights reserved.
//

import SafariServices
import UIKit

class ViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    private let articleService = ArticleService()
    private var articles = [Article]()
    private var articleViewModels = [NewsArticleViewModel]()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchArticles()
    }

    // MARK: - Private
    private func fetchArticles() {
        guard let url = URL(string: ArticleService.headlinesUrlString) else {
            print("Unable to create headlines url")
            return
        }
        articleService.getArticles(url: url) { (articles, error) in
            if let error = error {
                print("Error getting articles: \(error)")
            }
            
            guard !articles.isEmpty else { return }
            let dispatchGroup = DispatchGroup()
            
            articles.forEach { (article) in
                guard let articleUrl = URL(string: article.url) else { dispatchGroup.leave(); return }
                dispatchGroup.enter()
                if let url = article.urlToImage {
                    self.articleService.fetchArticleImage(imageUrlString: url) { (image) in
                        guard let image = image else {
                            self.articleViewModels.append(NewsArticleViewModel(image: nil, title: article.title ?? "", url: articleUrl))
                            dispatchGroup.leave()
                            return
                        }
                        self.articleViewModels.append(NewsArticleViewModel(image: image, title: article.title ?? "", url: articleUrl))
                        dispatchGroup.leave()
                    }
                } else {
                    self.articleViewModels.append(NewsArticleViewModel(image: nil, title: article.title ?? "", url: articleUrl))
                    dispatchGroup.leave()
                }
            }
            
            dispatchGroup.notify(queue: .main) {
                self.tableView.reloadData()
            }
        }
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articleViewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "newsArticleCell") as? NewsArticleCell {
            cell.configure(with: articleViewModels[indexPath.row])
            cell.layoutIfNeeded()
            return cell
        }
        return UITableViewCell()
    }
}

extension ViewController: UITableViewDelegate {
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UIScreen.main.bounds.width / 2
//    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let safariVC = SFSafariViewController(url: articleViewModels[indexPath.row].url)
        present(safariVC, animated: true, completion: nil)
    }
}

extension ViewController: SFSafariViewControllerDelegate {
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        dismiss(animated: true, completion: nil)
    }
}
