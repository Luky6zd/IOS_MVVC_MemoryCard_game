//
//  EmojiMemoryGame.swift
//  MemoryCard
//
//  Created by Lucrezia Odrljin on 22.07.2024.


// importanje SwiftUI-a jer je ViewModel dio UI
import SwiftUI

// MARK: View Model memory igre

// klasa jer ce EmojiMemoryGame biti share-ana/koristena u cijeloj memory igri
// implementiran protokol za prikaz promjena u UI-u
class EmojiMemoryGame: ObservableObject {
    // alias kartice
    typealias aCard =  MemoryGame<String>.Card
    // globalno dostupna privatna varijabla, ali setirana unutar klase
    private static let emoji = ["🏋🏻‍♀️", "⛹🏼‍♀️", "🏄🏾‍♀️", "🤽🏼", "🤾", "🚣🏼‍♀️", "🚵🏼‍♂️", "🤸🏽‍♂️", "🤼‍♀️", "🚴🏽‍♂️", "🏌🏿‍♂️", "⛷️"]
    
    // privatna globalno dostupna funkcija koja kreira memory game, vraca MemoryGame Stringa sa brojem kartica
    private static func createMemoryGame() -> MemoryGame<String> {
        return MemoryGame(numberOfCardPairs: 2) { pairIndex in
            // zastita ViewModela da broj kartica ne izade iz dosega
            // ako su emoji u range-u i imaju pairIndex
            if emoji.indices.contains(pairIndex) {
                // vrati emoji koji se nalazi na tom indexu
                return emoji[pairIndex]
                // ako su izvan range-a, vrati obavijest
            } else {
                return "⁉️"
            }
        }
    }
    
    // privatna varijabla model tipa MemoryGame, koji je generic tipa String, pohranjuje sto vrati funkcija createMemoryGame
    // markacija published oznacava da se na toj varijabli izvrsavaju promjene
    @Published private var model = createMemoryGame()
    
    // preko View Modela osiguravamo pristup varijabli card iz Modela
    // computed property, varijabla je tipa Array, MemoryGame koji je String
    // vraca Model kartica iz MemoryGame-a, da View "vidi" kartice
    var cards: Array<aCard> {
        return model.cards
    }
    
    // setiranje boje pozadine kartice
    var color: Color {
        return .mediumLille
    }
    
    // MARK: - Intents
    // funkcija koja poziva shuffle funkciju u modelu
    func shuffle() {
        model.shuffle()
        // pozivanje funkcije koja vrsi promjene na UI/View-u
        objectWillChange.send()
    }
    
    // intent funkcija gdje user ima namjeru izabrati neku od ponudenih kartica
    // funkcija da View "vidi" funkciju chooseCard iz Modela koji je privatan
    func choose(_ card: aCard) {
        // model poziva metodu chooseCard sa argumentom card
        model.chooseCard(card)
    }
}

