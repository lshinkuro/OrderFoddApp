//
//  BookModel.swift
//  OrderFoodApp
//
//  Created by Phincon on 31/01/25.
//

import UIKit

// Model data
struct Book: Hashable {
    let id = UUID() // Unique identifier
    let title: String
    let author: String
    let coverImageName: String
    
    // Implement Hashable
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Book, rhs: Book) -> Bool {
        return lhs.id == rhs.id
    }
}

// Section identifier
enum SectionBook {
    case main
}


// Data dummy
let gridBooks = [
    Book(title: "The Great Gatsby", author: "F. Scott Fitzgerald", coverImageName: "great_gatsby"),
    Book(title: "1984", author: "George Orwell", coverImageName: "1984"),
    Book(title: "To Kill a Mockingbird", author: "Harper Lee", coverImageName: "mockingbird"),
    Book(title: "Pride and Prejudice", author: "Jane Austen", coverImageName: "pride_prejudice")
]

let horizontalBooks = [
    Book(title: "Moby Dick", author: "Herman Melville", coverImageName: "moby_dick"),
    Book(title: "War and Peace", author: "Leo Tolstoy", coverImageName: "war_peace"),
    Book(title: "The Odyssey", author: "Homer", coverImageName: "odyssey")
]

let listBooks = [
    Book(title: "The Catcher in the Rye", author: "J.D. Salinger", coverImageName: "catcher_rye"),
    Book(title: "Brave New World", author: "Aldous Huxley", coverImageName: "brave_new_world"),
    Book(title: "Crime and Punishment", author: "Fyodor Dostoevsky", coverImageName: "crime_punishment")
]

