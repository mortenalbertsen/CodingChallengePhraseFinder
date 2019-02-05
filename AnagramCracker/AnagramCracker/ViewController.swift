
//
//  ViewController.swift
//  AnagramCracker
//
//  Created by Morten on 05/02/2019.
//  Copyright © 2019 Morten Albertsen. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var inputTextField: UITextField!
    
    var results = [String]()
    var anagramBuilder : AnagramMapBuilder! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        initializeApplication()
        
    }
    
    private func initializeApplication() {
        guard let fileURL = Bundle.main.url(forResource: "wordlist", withExtension: "txt") else {
            fatalError("Failed to lookup URL for wordlist")
        }
        
        var wordsAsStrings = Set<String>()
        for word in TextLoaderImplementation.loadWords(fromFile: fileURL) {
            wordsAsStrings.insert(String(word))
        }
        self.anagramBuilder = AnagramMapBuilder(wordsInLanguage: wordsAsStrings)
        Swift.print("Done initializing")
    }

    @IBAction func searchForAnagrams(_ sender: Any) {
        guard let searchTerm = self.inputTextField.text else {
            return
        }
        self.results.removeAll()
        for result in self.anagramBuilder.anagrams(forPhrase: searchTerm) {
            Swift.print("Result: \(result)")
            let commandToRun = "md5 \"\(result)\""
            let md5Value = commandToRun.runAsCommand()
            Swift.print("MD5 of \(result) is: \(md5Value)")"
        }
    }
}

extension ViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
        //return results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableCell = self.tableView.dequeueReusableCell(withIdentifier: "entryCell")!
        tableCell.textLabel?.text = "Testing"
        return tableCell
    }
}
