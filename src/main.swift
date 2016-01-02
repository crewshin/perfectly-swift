// #if os(Linux)
// import Glibc
// srandom(UInt32(clock()))
// #endif
//
// import DeckOfPlayingCards
//
// let numberOfCards = 10
//
// var deck = Deck.standard52CardDeck()
// deck.shuffle()
//
// for _ in 0..<numberOfCards {
//     guard let card = deck.deal() else {
//         print("No More Cards!")
//         break
//     }
//
//     print(card)
// }


func fibonacci(i: Int) -> Int {
    if i <= 2 {
        return 1
    } else {
        return fibonacci(i - 1) + fibonacci(i - 2)
    }
}

print(fibonacci(22))
