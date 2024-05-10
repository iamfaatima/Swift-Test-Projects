//
//  ViewController.swift
//  AlamofireJSON
//
//  Created by Dev on 04/12/2023.
//

import UIKit
import Alamofire


class ViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
    }

    func fetchData() {
            // Define the API URL
            let apiUrl = "https://jsonplaceholder.typicode.com/posts"

            // Use Alamofire to make the request
            AF.request(apiUrl)
                .validate(statusCode: 200..<300)  // Validate successful status codes
                .responseJSON { response in
                    switch response.result {
                    case .success(let data):
                        // Handle the successful response and update the UI
                        if let jsonArray = data as? [[String: Any]] {
                            // Assuming your data is an array of dictionaries
                            let prettyPrintedJson = try? JSONSerialization.data(withJSONObject: jsonArray, options: .prettyPrinted)
                            if let prettyPrintedString = String(data: prettyPrintedJson ?? Data(), encoding: .utf8) {
                                print(prettyPrintedString)
                                DispatchQueue.main.async {
                                    self.textView.text = prettyPrintedString
                                }
                            }
                        }


                    case .failure(let error):
                        // Handle the error
                        print("Error: \(error)")
                        if let statusCode = response.response?.statusCode {
                            print("Status code: \(statusCode)")
                        }
                    }
                }
        }
}

