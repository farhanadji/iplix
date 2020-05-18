//
//  SlidingTabController.swift
//  iplix
//
//  Created by Farhan Adji on 14/05/20.
//  Copyright © 2020 Farhan Adji. All rights reserved.
//

import UIKit

class SlidingTabController: UIViewController {
    enum SlidingTabStyle: String {
        case fixed
        case flexible
    }
    private let collectionHeader = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout.init())
    private let collectionPage = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout.init())
    private let collectionHeaderIdentifier = "COLLECTION_HEADER_IDENTIFIER"
    private let collectionPageIdentifier = "COLLECTION_PAGE_IDENTIFIER"
    private var items = [UIViewController]()
    private var titles = [String]()
    private var colorHeaderActive = UIColor.blue
    private var colorHeaderInActive = UIColor.gray
    private var colorHeaderBackground = UIColor.white
    private var currentPosition = 0
    private var tabStyle = SlidingTabStyle.fixed
    private let heightHeader = 50
    
    func addItem(item: UIViewController, title: String){
        items.append(item)
        titles.append(title)
    }
    
    func setHeaderBackgroundColor(color: UIColor){
        colorHeaderBackground = color
    }
    
    func setHeaderActiveColor(color: UIColor){
        colorHeaderActive = color
    }
    
    func setHeaderInActiveColor(color: UIColor){
        colorHeaderInActive = color
    }
    
    func setCurrentPosition(position: Int){
        currentPosition = position
        let path = IndexPath(item: currentPosition, section: 0)
        
        DispatchQueue.main.async {
            if self.tabStyle == .flexible {
                self.collectionHeader.scrollToItem(at: path, at: .centeredHorizontally, animated: true)
            }
            
            self.collectionHeader.reloadData()
        }
        
        DispatchQueue.main.async {
            self.collectionPage.scrollToItem(at: path, at: .centeredHorizontally, animated: true)
        }
    }
    
    func setStyle(style: SlidingTabStyle){
        tabStyle = style
    }
    
    func build(){
        // view
        view.addSubview(collectionHeader)
        view.addSubview(collectionPage)
        
        // collectionHeader
        collectionHeader.translatesAutoresizingMaskIntoConstraints = false
        collectionHeader.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        collectionHeader.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionHeader.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collectionHeader.heightAnchor.constraint(equalToConstant: CGFloat(heightHeader)).isActive = true
        (collectionHeader.collectionViewLayout as? UICollectionViewFlowLayout)?.scrollDirection = .horizontal
        collectionHeader.showsHorizontalScrollIndicator = false
        collectionHeader.backgroundColor = colorHeaderBackground
        collectionHeader.register(HeaderCell.self, forCellWithReuseIdentifier: collectionHeaderIdentifier)
        collectionHeader.delegate = self
        collectionHeader.dataSource = self
        collectionHeader.reloadData()
        collectionHeader.layer.borderColor = UIColor.systemGray4.cgColor
        collectionHeader.layer.borderWidth = 1.0
        
        // collectionPage
        collectionPage.translatesAutoresizingMaskIntoConstraints = false
        collectionPage.topAnchor.constraint(equalTo: collectionHeader.bottomAnchor).isActive = true
        collectionPage.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        collectionPage.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionPage.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collectionPage.backgroundColor = .white
        collectionPage.showsHorizontalScrollIndicator = false
        (collectionPage.collectionViewLayout as? UICollectionViewFlowLayout)?.scrollDirection = .horizontal
        collectionPage.isPagingEnabled = true
        collectionPage.register(UICollectionViewCell.self, forCellWithReuseIdentifier: collectionPageIdentifier)
        collectionPage.delegate = self
        collectionPage.dataSource = self
        collectionPage.reloadData()
        collectionPage.contentInsetAdjustmentBehavior = .never
        
    }
    
    private class HeaderCell: UICollectionViewCell {
        
        private let label = UILabel()
        private let indicator = UIView()
//        private let parentView = UIView()
//        private let countView = UIView()
//        private let countLabel = UILabel()
        
        var text: String! {
            didSet {
                label.text = text
            }
        }
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            setupUI()
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func select(didSelect: Bool, activeColor: UIColor, inActiveColor: UIColor){
            indicator.backgroundColor = activeColor
            if didSelect {
                label.textColor = activeColor
                indicator.isHidden = false
            }else{
                label.textColor = inActiveColor
                indicator.isHidden = true
            }
        }
        
        private func setupUI(){
            // view
            self.addSubview(label)
            self.addSubview(indicator)
       
            // label
            label.translatesAutoresizingMaskIntoConstraints = false
            label.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
            label.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
            label.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
            label.font = UIFont.systemFont(ofSize: 17.0)
            
            // indicator
            indicator.translatesAutoresizingMaskIntoConstraints = false
            indicator.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
            indicator.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
            indicator.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
            indicator.heightAnchor.constraint(equalToConstant: 2).isActive = true
            
//            setupCountUI()
            
        }
//
//        private func setupCountUI() {
////            self.addSubview(countView)
////
////            countView.layer.cornerRadius = countView.frame.height / 2
////            countView.backgroundColor = UIColor.systemGray4
////            countView.translatesAutoresizingMaskIntoConstraints = false
////            countView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
////            countView.leadingAnchor.constraint(equalTo: label.trailingAnchor, constant: 10).isActive = true
////            countView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
////            countView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
//
//            self.addSubview(countLabel)
//            countLabel.translatesAutoresizingMaskIntoConstraints = false
//            countLabel.backgroundColor = .systemGray5
//            countLabel.text = "10"
//            countLabel.textColor = .systemGray
//            countLabel.font = UIFont.systemFont(ofSize: 15.0)
//            countLabel.leadingAnchor.constraint(equalTo: label.trailingAnchor, constant: 10).isActive = true
//            countLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
//            countLabel.layer.cornerRadius = 10
////            countLabel.sizeToFit()
//            print(countLabel.frame)
//        }
        
    }
    
}

extension SlidingTabController: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        setCurrentPosition(position: indexPath.row)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == collectionPage{
            let currentIndex = Int(self.collectionPage.contentOffset.x / collectionPage.frame.size.width)
            setCurrentPosition(position: currentIndex)
        }
    }
}

extension SlidingTabController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collectionHeader {
            return titles.count
        }
        
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == collectionHeader {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionHeaderIdentifier, for: indexPath) as! HeaderCell
            cell.text = titles[indexPath.row]
//            cell.count = "0"
            
            var didSelect = false
            
            if currentPosition == indexPath.row {
                didSelect = true
            }
            
            cell.select(didSelect: didSelect, activeColor: colorHeaderActive, inActiveColor: colorHeaderInActive)
            
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionPageIdentifier, for: indexPath)
        let vc = items[indexPath.row]
        cell.addSubview(vc.view)
        
        vc.view.translatesAutoresizingMaskIntoConstraints = false
        vc.view.topAnchor.constraint(equalTo: cell.topAnchor, constant: 28).isActive = true
        vc.view.leadingAnchor.constraint(equalTo: cell.leadingAnchor).isActive = true
        vc.view.trailingAnchor.constraint(equalTo: cell.trailingAnchor).isActive = true
        vc.view.bottomAnchor.constraint(equalTo: cell.bottomAnchor).isActive = true
        
        return cell
    }
}

extension SlidingTabController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == collectionHeader {
            if tabStyle == .fixed {
                let spacer = CGFloat(titles.count)
                return CGSize(width: view.frame.width / spacer, height: CGFloat(heightHeader))
            }else{
                let label = UILabel(frame: CGRect.zero)
                label.text = titles[indexPath.row]
                label.sizeToFit()
                (collectionHeader.collectionViewLayout as? UICollectionViewFlowLayout)?.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
                return CGSize(width: label.frame.width + 20, height: CGFloat(heightHeader))
            }
        }
        
        return CGSize(width: view.frame.width, height: view.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == collectionHeader {
            return 10
        }
        
        return 0
    }
    
    
}

