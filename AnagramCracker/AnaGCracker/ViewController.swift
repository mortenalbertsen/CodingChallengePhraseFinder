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
    
    var anagramBuilder : AnagramMapBuilder! = nil
    
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
        self.anagramBuilder = AnagramMapBuilder(wordsInLanguage: wordsFromLanguage, givenInputPhrase: self.textField.stringValue)
        Swift.print("Done initializing")
        
        let results = self.anagramBuilder.anagrams(forPhrase: self.textField.stringValue)
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

extension String {
    
    func runAsCommand() -> String {
        let pipe = Pipe()
        let task = Process()
        task.launchPath = "/bin/sh"
        task.arguments = ["-c", String(format:"%@", self)]
        task.standardOutput = pipe
        let file = pipe.fileHandleForReading
        task.launch()
        if let result = NSString(data: file.readDataToEndOfFile(), encoding: String.Encoding.utf8.rawValue) {
            return result as String
        }
        else {
            return "--- Error running command - Unable to initialize string from file data ---"
        }
    }
}

