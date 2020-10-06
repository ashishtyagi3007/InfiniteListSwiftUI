//
//  GithubAPI.swift
//  InfiniteListSwiftUI
//
//  Created by Ashish Tyagi on 06/10/20.
//  Copyright © 2020 Ashish Tyagi. All rights reserved.
//

import Foundation
import Combine

enum GithubAPI {
    static let pageSize = 10
    
    /// tryMap:---> to transform from one kind of element to another, and to terminate publishing when the map’s closure throws an error.
    ///If your closure doesn’t throw, use map(_:) instead.
    
    static func searchRepos(query: String, page: Int) -> AnyPublisher<[RepositoryList], Error> {
        let url = URL(string: "https://api.github.com/search/repositories?q=\(query)&sort=stars&per_page=\(Self.pageSize)&page=\(page)")!
        return URLSession.shared
            .dataTaskPublisher(for: url) // 1.
            .tryMap { try JSONDecoder().decode(GithubSearchResultData<RepositoryList>.self, from: $0.data).items } // 2.
            .receive(on: DispatchQueue.main) // 3.
            .eraseToAnyPublisher()
    }
}

struct RepositoryList: Codable, Identifiable, Equatable {
    let id: Int
    let name: String
    let description: String?
    let stargazers_count: Int
}

struct GithubSearchResultData<T: Codable>: Codable {
    let items: [T]
}
