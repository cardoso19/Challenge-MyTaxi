//
//  CarListViewController.swift
//  Challenge
//
//  Created by Matheus Cardoso kuhn on 06/04/19.
//  Copyright © 2019 MDT. All rights reserved.
//

import UIKit
import CoreLocation

class CarListViewController: UIViewController {

    //MARK: - IBOutlets
    @IBOutlet weak var tableViewCars: UITableView!
    @IBOutlet weak var imageViewTaxi: UIImageView!
    @IBOutlet weak var imageViewPool: UIImageView!
    
    //MARK: - Variables
    var viewModel: CarListViewModel!
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configGesture()
    }
    
    func configGesture() {
        let tapGestureTaxi = UITapGestureRecognizer(target: self, action: #selector(actionSelectTaxi(_:)))
        let tapGesturePool = UITapGestureRecognizer(target: self, action: #selector(actionSelectPool(_:)))
        imageViewTaxi.addGestureRecognizer(tapGestureTaxi)
        imageViewPool.addGestureRecognizer(tapGesturePool)
    }
    
    //MARK: - IBActions
    @objc func actionSelectTaxi(_ sender: AnyObject) {
        if viewModel.changeTaxiSelection() {
            imageViewTaxi.image = viewModel.getTaxiIcon()
        }
    }
    
    @objc func actionSelectPool(_ sender: AnyObject) {
        if viewModel.changePoolSelection() {
            imageViewTaxi.image = viewModel.getPoolIcon()
        }
    }
    
    //MARK: - Setter
    @objc func set(viewModel: CarListViewModel) {
        self.viewModel = viewModel
    }
}

//MARK: - UITableViewDataSource
extension CarListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.carsCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "car") as? CarTableViewCell else { return UITableViewCell() }
        let carInformation = viewModel.getData(on: indexPath)
        cell.labelType.text = carInformation?.type
        cell.labelDistance.text = carInformation?.distance
        return cell
    }
}
