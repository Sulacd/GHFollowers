//
//  UIHelper.swift
//  GHFollowers
//
//  Created by Christian Diaz on 7/6/22.
//

import UIKit

enum UIHelper {
    
    // Function that creates a collection view layout with 3 columns
    static func createThreeColumnFlowLayout(in view: UIView) -> UICollectionViewLayout {
        let width = view.bounds.width
        let padding: CGFloat = 12
        let minimumItemSpacing: CGFloat = 10
        let availableWidth = width - (padding * 2) - (minimumItemSpacing * 2)
        let itemWidth = availableWidth / 3
        
        let flowLayout = UICollectionViewFlowLayout()
        // Layout of each cell with padding around each side
        flowLayout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        // Size of each cell
        flowLayout.itemSize = CGSize(width: itemWidth, height: itemWidth + 40 )
        
        return flowLayout
    }

}

