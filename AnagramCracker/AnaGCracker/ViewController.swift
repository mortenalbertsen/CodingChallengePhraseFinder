//
//  ViewController.swift
//  AnaGCracker
//
//  Created by Morten on 05/02/2019.
//  Copyright © 2019 Morten Albertsen. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    @IBOutlet weak var textField: NSTextField!
    
    var anagramBuilder : AnagramHelper! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    @IBAction func searchForAnagrams(_ sender: Any) {
        guard !self.textField.stringValue.isEmpty else {
            return
        }
        guard let fileURL = Bundle.main.url(forResource: "wordlist", withExtension: "txt") else {
            fatalError("Failed to lookup URL for wordlist")
        }
        let wordsFromLanguage = TextLoaderImplementation.loadWords(fromFile: fileURL)
        self.anagramBuilder = AnagramHelper(wordsInLanguage: wordsFromLanguage, givenInputPhrase: self.textField.stringValue)
        Swift.print("Done initializing")
        
        let results = self.anagramBuilder.anagrams()
        Swift.print("Found \(results.count) results")
        let resultsAsSet = Set<String>(results)
        Swift.print("Unique combinations: \(resultsAsSet.count)")
        for result in results {
            Swift.print("Result: \(result)")
            let commandToRun = "md5 -s \"\(result)\""
            let md5Value = commandToRun.runAsCommand()
            Swift.print("MD5 of \"\(result)\" is: \(md5Value)")
        }
    }
}
