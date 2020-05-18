//
//  FilterViewController.swift
//  iplix
//
//  Created by Farhan Adji on 11/05/20.
//  Copyright © 2020 Farhan Adji. All rights reserved.
//

import UIKit

protocol FilterDelegate {
    func filterData(selected: FilterViewController.Filtering)
}

class FilterViewController: UIViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var backingImage: UIImageView!
    @IBOutlet weak var dimmerView: UIView!
    @IBOutlet weak var cardViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var handleView: UIView!
    @IBOutlet weak var tableView: UITableView!
    var delegate: FilterDelegate?
    var filterData: [Filter] = []
    
    let filter = ["Popularity", "Release Date", "Revenue", "Title"]
    static var filters: [Filter] = []
    
    static var userFilter: [Filter] = [
        Filter(index: 0, title: "Popularity", check: true),
        Filter(index: 1, title: "Release Date", check: false),
        Filter(index: 2, title: "Revenue", check: false),
        Filter(index: 3, title: "Title", check: false)
    ]
    
    static let defaultFilter: [Filter] = [
        Filter(index: 0, title: "Popularity", check: true),
        Filter(index: 1, title: "Release Date", check: false),
        Filter(index: 2, title: "Revenue", check: false),
        Filter(index: 3, title: "Title", check: false)
    ]
    var isFiltered = false
    
    static var currentSelected = 0
    
    var filterSearch: [Filter] = []
    
    let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.last
    
    enum Filtering {
        case popularity
        case release
        case revenue
        case title
    }
    
    static var filterState: Filtering = .popularity
    
    enum CardViewState {
        case expanded
        case normal
    }
    
    var cardViewState: CardViewState = .normal
    var cardPanStartingTopConstant : CGFloat = 30.0
    
    
    var backgroundImage: UIImage?
    override func viewDidLoad() {
        super.viewDidLoad()
        FilterViewController.filters = FilterViewController.userFilter
        setupTableView()
        searchBar.delegate = self
        handleView.clipsToBounds = true
        handleView.layer.cornerRadius = 3.0
        cardView.clipsToBounds = true
        cardView.layer.cornerRadius = 10.0
        cardView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        backingImage.image = backgroundImage
        
        if let safeAreaHeight = keyWindow?.safeAreaLayoutGuide.layoutFrame.size.height,
            let bottomPadding = keyWindow?.safeAreaInsets.bottom {
            cardViewTopConstraint.constant = safeAreaHeight + bottomPadding
        }
        
        dimmerView.alpha = 0.0
        
        let dimmerTap = UITapGestureRecognizer(target: self, action: #selector(dimmerViewTapped(_:)))
        dimmerView.addGestureRecognizer(dimmerTap)
        dimmerView.isUserInteractionEnabled = true
        
        let viewPan = UIPanGestureRecognizer(target: self, action: #selector(viewPanned(_:)))
        
        viewPan.delaysTouchesBegan = false
        viewPan.delaysTouchesEnded = false
        
        self.view.addGestureRecognizer(viewPan)
    }
    
    private func setupTableView() {
        tableView.register(UINib(nibName: "FilterTableViewCell", bundle: nil), forCellReuseIdentifier: "filterCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isUserInteractionEnabled = true
        //        tableView.allowsSelection = true
        tableView.allowsMultipleSelection = false
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        tableView.selectRow(at: IndexPath(row: FilterViewController.currentSelected, section: 0), animated: true, scrollPosition: UITableView.ScrollPosition(rawValue: 0)!)
    }
    
//    override func viewWillDisappear(_ animated: Bool) {
//        FilterViewController.filters = FilterViewController.defaultFilters
//    }
    
    func setCurrentSelected(selected: Int) {
        FilterViewController.userFilter[FilterViewController.currentSelected].check = false
        FilterViewController.currentSelected = selected
         FilterViewController.userFilter[FilterViewController.currentSelected].check = true
        FilterViewController.filters = FilterViewController.userFilter
        let path = IndexPath(item: FilterViewController.currentSelected, section: 0)
        
        DispatchQueue.main.async {
            self.tableView.selectRow(at: path, animated: true, scrollPosition: UITableView.ScrollPosition(rawValue: 0)!)
        }
        self.tableView.reloadData()
    }
    
    static func resetSelected() {
        FilterViewController.userFilter = FilterViewController.defaultFilter
        FilterViewController.currentSelected = 0
    }
    
    @IBAction func viewPanned(_ panRecognizer: UIPanGestureRecognizer) {
        let translation = panRecognizer.translation(in: self.view)
        
        let velocity = panRecognizer.velocity(in: self.view)
        
        switch panRecognizer.state {
        case .began:
            cardPanStartingTopConstant = cardViewTopConstraint.constant
        case .changed:
            if self.cardPanStartingTopConstant + translation.y > 30.0 {
                self.cardViewTopConstraint.constant = self.cardPanStartingTopConstant + translation.y
            }
            dimmerView.alpha = dimAlphaWithCardTopConstraint(value: self.cardViewTopConstraint.constant)
        case .ended:
            if velocity.y > 1500.0 {
                hideCardAndGoBack()
                return
            }
            
            if let safeAreaHeight = keyWindow?.safeAreaLayoutGuide.layoutFrame.size.height,
                let bottomPadding = keyWindow?.safeAreaInsets.bottom {
                
                if self.cardViewTopConstraint.constant < (safeAreaHeight + bottomPadding) * 0.25 {
                    showCard(atState: .expanded)
                } else if self.cardViewTopConstraint.constant < (safeAreaHeight) - 70 {
                    showCard(atState: .normal)
                } else {
                    hideCardAndGoBack()
                }
            }
        default:
            break
            
        }
        
        print(translation)
    }
    
    @IBAction func dimmerViewTapped(_ tapRecognizer: UITapGestureRecognizer) {
        hideCardAndGoBack()
    }
    
    private func dimAlphaWithCardTopConstraint(value: CGFloat) -> CGFloat {
        let fullDimAlpha : CGFloat = 0.7
        
        guard let safeAreaHeight = keyWindow?.safeAreaLayoutGuide.layoutFrame.size.height,
            let bottomPadding = keyWindow?.safeAreaInsets.bottom else {
                return fullDimAlpha
        }
        
        let fullDimPosition = (safeAreaHeight + bottomPadding) / 2.0
        
        let noDimPosition = safeAreaHeight + bottomPadding
        
        if value < fullDimPosition {
            return fullDimAlpha
        }
        
        if value > noDimPosition {
            return 0.0
        }
        
        return fullDimAlpha * 1 - ((value - fullDimPosition) / fullDimPosition)
    }
    
    private func hideCardAndGoBack() {
        self.view.layoutIfNeeded()
        
        if let safeAreaHeight = keyWindow?.safeAreaLayoutGuide.layoutFrame.size.height,
            let bottomPadding = keyWindow?.safeAreaInsets.bottom {
            
            cardViewTopConstraint.constant = safeAreaHeight + bottomPadding
        }
        
        let hideCard = UIViewPropertyAnimator(duration: 0.25, curve: .easeIn, animations: {
            self.view.layoutIfNeeded()
        })
        
        hideCard.addAnimations {
            self.dimmerView.alpha = 0.0
        }
        
        hideCard.addCompletion({ position in
            if position == .end {
                if(self.presentingViewController != nil) {
                    self.dismiss(animated: false, completion: nil)
                }
            }
        })
        
        hideCard.startAnimation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showCard()
    }
    
    private func showCard(atState: CardViewState = .normal) {
        self.view.layoutIfNeeded()
        
        if let safeAreaHeight = keyWindow?.safeAreaLayoutGuide.layoutFrame.size.height,
            let bottomPadding = keyWindow?.safeAreaInsets.bottom {
            
            if atState == .expanded {
                cardViewTopConstraint.constant = 30.0
                tableView.isScrollEnabled = true
            } else {
                cardViewTopConstraint.constant = (safeAreaHeight + bottomPadding) / 2.0
                tableView.isScrollEnabled = false
            }
        }
        
        let showCard = UIViewPropertyAnimator(duration: 0.25, curve: .easeIn, animations: {
            self.view.layoutIfNeeded()
        })
        
        showCard.addAnimations({
            self.dimmerView.alpha = 0.7
        })
        
        showCard.startAnimation()
    }
    
}

extension UIView {
    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { (rendererContext) in
            layer.render(in: rendererContext.cgContext)
        }
    }
}


extension FilterViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        FilterViewController.filters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "filterCell", for: indexPath) as! FilterTableViewCell
        cell.filterLabel.text = FilterViewController.filters[indexPath.row].title
        
        if FilterViewController.filters[indexPath.row].check {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
            
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //        tableView.deselectRow(at: indexPath, animated: true)
        print("did select = \(indexPath.row)")
        let idx = indexPath.row
        
//        if isFiltered {
//            print(filterSearch)
//            print("index filter : \(self.filterSearch[idx].index)")
//            FilterViewController.defaultFilters[self.filterSearch[idx].index].check = true
//            FilterViewController.defaultFilters[FilterViewController.indexSelected].check = false
//            FilterViewController.filters = FilterViewController.defaultFilters
//            //            FilterViewController.filters[self.filterSearch[idx].index].check = true
//        } else {
//            FilterViewController.filters[idx].check = true
//            FilterViewController.defaultFilters[idx].check = true
//            FilterViewController.defaultFilters[FilterViewController.indexSelected].check = false
////            FilterViewController.filters = FilterViewController.defaultFilters
//        }
        let indexSelected = FilterViewController.filters[idx].index
        setCurrentSelected(selected: indexSelected)
//        FilterViewController.indexSelected = FilterViewController.filters[indexPath.row].index
        switch indexSelected {
        case 0:
            FilterViewController.filterState = .popularity
        case 1:
            FilterViewController.filterState = .release
        case 2:
            FilterViewController.filterState = .revenue
        case 3:
            FilterViewController.filterState = .title
        default:
            break
        }
        //        DispatchQueue.main.async {
        //            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        //            self.tableView.reloadData()
        self.hideCardAndGoBack()
        self.delegate?.filterData(selected: FilterViewController.filterState)
        //        }
        
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
//        let cell = tableView.cellForRow(at: indexPath) as! FilterTableViewCell
//        let idx = indexPath.row
//        cell.accessoryType = .none
//        FilterViewController.defaultFilters[idx].check = false
//        FilterViewController.filters = FilterViewController.defaultFilters
//        print(FilterViewController.defaultFilters[idx])
//        //        }
//        print("did deselect = \(indexPath.row)")
    }
}

extension FilterViewController: UISearchBarDelegate {
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        print("end editing")
        print(searchBar.text!)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        showCard(atState: .expanded)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchFilter(query: searchText)
    }
    
    func searchFilter(query: String) {
        if query.isEmpty {
            FilterViewController.filters = FilterViewController.userFilter
            self.isFiltered = false
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } else {
            self.isFiltered = true
            filterSearch = FilterViewController.userFilter.filter{
                $0.title.contains(query)
            }
            print(filterSearch)
            FilterViewController.filters = filterSearch
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}
