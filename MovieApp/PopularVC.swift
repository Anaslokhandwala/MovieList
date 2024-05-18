//
//  PopularVC.swift
//  MovieApp
//
//  Created by Anas on 18/05/24.
//

import UIKit
//import NetworkCustomSDK
import NetworkCustom

class PopularVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var results:[[String:Any]] = [[:]]
    @IBOutlet weak var tblView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tblView.register(UINib.init(nibName: "MovieTVC", bundle: nil), forCellReuseIdentifier: "MovieTVC")
        
        
        
        let customURL = URL(string: popularListApi)!
        let customHeaders = ["Authorization": "Bearer token", "Content-Type": "application/json"]
        let customQueryItems = [
            "api_key": ApiKey,
            "page": "1"
        ]
        
        let customEndpoint = NetworkEndpoint.custom(url: customURL, method: "GET", headers: customHeaders, queryItems: customQueryItems, body: nil)
        let networkCustomCalling = NetworkCustomCalling()
        networkCustomCalling.request(endpoint: customEndpoint) { result in
            switch result {
            case .success(let data):
                let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                self.results = json?["results"] as! [[String : Any]]
                
                DispatchQueue.main.async {
                    self.tblView.reloadData()
                }
                
            case .failure(let error):
                print("Custom API request failed: \(error)")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieTVC") as! MovieTVC
        
        if let movie = results[indexPath.row] as? [String: Any] {
            cell.configure(with: movie)
        } else {
            cell.movieLbl.text = "Invalid Data"
            cell.releaseLbl.text = "Invalid Data"
            cell.circularProgressView?.setProgress(to: 0, withAnimation: false)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 700
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let movie = results[indexPath.row] as? [String: Any] {
            DispatchQueue.main.async {
                let vc: DescVC = self.storyboard?.instantiateViewController(withIdentifier: "DescVC") as! DescVC
                vc.backdropImage = movie["backdrop_path"] as? String ?? ""
                vc.original_title = movie["original_title"]  as? String ?? ""
                vc.overview = movie["overview"]  as? String ?? ""
                vc.poster_path = movie["poster_path"]  as? String ?? ""
                vc.release_date = movie["release_date"]  as? String ?? ""
                vc.vote_average = movie["vote_average"]  as? Double ?? 0.0
                
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
        }
    }
}
