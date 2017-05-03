//
//  HotelViewController.swift
//  Hotelzzz
//
//  Created by Steve Johnson on 3/22/17.
//  Copyright © 2017 Hipmunk, Inc. All rights reserved.
//

import Foundation
import UIKit


class HotelViewController: UIViewController {
    var hotelName: String = ""
    var hotelPrice: String = ""
    var hotelAddress: String = ""
    var hotelImageURL: String = ""
    @IBOutlet var hotelNameLabel: UILabel!
    @IBOutlet var hotelPriceLabel: UILabel!
    @IBOutlet var hotelAddressLabel: UILabel!
    @IBOutlet var hotelImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hotelImageView.contentMode = .scaleAspectFit
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hotelNameLabel.text = hotelName
        hotelPriceLabel.text = hotelPrice
        hotelAddressLabel.text = hotelAddress
        
        let url = URL.init(string: hotelImageURL)!
        let imageDownloadTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data, error == nil else {
                fatalError("Could not download hotel image")
            }
            DispatchQueue.main.async {
                let image = UIImage(data: data)
                self.hotelImageView.image = image
            }
        }
        imageDownloadTask.resume()
    }
}
