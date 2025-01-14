//
//  SetListCell.swift
//  BrickSet
//
//  Created by Work on 04/05/2020.
//  Copyright © 2020 LEOLELEGO. All rights reserved.
//

import SwiftUI

let kCellHeight : CGFloat = 150

struct SetListCell : View {
    @ObservedObject var set : LegoSet
//    @AppStorage(Settings.currency) var currency : Currency = .default

    var body: some View {
        ZStack(alignment: .bottomTrailing){
            self.makeInfos()
            PastilView(owned: set.collection.qtyOwned, wanted:  set.collection.wanted)

        }
        .background(BackgroundImageView(imagePath: self.set.image.imageURL))
        .modifier(RoundedShadowMod())

    }
    
   
    
    func makeInfos() -> some View {
        VStack(alignment: .leading,spacing: 12) {
            HStack(alignment: .top){
                VStack(alignment: .leading) {
                    Text(set.name).font(.title).bold()
                    if set.subtheme != nil {
                        Text(set.subtheme!).font(.subheadline)
                    }
                }
                Spacer()
                Text(set.number+" ").font(.lego(size: 27)).offset(x: 22, y: -6)
            }
            Spacer()
            makeDetails()
        }
        .padding(.vertical, 12)
            .padding(.horizontal, 16)
            .foregroundColor(Color.black)
            .frame(maxWidth: .infinity,maxHeight: .infinity,alignment:.topLeading)
    }
    func makeDetails() -> some View{
        HStack(alignment: .center){
            Text("\(set.pieces ?? 0)").font(.headline)
            Image.brick(height:20)
            Text("\(set.minifigs ?? 0)").font(.headline)
            Image.minifig_head(height:20)
            //Spacer()
            if set.pricePerPieceFloat != 0{
                Text("\(set.pricePerPiece ?? "")/p").font(.footnote)
            }
            Text(set.price ?? "").font(.headline)



            
        }
    }

}
