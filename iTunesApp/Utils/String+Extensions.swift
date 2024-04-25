import Foundation

extension String {
    
    var htmlToString: String {
        guard let data = self.data(using: .utf8) else {
            return ""
        }
        do {
            let attributedString = try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
            return attributedString.string
        } catch {
            return ""
        }
    }
    
    var localize: String {
        return NSLocalizedString(self, comment: self)
    }
    
}
