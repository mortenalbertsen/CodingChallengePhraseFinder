import Foundation

public class AnagramMapBuilder {
    
    var map = [String:Set<String>]()
    var lengthMap = [Int:Set<String>]()
    var characterFrequencyMapForInputPhrase = [Character:Int]()
    
    public init(wordsInLanguage: Set<String>, givenInputPhrase: String) {
        let preburnedWords = self.preBurn(words: wordsInLanguage, usingInputPhrase: givenInputPhrase)
        self.map = self.produceMap(fromWords: preburnedWords)
        self.lengthMap = self.produceLengthMap(forWords: preburnedWords)
        self.characterFrequencyMapForInputPhrase = produceCharacterFrequencyMap(forString: givenInputPhrase)
    }
    
    private func preBurn(words: Set<String>, usingInputPhrase inputPhrase: String) -> Set<String> {
        let charactersInInputPhrase = inputPhrase.split(separator: " ").reduce(Set<Character>()) { acc, element in
            let charactersInElement = Set<Character>(element.sorted())
            let newAcc = acc.union(charactersInElement)
            return newAcc
        }
        
        // Filter out all words that won't make it anyways
        let preBurnedWords = words.filter { element in
            return !shouldBeDiscarded(candidate: element, charactersInPhrase: charactersInInputPhrase)
        }
        return preBurnedWords
    }
    
    /**
     Produces a mapping [String:[Substring]], where the key is the sorted word
     and the value is an array of all strings that has the same sorting.
     Example: "god" and "dog" are made out of the same characters: 'd', 'g' and 'o'
     The character sorting of both is: 'dgo'. Assume that both "god" and "dog" were inserted.
     The mapping would then return ["dog", "god"] for key "dgo"
    */
    public func produceMap(fromWords words: Set<String>) -> [String:Set<String>] {
        var map = [String:Set<String>]()
        
        for word in words {
            let componentsInWordSorted = String(word.sorted())
            
            if map[componentsInWordSorted] == nil {
                map[componentsInWordSorted] = Set<String>()
            }
            map[componentsInWordSorted]!.insert(word)
        }
        
        return map
    }
    
    public func produceLengthMap(forWords inputWwords: Set<String>) -> [Int:Set<String>] {
        var lengthMap = [Int:Set<String>]()
        for wordLength in 1...100 {
            lengthMap[wordLength] = Set<String>()
        }
        
        for word in inputWwords {
            let wordLength = word.count
            lengthMap[wordLength]!.insert(word)
        }
        
        return lengthMap
    }

    private func produceCharacterFrequencyMap(forString input: String) -> [Character:Int] {
        var frequencyMap = [Character:Int]()
        for character in input where character != " " {
            if frequencyMap[character] == nil {
                frequencyMap[character] = 0
            }
            let value = frequencyMap[character]!
            frequencyMap[character] = value + 1
        }
        return frequencyMap
    }
    
    public func anagrams(forPhrase inputPhrase: String) -> Set<String> {
        return findCandidates(forPhrase: inputPhrase, usingInterim: [String](), maximumDepth: 3, currentDepth: 0)
    }
    
    private func findCandidates(forPhrase inputPhrase: String, usingInterim interimCandidate: [String], maximumDepth: Int, currentDepth : Int) -> Set<String> {
        assert(currentDepth <= maximumDepth)
        
        let numberOfCharactersInputPhrase = inputPhrase.split(separator: " ").reduce(0) { acc, element in
            return acc + element.count
        }
        
        var candidateStrings = Set<String>()
        let charactersUsedByInterimCandidate = interimCandidate.reduce(0) { acc, element in
            return acc + element.count
        }
        let remainingCharacters = numberOfCharactersInputPhrase - charactersUsedByInterimCandidate
        let availableCharacters = self.remainingAvailableCharacters(candidates: interimCandidate)
        for i in stride(from: remainingCharacters, through: 1, by: -1) {
            if interimCandidate.count == maximumDepth - 1 {
                // At this point we can prune a lot, since we know how many characters last word MUST have
                if i != remainingCharacters {
                    break // OK, since we stride from remainingCharacters to 1, not opposite
                }
            }
            guard let wordsOfLengthI = self.lengthMap[i] else {
                continue
            }
            
            var possibleWords = Set<String>()
            
            if interimCandidate.count == maximumDepth - 1 {
                guard let wordsForKey = self.map[String(availableCharacters.sorted())] else {
                    continue
                }
                possibleWords = Set<String>(wordsForKey)
            } else {
                possibleWords = wordsOfLengthI
            }
            
            for word in possibleWords {
                if currentDepth == maximumDepth - 1 {
                    // At this stage, all words in possibleWords are all legal
                    candidateStrings.formUnion(possibleWords)
                    break
                } else if let lastWord = interimCandidate.last {
                    if word < lastWord {
                        continue
                    }
                }
                
                if !self.charactersAreAvailable(forCandidateWord: word, givenAvailableCharacters: availableCharacters) {
                    continue
                }
                
                var interimWordCandidates = interimCandidate
                interimWordCandidates.append(word)
                let candidatesForWord = self.findCandidates(forPhrase: inputPhrase, usingInterim: interimWordCandidates, maximumDepth: maximumDepth, currentDepth: currentDepth + 1)
                
                if candidatesForWord.isEmpty {
                    continue
                }
                for candidateWord in candidatesForWord {
                    //Swift.print("\(candidateWord)")
                    candidateStrings.insert("\(word) \(candidateWord)")
                }
            }
        }
        return candidateStrings
    }
    
    /**
     Checks whether a candidate string can be disregarded given the input phrase. This is determined by inspecting what characters the candidate string contains in comparison to what characters the inputPhrase contains.
     Example: Candidate "Toy" can be disregarded for inputPhrase "Some Boy" since 'T' does not appear in 'Boy'
     */
    public func shouldBeDiscarded(candidate: String, charactersInPhrase: Set<Character>) -> Bool {
        let charactersInCandidate = Set<Character>(candidate.sorted())
        let difference = charactersInCandidate.subtracting(charactersInPhrase)
        
        // Every letter in candidate must appear also in phrase
        if difference.isEmpty {
            return false
        } else {
            let key = String(candidate.sorted())
            // All other words on this key will fail, too
            self.map[key] = nil
            return true
        }
    }
    
    
    private func remainingAvailableCharacters(candidates: [String]) -> [Character] {
        var localFrequencyMap = self.characterFrequencyMapForInputPhrase
        
        for string in candidates {
            for character in string {
                // Remove from frequency map
                if let currentValue = localFrequencyMap[character] {
                    if currentValue == 1 {
                        localFrequencyMap[character] = nil
                    } else {
                        localFrequencyMap[character] = currentValue - 1
                    }
                }
            }
        }
        
        var availableCharactersLeft = [Character]()
        for (key, value) in localFrequencyMap {
            for _ in 0..<value {
                availableCharactersLeft.append(key)
            }
        }
        return availableCharactersLeft
    }
    
    private func charactersAreAvailable(forCandidateWord candidateWord: String, givenAvailableCharacters availableCharacters: [Character]) -> Bool {
        var frequencyMapForAvailableCharacters = produceCharacterFrequencyMap(forString: String(availableCharacters))
        
        for character in candidateWord {
            if let currentValue = frequencyMapForAvailableCharacters[character] {
                if currentValue == 1 {
                    frequencyMapForAvailableCharacters[character] = nil
                } else {
                    frequencyMapForAvailableCharacters[character] = currentValue - 1
                }
            } else {
                return false
            }
        }
        return true
    }
}
