//
//  ViewController.swift
//  SoFi-imgur
//
//  Created by James Garcia-Bengochea on 9/12/19.
//  Copyright © 2019 James Garcia-Bengochea. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD
import SwiftyJSON
import SDWebImage

class ViewController: UIViewController,  UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {
    
    //init variables for search and results
    let headers: HTTPHeaders = ["Authorization": "Client-ID 126701cd8332f32"]
    var pageNumber: Int = 1
    var searchParameters: String = ""
    //made a custom class to store the results from api request
    var resultArray: [Result] = []
    
    
    //outlets for searchbar and table
    @IBOutlet weak var imgurSearchBar: UISearchBar!
    @IBOutlet weak var imgurSearchResultsTable: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //TableView delegate & datasource
        imgurSearchBar.delegate = self
        imgurSearchResultsTable.delegate = self
        imgurSearchResultsTable.dataSource = self
        
        //Register custom XIB
        imgurSearchResultsTable.register(UINib(nibName: "CustomImgurCell", bundle: nil), forCellReuseIdentifier: "customImgurCell")
        configureTableView()
    }


}
//Extending for tableview
extension ViewController  {
    //MARK: - TableView DataSource Methods
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customImgurCell", for: indexPath) as! CustomImgurCell
        
        
       
        cell.imageTitle.text = resultArray[indexPath.row].title
        cell.imgurImage.sd_setImage(with: URL(string: resultArray[indexPath.row].imageURL), completed: { (image, error, cacheType, imageURL) in
            
        })
        
        if indexPath.row == self.resultArray.count - 1 {
            self.loadMore()
        }
        
        
        return cell
        
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultArray.count
    }
    
    //Configure the tableview to display cells properly
    func configureTableView() {
        imgurSearchResultsTable.rowHeight = UITableView.automaticDimension
        imgurSearchResultsTable.estimatedRowHeight = 120.0
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        imgurSearchResultsTable.deselectRow(at: indexPath, animated: true)
        //opens image in new view
        performSegue(withIdentifier: "goToImage", sender: indexPath)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ImageViewController
        //sends title and image to new view
        if let indexPath: IndexPath = sender as? IndexPath {
            destinationVC.imageURL = resultArray[indexPath.row].imageURL
            destinationVC.title = resultArray[indexPath.row].title
        }
    }
    
    
}

//extending for search bar functionality
extension ViewController {
    //MARK: - SearchBar functions
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        resultArray = []
        self.view.endEditing(true)
        //when new search is done should always load first page
        pageNumber = 1
        //capture search text - if no text, send empty string
        searchParameters = imgurSearchBar.text ?? ""
        if searchParameters == "" {
            //if empty string, don't continue with search
            return
        }
        Alamofire.request("https://api.imgur.com/3/gallery/search/time/\(pageNumber)?q=\(searchParameters)", method: .get, headers: headers).responseJSON {
            response in
            //request success, parse through JSON
            if response.result.isSuccess {
                //print("Success, got the imgur call")
                let imgurJSON: JSON = JSON(response.result.value!)
                //set length to iterate
                for i in 0..<imgurJSON["data"].count {
                    //if format is mp4, ignore and move on... loading videos as thumbnail is not something I wanted to do for latency and memory
                    if ((imgurJSON["data"][i]["images"][0]["link"].string != nil) && ((imgurJSON["data"][i]["images"][0]["link"].string?.hasSuffix(".mp4"))!)){
                        
                    } else if ((imgurJSON["data"][i]["images"][0]["link"].string) != nil){
                        //if the result is an album, grab the first image from the album
                        self.resultArray.append(Result(title: imgurJSON["data"][i]["title"].string!, imageURL: imgurJSON["data"][i]["images"][0]["link"].string!))
                        //if the result is a single mp4 ignore this as well
                    } else if (imgurJSON["data"][i]["link"].string?.hasSuffix(".mp4"))! {
                    } else {
                        //if the result is a single image and not mp4, grab it
                        self.resultArray.append(Result(title: imgurJSON["data"][i]["title"].string!, imageURL: imgurJSON["data"][i]["link"].string!))
                    }
                }
            } else {
                print("Error \(response.result.error!)")
            }
            self.imgurSearchResultsTable.reloadData()
            
        }
    }
   // adding scroll reload functionality
    func loadMore() {
        //since any new search resets page to 1, this would go to the next page
        pageNumber += 1
        Alamofire.request("https://api.imgur.com/3/gallery/search/time/\(pageNumber)?q=\(searchParameters)", method: .get, headers: headers).responseJSON {
            response in
            //same construct as above, ignoring mp4 and grabbing everything else
            if response.result.isSuccess {
                print("Success, got additional results")
                let imgurJSON: JSON = JSON(response.result.value!)
                for i in 0..<imgurJSON["data"].count {
                    if ((imgurJSON["data"][i]["images"][0]["link"].string) != nil){
                        
                        self.resultArray.append(Result(title: imgurJSON["data"][i]["title"].string!, imageURL: imgurJSON["data"][i]["images"][0]["link"].string!))
                        
                    } else {
                        
                        self.resultArray.append(Result(title: imgurJSON["data"][i]["title"].string!, imageURL: imgurJSON["data"][i]["link"].string!))
                       
                    }
                }
            } else {
                print("Error \(response.result.error!)")
            }
            self.imgurSearchResultsTable.reloadData()
            
            
        }
        
    }
    
}


