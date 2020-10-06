//
//  ContentView.swift
//  InfiniteListSwiftUI
//
//  Created by Ashish Tyagi on 06/10/20.
//  Copyright © 2020 Ashish Tyagi. All rights reserved.
//

import SwiftUI
import Combine

class RepositoriesViewModel: ObservableObject {
    @Published private(set) var state = State()
    private var subscriptions = Set<AnyCancellable>()
    
    func fetchNextPageIfPossible() {
        guard state.canLoadNextPage else { return }
        
        GithubAPI.searchRepos(query: "swift", page: state.page)
            .sink(receiveCompletion: onReceive,
                  receiveValue: onReceive)
            .store(in: &subscriptions)
    }
    
    private func onReceive(_ completion: Subscribers.Completion<Error>) {
        switch completion {
        case .finished:
            break
        case .failure:
            state.canLoadNextPage = false
        }
    }

    private func onReceive(_ batch: [RepositoryList]) {
        state.repos += batch
        state.page += 1
        state.canLoadNextPage = batch.count == GithubAPI.pageSize
    }

    struct State {
        var repos: [RepositoryList] = []
        var page: Int = 1
        var canLoadNextPage = true
    }
}

struct RepositoriesListContainer: View {
    @ObservedObject var viewModel: RepositoriesViewModel
    
    var body: some View {
        ContentView(
            repos: viewModel.state.repos,
            isLoading: viewModel.state.canLoadNextPage,
            onScrolledAtBottom: viewModel.fetchNextPageIfPossible
        )
        .onAppear(perform: viewModel.fetchNextPageIfPossible)
    }
}



struct ContentView: View {
    
    let repos: [RepositoryList]
    let isLoading: Bool
    let onScrolledAtBottom: () -> Void
   
        //Use this if NavigationBarTitle is with Large Font
    var body: some View {
    NavigationView {
        List {
            repoList
            if isLoading {
                loadingIndicator
            }
        }.navigationBarTitle("Infinite List")
        .foregroundColor(.black)
        .font(.headline)
    }
    }
    
    private var repoList: some View {
        ForEach(repos) { repo in
            RepositoryRow(repo: repo)
                .onAppear {
            if self.repos.last == repo {
                self.onScrolledAtBottom()
                }
            }
        }
    }
    
    private var loadingIndicator: some View {
        Spinner(style: .medium)
       .frame(idealWidth: .infinity, maxWidth: .infinity, alignment: .center)
    }
    
}


struct RepositoryRow: View {
    let repo: RepositoryList
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(repo.name).font(.headline)
            .padding()
            repo.description.map(Text.init)?.font(.subheadline)
            .padding()
            Text("⭐️ \(repo.stargazers_count)").font(.footnote)
            .padding()
        }.listRowBackground(Color.init(.systemGroupedBackground))
        .foregroundColor(.black)
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        RepositoriesListContainer(viewModel: RepositoriesViewModel())
    }
}


