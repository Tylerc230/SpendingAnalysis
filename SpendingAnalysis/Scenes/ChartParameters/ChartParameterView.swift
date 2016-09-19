//
//  ChartParameterView.swift
//  SpendingAnalysis
//
//  Created by Tyler Casselman on 9/16/16.
//  Copyright © 2016 13bit consulting. All rights reserved.
//
import UIKit
import RxSwift
import RxCocoa

class ChartParameterView: UIView {
    @IBOutlet private var closeButton: UIButton!
    @IBOutlet private var tableView: UITableView!
    let chartParameters = PublishSubject<[String]>()
    
    let dispose = DisposeBag()
    override func awakeFromNib() {
        super.awakeFromNib()
        registerCells()
        setupTableView(chartParameters)
    }
    
    var closeTapped: Observable<Void> {
        return closeButton.rx_tap.asObservable()
    }
    
    private func setupTableView(params: Observable<[String]>) {
        params
            .bindTo(tableView.rx_itemsWithCellFactory) { (tableView, row, parameter) in
                let cell: UITableViewCell
                switch row {
                case 0:
                    let dateRangeCell = tableView.dequeueReusableCellWithIdentifier("DateRangeCell") as! ExpandableTableViewCell<DateRangeSelectionView>
                    dateRangeCell.expandableView.selectedDateRange = parameter
                    
                    cell = dateRangeCell
                case 1:
                    let transactionTypeCell = tableView.dequeueReusableCellWithIdentifier("TransactionTypeCell") as! ExpandableTableViewCell<DateRangeSelectionView>
                    transactionTypeCell.expandableView.selectedDateRange = parameter
                    cell = transactionTypeCell
                    
                default:
                    fatalError()
                }
                return cell
                
            }
            .addDisposableTo(dispose)
    }
    
    private func registerCells() {
        tableView.registerClass(ExpandableTableViewCell<DateRangeSelectionView>.self, forCellReuseIdentifier: "DateRangeCell")
        tableView.registerClass(ExpandableTableViewCell<DateRangeSelectionView>.self, forCellReuseIdentifier: "TransactionTypeCell")
    }
}
