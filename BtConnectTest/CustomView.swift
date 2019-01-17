//
//  CustomView.swift
//  BtConnectTest
//
//  Created by sanghyuk on 09/01/2019.
//  Copyright © 2019 sanghyuk. All rights reserved.
//

import UIKit

class CustomView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    @IBOutlet private weak var stateLabel: UILabel!
    @IBAction private func closeButton(_ sender: Any) {
        self.removeFromSuperview()
    }

}
