//
//  CommentsViewController.swift
//  Journey
//
//  Created by Tejaswini on 3/12/21.
//  Copyright © 2021 Tejaswini. All rights reserved.
//

import UIKit

class CommentsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate {
    @IBOutlet weak var commentsTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    var PostId = Int()
    var commetsData = [Comments]()
    var filteredData = [Comments]()
    var isFiltering = false
    override func viewDidLoad() {
        let url = "https://jsonplaceholder.typicode.com/comments"
        fetchDataFromJson(seturl: url)
        super.viewDidLoad()
        self.commentsTableView.dataSource = self
        self.commentsTableView.delegate = self
        self.searchBar.delegate = self
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(isFiltering){
            return filteredData.count
        }
        return commetsData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "commentsCell") as! CommentsTableViewCell
     
        if isFiltering{
            cell.nameLbl.text = self.filteredData[indexPath.row].name
            cell.emailLbl.text = self.filteredData[indexPath.row].email
            cell.bodyLbl.text = self.filteredData[indexPath.row].body
            cell.postIdLbl.text = String(self.filteredData[indexPath.row].postId)
        }else{
            cell.nameLbl.text = self.commetsData[indexPath.row].name
            cell.emailLbl.text = self.commetsData[indexPath.row].email
            cell.bodyLbl.text = self.commetsData[indexPath.row].body
            cell.postIdLbl.text = String(self.commetsData[indexPath.row].postId)
        }

        
        return cell
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

                    if  (Comments(dic).postId == self.PostId){
                        self.commetsData.append(Comments(dic))
                    }
                    
                }
                DispatchQueue.main.async {
                   self.commentsTableView.reloadData()
                }
            } catch let parsingError {
                print("Error", parsingError)
            }
        }
        task.resume()
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else {
            filteredData = self.commetsData
            self.commentsTableView.reloadData()
            return
        
        }
        filteredData = self.commetsData.filter({ (Comments) -> Bool in
            Comments.name.lowercased().contains(searchText.lowercased())
        })
        isFiltering = true
        self.commentsTableView.reloadData()
    }
    
    
    
    func updateSearchResults(for searchController: UISearchController) {
        
        searchBar.text = ""
        searchBar.resignFirstResponder()
        isFiltering = false
        self.commentsTableView.reloadData()
        
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchBar.endEditing(true)
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }

}
