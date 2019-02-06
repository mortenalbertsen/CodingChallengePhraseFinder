# Solution for job-interview coding challenge

The challenge is as follows: 

Given

1. a sentence, and
2. a list of words that are allowed in the language of the sentence
3. a MD5-hash

find an anagram of 1. (using the words in 2.) such that the MD5-hash of the anagram matches 3.



## Short description of solution

- Out of preference I chose to build this as an Xcode-project, initially targeting an iOS-app, later targeting a traditional Mac-app. 
- The cracking of the anagram is "search-based".
- The relevant logic for the "cracking" of the anagrams are isolated in class `AnagramHelper.swift`.
  An instance of `AnagramHelper` is instantiated for every new inputphrase. 
- Using the input-phrase, an initial filtering ("preburn") is made of all the words in the language, such that only (possibly) relevant words remains as candidates. This filtering checks a word for any character that is not present in the input-phrase. 
- The `md5`s of the generated anagrams are simply output to Xcode terminal, and a simple (manuel) filter there will reveal the desired md5 - if found ;) 
- The solutions exploits the following:
  - Anagrams have identical 'character-sortings'; that is "dog" and "god" share the same charactersorting "dgo". If it at some point is determined that "dog" won't be a fit, we can effectively also prune "god" now. 
  - The length of words. We know the length of the input sentence. *Assuming* that the correct output sentence has as many words (*n*) as the input sentence, we can - when we have picked *n-1* candidates already - determine the needed length of the last word. Using that we can effectively prune the search-tree to a great extent. 



## Limitations of current solution

### Performance

- Performance is currently "OK", but could probably be vastly improved - although I don't know specifically how. As a starter, I would simply profile the application and see where processing-time is actually spent. 

### Assumptions

- The solution searches only for matching output strings having the same word count as the input phrase. 

