# Solution for job-interview coding challenge

The challenge is as follows: 

Given

1. a sentence, and
2. a list of words that are allowed in the language of the sentence
3. a MD5-hash

find an anagram of 1. (using the words in 2.) such that the MD5-hash of the anagram matches 3.



## Short description of solution

- Out of preference I chose to build this as an Xcode-project, initially targeting an iOS-app, later targeting a traditional Mac-app. 
- The relevant logic for the "cracking" of the anagrams are isolated in class `AnagramHelper.swift`.
  An instance of `AnagramHelper` is instantiated for every new inputphrase. 
- The `md5`s of the generated anagrams are simply output to Xcode terminal, and a simple filter there will reveal the desired md5 - if found ;) 