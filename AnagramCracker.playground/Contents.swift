import UIKit

for index in 13...1 {
    Swift.print(index)
}

let fileToLoad = URL(fileURLWithPath: "/Users/Morten/Repositories/CodingChallengePhraseFinder/AnagramCracker.playground/Resources/wordlist.txt")

let englishWords = TextLoaderImplementation.loadWords(fromFile: fileToLoad)
englishWords.count

let mapBuilder = AnagramMapBuilder()
let map = mapBuilder.produceMap(fromWords: englishWords)

let inputPhrase = "poultry outwits ants".split(separator: " ")
let anagramHelper = AnagramHelperImplementation(map: map)
for word in inputPhrase {
    String(
    let anagramsForWord = anagramHelper.anagrams(ofWord: word)
    Swift.print("\(anagramsForWord)")
1}
