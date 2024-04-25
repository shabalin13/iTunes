import Foundation

enum Explicit: String, CaseIterable {
    
    case yes = "Yes"
    case no = "No"
    
    static func fromIdx(idx: Int) -> Explicit? {
        let allCases = self.allCases
        guard idx >= 0 && idx < allCases.count else {
            return nil
        }
        return allCases[idx]
    }
    
}
