//
//  Test2ViewController.swift
//  iplix
//
//  Created by Farhan Adji on 14/05/20.
//  Copyright © 2020 Farhan Adji. All rights reserved.
//

import UIKit

class Test2ViewController: UIViewController {
//    let label = UILabel()
    let tabNewLabel = UILabel()
    let statusNew = StatusChip()
    let tabProcessLabel = UILabel()
    let statusPickup = StatusChip()
    let statusWaiting = StatusChip()
    let statusAlready = StatusChip()
    let tabDeliveredLabel = UILabel()
    let statusSettled = StatusChip()
    let statusDelivered = StatusChip()
    let tabCanceledLabel = UILabel()
    let statusCanceled = StatusChip()
    let statusFailed = StatusChip()
    let tabCustomLabel = UILabel()
    let customChip = StatusChip()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupView()
        // Do any additional setup after loading the view.
    }
    
    func setupView() {
        statusNew.setStatus(status: .new)
        statusPickup.setStatus(status: .pickup_time_filled)
        statusWaiting.setStatus(status: .waiting_for_pickup)
        statusAlready.setStatus(status: .already_picked_up)
        statusSettled.setStatus(status: .already_settled)
        statusDelivered.setStatus(status: .delivered)
        statusCanceled.setStatus(status: .canceled)
        statusFailed.setStatus(status: .delivery_failed)
        customChip.setCustomChip(title: "Custom Chip", color: .blue)
        view.addSubview(tabNewLabel)
        view.addSubview(statusNew)
        view.addSubview(tabProcessLabel)
        view.addSubview(statusPickup)
        view.addSubview(statusWaiting)
        view.addSubview(statusAlready)
        view.addSubview(tabDeliveredLabel)
        view.addSubview(statusSettled)
        view.addSubview(statusDelivered)
        view.addSubview(tabCanceledLabel)
        view.addSubview(statusCanceled)
        view.addSubview(statusFailed)
        view.addSubview(tabCustomLabel)
        view.addSubview(customChip)
        tabNewLabel.text = "Tab New"
        tabProcessLabel.text = "Tab In Process"
        tabDeliveredLabel.text = "Tab Delivered"
        tabCanceledLabel.text = "Tab Canceled"
        tabCustomLabel.text = "Custom Chip"
        
        tabNewLabel.translatesAutoresizingMaskIntoConstraints = false
        tabNewLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        tabNewLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true

        statusNew.translatesAutoresizingMaskIntoConstraints = false
        statusNew.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        statusNew.leadingAnchor.constraint(equalTo: tabNewLabel.trailingAnchor, constant: 10).isActive = true
        statusNew.widthAnchor.constraint(equalToConstant: statusNew.frame.width).isActive = true
        statusNew.heightAnchor.constraint(equalToConstant: statusNew.frame.height).isActive = true
        
        tabProcessLabel.translatesAutoresizingMaskIntoConstraints = false
        tabProcessLabel.topAnchor.constraint(equalTo: tabNewLabel.bottomAnchor, constant: 10).isActive = true
        tabProcessLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        
        statusPickup.translatesAutoresizingMaskIntoConstraints = false
        statusPickup.topAnchor.constraint(equalTo: statusNew.bottomAnchor, constant: 10).isActive = true
        statusPickup.leadingAnchor.constraint(equalTo: tabProcessLabel.trailingAnchor, constant: 10).isActive = true
        statusPickup.widthAnchor.constraint(equalToConstant: statusPickup.frame.width).isActive = true
        statusPickup.heightAnchor.constraint(equalToConstant: statusPickup.frame.height).isActive = true
        
        statusWaiting.translatesAutoresizingMaskIntoConstraints = false
        statusWaiting.topAnchor.constraint(equalTo: statusNew.bottomAnchor, constant: 10).isActive = true
        statusWaiting.leadingAnchor.constraint(equalTo: statusPickup.trailingAnchor, constant: 10).isActive = true
        statusWaiting.widthAnchor.constraint(equalToConstant: statusWaiting.frame.width).isActive = true
        statusWaiting.heightAnchor.constraint(equalToConstant: statusWaiting.frame.height).isActive = true
        
        statusAlready.translatesAutoresizingMaskIntoConstraints = false
        statusAlready.topAnchor.constraint(equalTo: statusPickup.bottomAnchor, constant: 10).isActive = true
        statusAlready.leadingAnchor.constraint(equalTo: tabProcessLabel.trailingAnchor, constant: 10).isActive = true
        statusAlready.widthAnchor.constraint(equalToConstant: statusAlready.frame.width).isActive = true
        statusAlready.heightAnchor.constraint(equalToConstant: statusAlready.frame.height).isActive = true
        
        tabDeliveredLabel.translatesAutoresizingMaskIntoConstraints = false
        tabDeliveredLabel.topAnchor.constraint(equalTo: statusAlready.bottomAnchor, constant: 10).isActive = true
        tabDeliveredLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        
        statusSettled.translatesAutoresizingMaskIntoConstraints = false
        statusSettled.topAnchor.constraint(equalTo: statusAlready.bottomAnchor, constant: 10).isActive = true
        statusSettled.leadingAnchor.constraint(equalTo: tabDeliveredLabel.trailingAnchor, constant: 10).isActive = true
        statusSettled.widthAnchor.constraint(equalToConstant: statusSettled.frame.width).isActive = true
        statusSettled.heightAnchor.constraint(equalToConstant: statusSettled.frame.height).isActive = true
     
        statusDelivered.translatesAutoresizingMaskIntoConstraints = false
        statusDelivered.topAnchor.constraint(equalTo: statusAlready.bottomAnchor, constant: 10).isActive = true
        statusDelivered.leadingAnchor.constraint(equalTo: statusSettled.trailingAnchor, constant: 10).isActive = true
        statusDelivered.widthAnchor.constraint(equalToConstant: statusDelivered.frame.width).isActive = true
        statusDelivered.heightAnchor.constraint(equalToConstant: statusDelivered.frame.height).isActive = true
        
        tabCanceledLabel.translatesAutoresizingMaskIntoConstraints = false
        tabCanceledLabel.topAnchor.constraint(equalTo: tabDeliveredLabel.bottomAnchor, constant: 10).isActive = true
        tabCanceledLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        
        statusCanceled.translatesAutoresizingMaskIntoConstraints = false
        statusCanceled.topAnchor.constraint(equalTo: statusSettled.bottomAnchor, constant: 10).isActive = true
        statusCanceled.leadingAnchor.constraint(equalTo: tabCanceledLabel.trailingAnchor, constant: 10).isActive = true
        statusCanceled.widthAnchor.constraint(equalToConstant: statusCanceled.frame.width).isActive = true
        statusCanceled.heightAnchor.constraint(equalToConstant: statusCanceled.frame.height).isActive = true
        
        statusFailed.translatesAutoresizingMaskIntoConstraints = false
        statusFailed.topAnchor.constraint(equalTo: statusDelivered.bottomAnchor, constant: 10).isActive = true
        statusFailed.leadingAnchor.constraint(equalTo: statusCanceled.trailingAnchor, constant: 10).isActive = true
        statusFailed.widthAnchor.constraint(equalToConstant: statusFailed.frame.width).isActive = true
        statusFailed.heightAnchor.constraint(equalToConstant: statusFailed.frame.height).isActive = true
        
        tabCustomLabel.translatesAutoresizingMaskIntoConstraints = false
        tabCustomLabel.topAnchor.constraint(equalTo: tabCanceledLabel.bottomAnchor, constant: 10).isActive = true
        tabCustomLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        
        customChip.translatesAutoresizingMaskIntoConstraints = false
        customChip.topAnchor.constraint(equalTo: statusCanceled.bottomAnchor, constant: 10).isActive = true
        customChip.leadingAnchor.constraint(equalTo: tabCustomLabel.trailingAnchor, constant: 10).isActive = true
        customChip.widthAnchor.constraint(equalToConstant: customChip.frame.width).isActive = true
        customChip.heightAnchor.constraint(equalToConstant: customChip.frame.height).isActive = true
        
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
