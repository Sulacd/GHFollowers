//
//  UIView+Ext.swift
//  GHFollowers
//
//  Created by Christian Diaz on 7/19/22.
//

import UIKit

extension UIView {
    
    func addSubViews(_ views: UIView...) {
        for view in views {
            addSubview(view)
        }
    }
}
