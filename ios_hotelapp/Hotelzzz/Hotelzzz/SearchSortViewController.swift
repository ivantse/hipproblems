//
//  SearchSortViewController.swift
//  Hotelzzz
//
//  Created by Ivan Tse on 5/2/17.
//  Copyright © 2017 Hipmunk, Inc. All rights reserved.
//

import UIKit

enum SortByType: Int {
    case name = 0
    case priceAscend
    case priceDescend
    case count
    
    var name: String {
        get { return String(describing: self) }
    }
    var description: String {
        get {
            switch self {
            case .priceAscend:
                return "Price (Ascending)"
            case .priceDescend:
                return "Price (Descending)"
            default:
                return "Sort by Name"
            }
        }
    }
}

protocol SearchSortViewControllerDelegate: class {
    func searchSort(viewController: SearchSortViewController, didSelectSortBy sortByType: SortByType)
}

class SearchSortViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    weak var delegate: SearchSortViewControllerDelegate?
    @IBOutlet var pickerView: UIPickerView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        pickerView.dataSource = self
        pickerView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func doneAction(sender: Any?) {
        let selectedIndex = pickerView.selectedRow(inComponent: 0)
        let sortByType = SortByType.init(rawValue: selectedIndex)!
        self.delegate?.searchSort(viewController: self, didSelectSortBy: sortByType)
        self.dismiss(animated: true, completion: nil)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return SortByType.count.rawValue
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let sortByType = SortByType.init(rawValue: row)!
        return sortByType.description
    }
}
