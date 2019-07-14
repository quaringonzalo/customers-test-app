//
//  CustomerListViewController.swift
//  customers-test-app
//
//  Created by Gonzalo Alexis Quarin on 14/07/2019.
//  Copyright © 2019 Gonzalo Alexis Quarin. All rights reserved.
//

import UIKit

class CTACustomerListViewController: CTABaseViewController {

    private var viewModel: CTACustomerListViewModel!
    private var customerListDelegateAndDataSource: CTACustomerListDelegateAndDataSource!
    
    @IBOutlet weak var customersCollectionView: UICollectionView!
    
    public override func viewDidLoad() {
        super.viewDidLoad()        
        title = "Clientes"
        
        setupCollectionView()
        
        viewModel = CTACustomerListViewModel()
        viewModel.delegate = self
        
        viewModel.getCustomers()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showBackButton(show: true)
    }
    
    private func setupCollectionView() {
        let nib = UINib(nibName: String(describing: CTACustomerCollectionViewCell.self), bundle: nil)
        customersCollectionView.register(nib, forCellWithReuseIdentifier: CTACustomerCollectionViewCell.cellId)
        
        customerListDelegateAndDataSource = CTACustomerListDelegateAndDataSource()
        customersCollectionView.delegate = customerListDelegateAndDataSource
        customersCollectionView.dataSource = customerListDelegateAndDataSource
    }
}

extension CTACustomerListViewController : CTACustomerListViewModelDelegate {
    public func onSuccess(customers: [CTACustomerModel]) {
        customerListDelegateAndDataSource.customerList = customers
        customersCollectionView.reloadData()
    }
    
    public func onError(message: String) {
        CTASnackbarHelper.showMessage(message: message)
    }
}
