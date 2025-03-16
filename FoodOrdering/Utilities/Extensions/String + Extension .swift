//
//  String + Extension .swift
//  UpLevel
//
//  Created by techelix_iOS on 3/20/24.
//

import Foundation
import UIKit

extension String{
    
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: self)
    }
    
    func base64ToImage() -> UIImage? {
        if let data = Data(base64Encoded: self, options: .ignoreUnknownCharacters) {
            return UIImage(data: data)
        }
        return nil
    }
    
    var digits: String {
        return components(separatedBy: CharacterSet.decimalDigits.inverted)
            .joined()
    }
}

//MARK: -
extension String {
    mutating func removeWhiteSpacesFromStartNEnd() {
        self = self.trimmingCharacters(in: .whitespaces)
    }
    mutating func removeNewLinesFromStartNEnd() {
        self = self.trimmingCharacters(in: .newlines)
    }
    
    mutating func removeNewLinesWhiteSpacesFromStartNEnd() {
        self = self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

//MARK: - Convert_HTML_To_Plain_Text
extension String{
    func convertHTMLToPlainText() -> String {
        guard let data = self.data(using: .utf8) else { return self }
        
        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue]

        if let attributedString = try? NSAttributedString(data: data, options: options, documentAttributes: nil) {
            return attributedString.string
        } else {
            return self
        }
    }
}

//MARK: - notification Title
extension String {
    func notificationTitle() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        
        guard let date = dateFormatter.date(from: self) else {
            return ""
        }
        
        let today = Calendar.current.startOfDay(for: Date())
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: today)!
        
        if Calendar.current.isDateInToday(date) {
            return "Today"
        } else if Calendar.current.isDateInYesterday(date) {
            return "Yesterday"
        } else {
            dateFormatter.dateFormat = "EEEE, MMM d, yyyy"
            return dateFormatter.string(from: date)
        }
    }
}
