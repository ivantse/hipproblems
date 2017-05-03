//
//  SearchFilterViewController.swift
//  Hotelzzz
//
//  Created by Ivan Tse on 5/3/17.
//  Copyright © 2017 Hipmunk, Inc. All rights reserved.
//

import UIKit

struct SearchFilter {
    let priceMin: Int?
    let priceMax: Int?
    
    var asJson: [String: Any] {
        return [
            "priceMin": priceMin as Any,
            "priceMax": priceMax as Any,
        ]
    }
}

protocol SearchFilterViewControllerDelegate: class {
    func searchFilter(viewController: SearchFilterViewController, didSetFilter searchFilter: SearchFilter)
}

class SearchFilterViewController: UIViewController {
    weak var delegate: SearchFilterViewControllerDelegate?
    @IBOutlet var minPriceTextField: UITextField!
    @IBOutlet var maxPriceTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func doneAction(sender: Any?) {
        let priceMin = minPriceTextField.text != nil ? Int(minPriceTextField.text!) : nil
        let priceMax = maxPriceTextField.text != nil ? Int(maxPriceTextField.text!) : nil
        self.delegate?.searchFilter(viewController: self, didSetFilter: SearchFilter(priceMin: priceMin, priceMax: priceMax))
        self.dismiss(animated: true, completion: nil)
    }
}
