//
//  SetsListView.swift
//  BrickSet
//
//  Created by Work on 18/05/2020.
//  Copyright © 2020 Homework. All rights reserved.
//

import SwiftUI

struct SetsListView: View {
    
    var items : [LegoSet]
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.verticalSizeClass) var verticalSizeClass
    @EnvironmentObject private var  store : Store
    @Binding var sorter : LegoListSorter
    @Binding var filter : LegoListFilter
    
    
    
    var body: some View {
        
        if setsToShow.count == 0 {
            TrySyncView(count: store.sets.filter({$0.collection.owned}).count)
        } else {
            if horizontalSizeClass == . compact {
                List{
                    ForEach(sections(for:  setsToShow ), id: \.self){ theme in
                        if theme == "" {
                            sectionListView(theme: theme)
                        } else {
                            Section(header:
                                        Text(theme).roundText
                                        .padding(.leading, -12)
                                        .padding(.bottom, -26)
                            ){
                                sectionListView(theme: theme)
                                
                            }
                        }
                        
                    }
                }.naked
                //                    .refreshable {
                //                        store.requestForSync = true
                //                    }
            } else {
                ScrollView{
                    LazyVStack(alignment: .leading, spacing: 16, pinnedViews: [.sectionHeaders]) {
                        ForEach(sections(for:  setsToShow ), id: \.self){ theme in
                            Section(header:
                                        Text(theme).roundText
                                        .padding(.leading, 4)
                                        .padding(.bottom, -26)
                            ) {
                                
                                LazyVGrid(columns: [GridItem(.flexible()),GridItem(.flexible())]){
                                    sectionView(theme: theme)
                                }
                                
                            }
                        }
                    }
                }
            }
        }
    }
    
    func sectionView(theme:String) -> some View{
        ForEach(self.items(for: theme, items: self.setsToShow ), id: \.setID) { item in
            NavigationLink(destination: SetDetailView(set: item)) {
                SetListCell(set:item)
            }
            .contentShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .padding(.leading,16).padding(.trailing,8)
            .contextMenu {
                CellContextMenu(owned: item.collection.qtyOwned, wanted: item.collection.wanted) {
                    self.store.action(.qty(item.collection.qtyOwned+1),on: item)
                } remove: {
                    self.store.action(.qty(item.collection.qtyOwned-1),on: item)
                } want: {
                    self.store.action(.want(!item.collection.wanted),on: item)
                }
            }
            
        }
    }
    
    func sectionListView(theme:String) -> some View{
        ForEach(self.items(for: theme, items: self.setsToShow ), id: \.setID) { item in
            NakedListCell(
                owned: item.collection.qtyOwned, wanted: item.collection.wanted,
                add: {self.store.action(.qty(item.collection.qtyOwned+1),on: item)},
                remove: {store.action(.qty(item.collection.qtyOwned-1),on: item)},
                want: {store.action(.want(!item.collection.wanted),on: item)},
                destination: SetDetailView(set: item)) {
                    SetListCell(set:item)
                }
                .padding(.leading,16).padding(.trailing,8)
        }
    }
    
    func sections(for items:[LegoSet]) -> [String] {
        switch sorter {
        case .number,.piece,.price,.pieceDesc,.priceDesc,.pricePerPiece,.pricePerPieceDesc:
            return [""]
        case .alphabetical:
            return Array(Set(items.compactMap({String($0.name.prefix(1))}))).sorted()
        case .older:
            return Array(Set(items.compactMap({"\($0.year)"}))).sorted()
        case .newer:
            return Array(Set(items.compactMap({"\($0.year)"}))).sorted(by: {$0 > $1})
        default:
            return Array(Set(items.compactMap({$0.theme}))).sorted()
        }
    }
    func items(for section:String,items:[LegoSet]) -> [LegoSet] {
        switch sorter {
        case .number:
            return items.sorted(by: {Int($0.number) ?? 0 < Int($1.number) ?? 0})
        case .piece:
            return items.sorted(by: {$0.pieces ?? 0 < $1.pieces ?? 0})
        case .pieceDesc:
            return items.sorted(by: {$0.pieces ?? 0 > $1.pieces ?? 0})
        case .price:
            return items.sorted(by: {$0.priceFloat  < $1.priceFloat})
        case .priceDesc:
            return items.sorted(by: {$0.priceFloat  > $1.priceFloat})
        case .pricePerPiece:
            return items.sorted(by: {$0.pricePerPieceFloat  < $1.pricePerPieceFloat})
        case .pricePerPieceDesc:
            return items.sorted(by: {$0.pricePerPieceFloat  > $1.pricePerPieceFloat})
        case .alphabetical:
            return items.filter({String($0.name.prefix(1)) == section}).sorted(by: {$0.name < $1.name})
        case .older,.newer:
            return items.filter({"\($0.year)" == section}).sorted(by: {$0.name < $1.name})
            
        default:
            return items.filter({$0.theme == section}).sorted(by: {$0.subtheme ?? "" < $1.subtheme ?? "" && $0.name < $1.name})
        }
    }
    
    var setsToShow : [LegoSet] {
        switch filter {
        case .all:
            return  items
        case .wanted:
            return  store.searchSetsText.isEmpty ? store.sets.filter({$0.collection.wanted}) : items.filter({$0.collection.wanted})
        case .owned:
            return items.filter({$0.collection.owned})
        }
    }
    
}
