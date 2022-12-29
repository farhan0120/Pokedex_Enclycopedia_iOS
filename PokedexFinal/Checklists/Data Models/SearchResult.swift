struct Pokemon: Codable {
  let name: String
  let height: Int
  let weight: Int
  let types: [Type]
  let sprites: Sprites
  let species: Species


  struct `Type`: Codable {
    let type: TypeDetails

    struct TypeDetails: Codable {
      let name: String
    }
  }

  struct Sprites: Codable {
    let front_default: String
  }

  struct Species: Codable {
    let url: String
  }

}
