//
//  PostsViewController.swift
//  Journey
//
//  Created by Tejaswini on 2/12/21.
//  Copyright © 2021 Tejaswini. All rights reserved.
//

import UIKit


class PostsViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate {
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var postsView: UITableView!
    var posts = [Posts]()
    var filteredData = [Posts]()
    var isFiltering = false
    override func viewDidLoad() {
        
        let url = "https://jsonplaceholder.typicode.com/posts"
        fetchDataFromJson(seturl: url)
        super.viewDidLoad()
        postsView.delegate=self
        postsView.dataSource=self
        searchBar.delegate=self
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering{
            return filteredData.count
        }
        return self.posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postcell") as! PostTableViewCell
        if isFiltering{
            cell.userIdLbl.text = String(filteredData[indexPath.row].userId)
            cell.titleLbl.text=filteredData[indexPath.row].title
            cell.bodyLbl.text=filteredData[indexPath.row].body
        }else{
            cell.userIdLbl.text = String(posts[indexPath.row].userId)
            cell.titleLbl.text=posts[indexPath.row].title
            cell.bodyLbl.text=posts[indexPath.row].body
        }
        
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedrow = self.posts[indexPath.row]
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CommentsViewController") as! CommentsViewController
        vc.PostId = selectedrow.id
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func fetchDataFromJson(seturl: String){
        guard let url = URL(string: seturl) else {return}
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let dataResponse = data,
                error == nil else {
                    print(error?.localizedDescription ?? "Response Error")
                    return }
            do{
                let jsonResponse = try JSONSerialization.jsonObject(with:
                    dataResponse, options: [])
                guard let jsonArray = jsonResponse as? [[String: Any]] else {
                    return
                }
                for dic in jsonArray{
                    self.posts.append(Posts(dic))
                }
                DispatchQueue.main.async {
                    self.postsView.reloadData()
                }
            } catch let parsingError {
                print("Error", parsingError)
            }
        }
        task.resume()
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else {
            filteredData = self.posts
            self.postsView.reloadData()
            return
            
        }
        filteredData = self.posts.filter({ (Posts) -> Bool in
            Posts.title.lowercased().contains(searchText.lowercased())
        })
        isFiltering = true
        self.postsView.reloadData()
    }
    
    
    
    func updateSearchResults(for searchController: UISearchController) {
        
        searchBar.text = ""
        searchBar.resignFirstResponder()
        isFiltering = false
        self.postsView.reloadData()
        
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchBar.endEditing(true)
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
}


