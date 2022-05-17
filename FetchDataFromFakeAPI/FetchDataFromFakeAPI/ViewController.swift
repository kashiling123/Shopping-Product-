//
//  ViewController.swift
//  FetchDataFromFakeAPI
//
//  
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: Outlets
    @IBOutlet weak var productCollectionView: UICollectionView!
    @IBOutlet weak var mySwitch: UISwitch!
    
    // MARK: Variables
    var productModelClassArray: [ProductAPIModelClass] = []
    var imageURL: URL?

    // MARK: VC LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        productCollectionView.dataSource = self
        productCollectionView.delegate = self
        let nibFileName = UINib(nibName: "ProductDetailCell", bundle: nil)
        productCollectionView.register(nibFileName, forCellWithReuseIdentifier: "ProductCell")
    }
    
    // MARK: Switch ON Off Method
    @IBAction func switchOnOff(_ sender: UISwitch){
        if sender.isOn {
            fetchDataFromAPI()
        } else {
            print("no internet connection")
        }
    }
}


// MARK: Fetch data From API Function
extension ViewController {
    
    func fetchDataFromAPI() {
        let urlString = "https://fakestoreapi.com/products"
        guard let url = URL(string: urlString) else {
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let session = URLSession(configuration: .default)
        let dataTask = session.dataTask(with: request) { data, response, error in
            if let error = error {
            }
            
            guard let response = response as? HTTPURLResponse,
                  response.statusCode == 200,
                  let data = data else {
                      return
                  }
            print("\(response)")
            print("\(data)")
            do {
                guard let jsonObject = try JSONSerialization.jsonObject(with: data) as? [[String: Any]]  else {
                    return
                }
                for dictionary in jsonObject {
                    let postID = dictionary["id"] as? Int
                    let postTitle = dictionary["title"] as? String
                    let postPrice = dictionary["price"] as? Double
                    let postDescription = dictionary["description"] as? String
                    let postCategory = dictionary["category"] as? String
                    let postImage = dictionary["image"] as? String
                    let postRating = dictionary["rating"] as? [String: Any]
                    let postRate = postRating?["rate"] as? Double
                    let postCount = postRating?["count"] as? Int
                    
                    let productData = ProductAPIModelClass(postID: postID ?? 0, postTitle: postTitle ?? "", postPrice: postPrice ?? 0, postDescription: postDescription ?? "", postCAtegory: postCategory ?? "", postImage: postImage ?? "", postRate: postRate ?? 0, postCount: postCount ?? 0)
                    
                    self.productModelClassArray.append(productData)
                    DispatchQueue.main.async {
                        self.productCollectionView.reloadData()
                    }
                }
            } catch {
                print("got error while coverting data to json: \(error.localizedDescription)")
            }
        }
        dataTask.resume()
    }
}

// MARK: UICollectionViewDataSource Protocol
extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        productModelClassArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = self.productCollectionView.dequeueReusableCell(withReuseIdentifier: "ProductCell", for: indexPath) as? ProductDetailCell else {
            return UICollectionViewCell()
        }
        cell.titleLabel.text = productModelClassArray[indexPath.row].postTitle
        cell.priceLabel.text = String(productModelClassArray[indexPath.row].postPrice)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let secVC = self.storyboard?.instantiateViewController(withIdentifier: "SecondViewController") as? SecondViewController else {
            return
        }
        secVC.titleContainer =  self.productModelClassArray[indexPath.row].postTitle
        secVC.priceContainer = String(self.productModelClassArray[indexPath.row].postPrice)
        secVC.rateContainer = String(productModelClassArray[indexPath.row].postRate)
        secVC.countContainer = String(productModelClassArray[indexPath.row].postCount)
        secVC.descriptionContainer = productModelClassArray[indexPath.row].postDescription
        secVC.ImageContainer = productModelClassArray[indexPath.row].postImage
        self.navigationController?.pushViewController(secVC, animated: true)
    }
}

// MARK: UICollectionViewDelegateFlowLayout Protocol
extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: productCollectionView.frame.size.width, height: productCollectionView.frame.size.height/4)
    }
}





