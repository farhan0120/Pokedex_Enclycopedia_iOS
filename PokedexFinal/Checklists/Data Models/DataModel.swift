/// Copyright (c) 2021 Razeware LLC
/// 
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
/// 
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
/// 
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
/// 
/// This project and source code may use libraries or frameworks that are
/// released under various Open-Source licenses. Use of those libraries and
/// frameworks are governed by their own individual licenses.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import Foundation

class DataModel {
  var lists = [Checklist]()

  var indexOfSelectedChecklist: Int {
    get {
      return UserDefaults.standard.integer(
        forKey: "ChecklistIndex")
    }
    set {
      UserDefaults.standard.set(
        newValue,
        forKey: "ChecklistIndex")
    }
  }
  
  init() {
    loadChecklists()
    registerDefaults()
    handleFirstTime()
  }

  // MARK: - Data Saving
  func documentsDirectory() -> URL {
    let paths = FileManager.default.urls(
      for: .documentDirectory,
         in: .userDomainMask)
    return paths[0]
  }

  func dataFilePath() -> URL {
    return documentsDirectory().appendingPathComponent("Checklists.plist")
  }

  func saveChecklists() {
    let encoder = PropertyListEncoder()
    do {
      let data = try encoder.encode(lists)
      try data.write(
        to: dataFilePath(),
        options: Data.WritingOptions.atomic)
    } catch {
      print("Error encoding list array: \(error.localizedDescription)")
    }
  }

  func loadChecklists() {
    let path = dataFilePath()
    if let data = try? Data(contentsOf: path) {
      let decoder = PropertyListDecoder()
      do {
        lists = try decoder.decode(
          [Checklist].self,
          from: data)
      } catch {
        print("Error decoding list array: \(error.localizedDescription)")
      }
    }
  }

  // MARK: - Defaults
  func registerDefaults() {
    let dictionary = [
      "ChecklistIndex": -1,
      "FirstTime": true
    ] as [String: Any]
    UserDefaults.standard.register(defaults: dictionary)
  }

  func handleFirstTime() {
    let userDefaults = UserDefaults.standard
    let firstTime = userDefaults.bool(forKey: "FirstTime")

    if firstTime {
      if firstTime {
        let kanto = Checklist(name: "Kanto")
        let johto = Checklist(name: "Johto")
        let hoenn = Checklist(name: "Hoenn")
        
        
        
        let kanto0 = ChecklistItem()
        kanto0.text = "Squirtle"
        kanto.items.append(kanto0)

        let kanto1 = ChecklistItem()
        kanto1.text = "Charmander"
        kanto.items.append(kanto1)
        
        let kanto2 = ChecklistItem()
        kanto2.text = "Baulbasaur"
        kanto.items.append(kanto2)
        
        
        let johto0 = ChecklistItem()
        johto0.text = "Chikorita"
        johto.items.append(johto0)

        let johto1 = ChecklistItem()
        johto1.text = "Cyndaquil"
        johto.items.append(johto1)
        
        let johto2 = ChecklistItem()
        johto2.text = "Totodile"
        johto.items.append(johto2)
        
        let hoenn0 = ChecklistItem()
        hoenn0.text = "Treecko"
        hoenn.items.append(hoenn0)

        let hoenn1 = ChecklistItem()
        hoenn1.text = "Mudkip"
        hoenn.items.append(hoenn1)
        
        let hoenn2 = ChecklistItem()
        hoenn2.text = "Torchic"
        hoenn.items.append(hoenn2)
        
        lists.append(kanto)
        lists.append(johto)
        lists.append(hoenn)
       

        indexOfSelectedChecklist = 0
        userDefaults.set(false, forKey: "FirstTime")
    }
  }
}
}
