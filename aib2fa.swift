import Foundation;

class Transaction {
    
    var explanation: String
    var value: String
    var date: String
    
    init(exp: String, value: String, date: String) {
        self.explanation = exp
        self.value = value
        self.date = date
    }
    
    func debugPrint() -> String {
        return "Date: \(self.date)\nExplanation: \(self.explanation)\nValue: \(self.value)\n\n"
    }
    
    func exportDate() -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yy"
        
        let timestamp = dateFormatter.date(from: self.date)
        
        guard let ts = timestamp else {
            return ""
        }
        
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        return dateFormatter.string(from: ts)
    }
    
    func exportFormat() -> String {
        return self.exportDate() + "," + self.value + ",\(self.explanation)"
    }
}

func formatLine(_ line:String) -> Transaction? {
    
    let columns = line.components(separatedBy: ",")
    
    guard columns.count == 7 else {
        return nil
    }
    
    let date = columns[1]
    
    let explanation = columns[2]
    
    let debit = columns[3]
    let credit = columns[4]
    
    if debit.characters.count > 0 || credit.characters.count > 0 {
        
        let value = debit.characters.count > 0 ? "-" + debit : credit
        
        let transaction = Transaction(exp: explanation, value: value, date: date)
        
        //print("\(transaction.exportFormat())")
        
        return transaction
    }
    else {
        return nil
    }
}

func outputFileURLForInputFileURL(_ inputFileURL: URL) -> URL {
    
    let withoutExtension = inputFileURL.deletingPathExtension()
    
    return URL(fileURLWithPath: withoutExtension.path + "-converted.csv")
}

func writeTransactions(_ transactions: [Transaction], toFileURL: URL) {
    
    print("ℹ️  Writing \(transactions.count) transactions...")
    
    let outputStrings: [String] = transactions.map { (t) -> String in
        return t.exportFormat()
    }
    
    let outputString = outputStrings.joined(separator: "\n")
    
    //print("\(outputString)")
    
    do {
        try outputString.write(toFile: toFileURL.path, atomically: true, encoding: String.Encoding.utf8)
    }
    catch {
        print("🛑  Write failed!")
        exit(7)
    }
    
    print("✅  Exported to \(toFileURL).")
}


let arguments = CommandLine.arguments

guard arguments.count > 1 else {
    print("⁉️  No filename given.")
    exit(1)
}

let file = arguments[1]

let fileManager = FileManager.default

guard fileManager.fileExists(atPath: file) else {
    print("🛑  File does not exist.")
    exit(2)
}

let fileURL = URL(fileURLWithPath: file)

var fileString: String? = nil

do {
    fileString = try String(contentsOf: fileURL, encoding: String.Encoding.utf8)
}
catch {
    print("🛑  Could not read file.")
    exit(3)
}

guard let fs = fileString else {
    print("🛑  File is empty.")
    exit(4)
}

var lines = fs.components(separatedBy: .newlines)

guard lines.count > 0 else {
    print("🛑  File is empty.")
    exit(5)
}


var transactions: [Transaction] = []

lines.remove(at: 0)

lines.forEach { (line) in
    
    if let transaction = formatLine(line) {
        transactions.append(transaction)
    }
}

guard transactions.count > 0 else {
    print("🛑  No transactions found.")
    exit(6)
}

writeTransactions(transactions, toFileURL: outputFileURLForInputFileURL(fileURL))

