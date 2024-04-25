import Foundation

enum Limit: String, CaseIterable {
    
    case limit30 = "30"
    case limit50 = "50"
    case limit75 = "75"
    case limit100 = "100"
    
    static func fromIdx(idx: Int) -> Limit? {
        let allCases = self.allCases
        guard idx >= 0 && idx < allCases.count else {
            return nil
        }
        return allCases[idx]
    }
    
}
