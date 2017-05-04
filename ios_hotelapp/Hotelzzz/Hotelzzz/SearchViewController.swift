//
//  SearchViewController.swift
//  Hotelzzz
//
//  Created by Steve Johnson on 3/22/17.
//  Copyright © 2017 Hipmunk, Inc. All rights reserved.
//

import Foundation
import WebKit
import UIKit


private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "YYYY-mm-dd"
    return formatter
}()

private func jsonStringify(_ obj: [AnyHashable: Any]) -> String {
    let data = try! JSONSerialization.data(withJSONObject: obj, options: [])
    return String(data: data, encoding: .utf8)!
}


class SearchViewController: UIViewController, WKScriptMessageHandler, WKNavigationDelegate, SearchSortViewControllerDelegate {

    struct Search {
        let location: String
        let dateStart: Date
        let dateEnd: Date

        var asJSONString: String {
            return jsonStringify([
                "location": location,
                "dateStart": dateFormatter.string(from: dateStart),
                "dateEnd": dateFormatter.string(from: dateEnd)
            ])
        }
    }

    private var _searchToRun: Search?
    private var _selectedHotel: [String: Any]?

    lazy var webView: WKWebView = {
        let webView = WKWebView(frame: CGRect.zero, configuration: {
            let config = WKWebViewConfiguration()
            config.userContentController = {
                let userContentController = WKUserContentController()

                // DECLARE YOUR MESSAGE HANDLERS HERE
                userContentController.add(self, name: "API_READY")
                userContentController.add(self, name: "HOTEL_API_RESULTS_READY")
                userContentController.add(self, name: "HOTEL_API_HOTEL_SELECTED")

                return userContentController
            }()
            return config
        }())
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.navigationDelegate = self

        self.view.addSubview(webView)
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[webView]|", options: [], metrics: nil, views: ["webView": webView]))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[webView]|", options: [], metrics: nil, views: ["webView": webView]))
        return webView
    }()

    func search(location: String, dateStart: Date, dateEnd: Date) {
        _searchToRun = Search(location: location, dateStart: dateStart, dateEnd: dateEnd)
        self.webView.load(URLRequest(url: URL(string: "http://hipmunk.github.io/hipproblems/ios_hotelapp/")!))
    }

    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        let alertController = UIAlertController(title: NSLocalizedString("Could not load page", comment: ""), message: NSLocalizedString("Looks like the server isn't running.", comment: ""), preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: NSLocalizedString("Bummer", comment: ""), style: .default, handler: nil))
        self.navigationController?.present(alertController, animated: true, completion: nil)
    }

    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        switch message.name {
        case "API_READY":
            guard let searchToRun = _searchToRun else { fatalError("Tried to load the page without having a search to run") }
            self.webView.evaluateJavaScript(
                "window.JSAPI.runHotelSearch(\(searchToRun.asJSONString))",
                completionHandler: nil)
            
        case "HOTEL_API_RESULTS_READY":
            if let searchResults = message.body as? [String: Any] {
                let results = searchResults["results"] as! NSArray
                self.title = "\(results.count) Hotels"
            } else {
                fatalError("Invalid Hotel API search results")
            }
            
        case "HOTEL_API_HOTEL_SELECTED":
            if let selectedHotel = message.body as? [String: Any] {
                _selectedHotel = selectedHotel
                self.performSegue(withIdentifier: "hotel_details", sender: nil)
            } else {
                fatalError("Invalid API response when selecting hotel")
            }
        default: break
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "hotel_details" {
            let hotelViewController = segue.destination as! HotelViewController
            if let result = _selectedHotel?["result"] as? [String: Any] {
                let price = result["price"] as! NSNumber
                let priceString = "$\(price.stringValue)"
                hotelViewController.hotelPrice = priceString
                if let hotel = result["hotel"] as? [String: Any] {
                    hotelViewController.hotelName = hotel["name"] as! String
                    hotelViewController.hotelAddress = hotel["address"] as! String
                    hotelViewController.hotelImageURL = hotel["imageURL"] as! String
                }
                return
            }
            fatalError("Invalid JSON response body or format")
        } else if segue.identifier == "select_sort" {
            let sortNavController = segue.destination as! UINavigationController
            let sortViewController = sortNavController.visibleViewController as! SearchSortViewController
            sortViewController.delegate = self
        }
    }
 
    func searchSort(viewController: SearchSortViewController, didSelectSortBy sortByType: SortByType) {
        self.webView.evaluateJavaScript("window.JSAPI.setHotelSort(\"\(sortByType.name)\")", completionHandler: nil)
    }
}
