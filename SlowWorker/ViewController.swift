//  ViewController.swift
//  SlowWorker
//
//  Created by Daniel Catlett on 3/4/18.
//  Copyright © 2018 Daniel Catlett. All rights reserved.

import UIKit

class ViewController: UIViewController
{
    @IBOutlet var startButton: UIButton!
    @IBOutlet var resultsTextView: UITextView!
    @IBOutlet var spinner : UIActivityIndicatorView!
    
    func fetchSomethingFromServer() -> String
    {
        Thread.sleep(forTimeInterval: 1)
        return "Hi there"
    }
    
    func processData(_ data: String) -> String
    {
        Thread.sleep(forTimeInterval: 2)
        return data.uppercased()
    }
    
    func calculateFirstResult(_ data: String) -> String
    {
        Thread.sleep(forTimeInterval: 3)
        return "Number of chars: \(data.count)"
    }
    
    func calculateSecondResult(_ data: String) -> String
    {
        Thread.sleep(forTimeInterval: 4)
        return data.replacingOccurrences(of: "E", with: "e")
    }
    
    @IBAction func doWork(_ sender: AnyObject)
    {
        let startTime = Date()
        self.resultsTextView.text = ""
        
        startButton.isEnabled = false
        spinner.startAnimating()
        
        let queue = DispatchQueue.global(qos: .default)
        queue.async
        {
            let fetchedData = self.fetchSomethingFromServer()
            let processedData = self.processData(fetchedData)
            var firstResult: String!
            var secondResult: String!
            
            let group = DispatchGroup()
            queue.async(group: group)
            {
                firstResult = self.calculateFirstResult(processedData)
            }
            queue.async(group: group)
            {
                secondResult = self.calculateSecondResult(processedData)
            }
            
            group.notify(queue: queue)
            {
                let resultsSummary = "First: [\(firstResult!)]\nSecond: [\(secondResult!)]"
            
                DispatchQueue.main.async
                {
                    self.resultsTextView.text = resultsSummary
                    self.startButton.isEnabled = true
                    self.spinner.stopAnimating()
                }
                let endTime = Date()
                print("Completed in \(endTime.timeIntervalSince(startTime as Date)) seconds")
            }
        }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
}
