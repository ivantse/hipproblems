//
//  SearchSortViewController.swift
//  Hotelzzz
//
//  Created by Ivan Tse on 5/2/17.
//  Copyright © 2017 Hipmunk, Inc. All rights reserved.
//

import UIKit

enum SortByType: String {
    case name
    case priceAscend
    case priceDescend
}

protocol SearchSortViewControllerDelegate: class {
    func searchSort(viewController: SearchSortViewController, didSelectSortBy sortByType: SortByType)
}

class SearchSortViewController: UIViewController {
    weak var delegate: SearchSortViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func sortByNameSelected(sender: Any?) {
        self.delegate?.searchSort(viewController: self, didSelectSortBy: .name)
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func sortByPriceAscendSelected(sender: Any?) {
        self.delegate?.searchSort(viewController: self, didSelectSortBy: .priceAscend)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func sortByPriceDescendSelected(sender: Any?) {
        self.delegate?.searchSort(viewController: self, didSelectSortBy: .priceDescend)
        self.dismiss(animated: true, completion: nil)
    }
}
