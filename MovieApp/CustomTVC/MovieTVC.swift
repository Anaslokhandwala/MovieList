import UIKit

class MovieTVC: UITableViewCell {

    @IBOutlet weak var releaseLbl: UILabel!
    @IBOutlet weak var movieLbl: UILabel!
    @IBOutlet weak var progressView: UIView!
    @IBOutlet weak var imageMovie: UIImageView!
    
    var circularProgressView: CircularProgressView?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupCircularProgressView()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        // Reset the progress view for reuse
        circularProgressView?.setProgress(to: 0, withAnimation: false)
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

    func configure(with movie: [String: Any]) {
        if let originalTitle = movie["original_title"] as? String {
            movieLbl.text = originalTitle
        } else {
            movieLbl.text = "Unknown Title"
        }

        if let releaseDate = movie["release_date"] as? String {
            releaseLbl.text = releaseDate
        } else {
            releaseLbl.text = "Unknown Date"
        }

        if let popularity = movie["popularity"] as? Double, let voteAvg = movie["vote_average"] as? Double {
            let perc = voteAvg/10.0
            circularProgressView?.setProgress(to: Float(perc), withAnimation: true)
        }
        
        if let posterPath = movie["poster_path"] as? String {
        let imageUrl = "https://image.tmdb.org/t/p/w220_and_h330_face\(posterPath)"

        if let url = URL(string: imageUrl) {
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let data = data {
                    DispatchQueue.main.async {
                        self.imageMovie.image = UIImage(data: data)
                    }
                }
            }.resume()
        }
        } else {
            imageMovie.image = UIImage(named: "placeholder.png")
        }
    }
}
