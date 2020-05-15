//
//  AgenciaView.swift
//  Desafio Itau
//
//  Created by Luiz Carlos Cunha  on 15/05/20.
//  Copyright © 2020 Luiz Carlos Cunha . All rights reserved.
//

import UIKit

protocol AgenciaViewDelegate {
    func showAgencias(agencias: [Agencia])
    func setLoadingTo(_ state: Bool)
}

class AgenciaView: UIViewController {
    
    var viewModel: AgenciaViewModel
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        self.viewModel = AgenciaViewModel()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        self.viewModel.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.viewModel.ready()
    }
    
}

extension AgenciaView: AgenciaViewDelegate {
    
    func setLoadingTo(_ state: Bool) {
        state ? print("Loading") : print("Not Loading")
    }
    
    func showAgencias(agencias: [Agencia]) {
        print("Show Agencias")
    }
}



