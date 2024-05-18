//
//  DescVC.swift
//  MovieApp
//
//  Created by Anas on 18/05/24.
//

import UIKit

class DescVC: UIViewController {
    
    var original_title = ""
    var overview = ""
    var poster_path = ""
    var backdropImage = ""
    var release_date = ""
    var vote_average = 0.0
    var circularProgressView: CircularProgressView?

    @IBOutlet weak var backIV: UIImageView!
    @IBOutlet weak var posterImageV: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var shortLbl: UILabel!
    @IBOutlet weak var progressView: UIView!
    @IBOutlet weak var overviewLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCircularProgressView()
        
        let imageUrl = "https://image.tmdb.org/t/p/w220_and_h330_face\(poster_path)"
        if let url = URL(string: imageUrl) {
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let data = data {
                    DispatchQueue.main.async {
                        self.posterImageV.image = UIImage(data: data)
                    }
                }
            }.resume()
        }
        let backURL = "https://image.tmdb.org/t/p/w220_and_h330_face\(backdropImage)"

        if let url = URL(string: backURL) {
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let data = data {
                    DispatchQueue.main.async {
                        self.backIV.image = UIImage(data: data)
                    }
                }
            }.resume()
        }
        
        titleLbl.text = original_title
        overviewLbl.text = overview
        shortLbl.text = release_date
        let perc = vote_average/10.0
        circularProgressView?.setProgress(to: Float(perc), withAnimation: true)
        // Do any additional setup after loading the view.
    }
    
    private func setupCircularProgressView() {
        circularProgressView = CircularProgressView(frame: CGRect(x: 0, y: 0, width: progressView.bounds.width, height: progressView.bounds.height))
        circularProgressView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        circularProgressView?.trackColor = UIColor.lightGray
        circularProgressView?.progressColor = UIColor.green
        if let circularProgressView = circularProgressView {
            progressView.addSubview(circularProgressView)
        }
    }
    
    @IBAction func popBtn(_ sender: UIButton) {
        DispatchQueue.main.async {
            self.navigationController?.popViewController(animated: true)
        }
    }

}
