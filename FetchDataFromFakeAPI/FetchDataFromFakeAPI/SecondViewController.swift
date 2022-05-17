//
//  SecondViewController.swift
//  FetchDataFromFakeAPI
//
//
//

import UIKit

class SecondViewController: UIViewController {
    
    // MARK: Outlets
    @IBOutlet weak var titleLabelSV: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var priceLabelSV: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    // MARK: Variables
    var titleContainer: String?
    var priceContainer: String?
    var rateContainer: String?
    var countContainer: String?
    var descriptionContainer: String?
    var ImageContainer: String?
    
    // MARK: VC LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.titleLabelSV.text = self.titleContainer
        self.priceLabelSV.text = self.priceContainer
        self.rateLabel.text = self.rateContainer
        self.countLabel.text = self.countContainer
        self.descriptionLabel.text = self.descriptionContainer
        let imageURL = URL(string: ImageContainer!)!
        productImage.downloadImage(from: imageURL)
        
    }
}

// MARK: Image Download Func
extension UIImageView {
    func downloadImage(from url: URL){
        let session = URLSession(configuration: .default)
        let dataTask = session.dataTask(with: url) { data, response, error in
            let image = UIImage(data: data!)
            DispatchQueue.main.async {
                self.image = image
            }
        }
        dataTask.resume()
    }
}
