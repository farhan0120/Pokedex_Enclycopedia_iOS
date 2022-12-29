//
//  String+FormatText.swift
//  Checklists
//
//  Created by Farhan Molla on 12/9/22.
//

import Foundation
extension String {
  func format() -> String {
    return String((self.lowercased()).trimmingCharacters(in: .whitespacesAndNewlines))
  }
}
