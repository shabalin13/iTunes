import Foundation

struct DisplayedItem: Hashable {
    
    private let id = UUID()
    let contentNameLabelText: String
    let secondaryLabelText: String
    let descriptionLabelText: String
    let explicit: Bool?
    let imageURL: URL?
    
}
