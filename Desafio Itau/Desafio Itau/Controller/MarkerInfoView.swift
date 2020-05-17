//
//  MarkerInfoView.swift
//  Desafio Itau
//
//  Created by Luiz Carlos Cunha  on 16/05/20.
//  Copyright © 2020 Luiz Carlos Cunha . All rights reserved.
//

import UIKit

class MarkerInfoView: UIView {
    let kCONTENT_XIB_NAME = "MarkerInfoView"
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var openingHours: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        Bundle.main.loadNibNamed(kCONTENT_XIB_NAME, owner: self, options: nil)
        
    }
}
