import Foundation

protocol TextLoader {
    static func loadWords(fromFile: URL) -> Set<String>
}

public class TextLoaderImplementation : TextLoader {
    public static func loadWords(fromFile file: URL) -> Set<String> {
        let separator : Character = "\n"
        let contents = try! String(contentsOf: file).split(separator: separator).map { element in
            return String(element)
        }
        Swift.print("Done loading text")
        return Set<String>(contents)
        
    }
}
