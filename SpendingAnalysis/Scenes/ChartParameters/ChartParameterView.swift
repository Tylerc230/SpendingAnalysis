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
    let chartParameters = PublishSubject<CommonChartParameters>()
    let dispose = DisposeBag()
    override func awakeFromNib() {
        super.awakeFromNib()
        setupTableView()
    }
    
    var closeTapped: Observable<Void> {
        return closeButton.rx_tap.asObservable()
    }
    
    func setupTableView() {
        let params = Observable<CommonChartParameters>.just(CommonChartParameters(dateRange: .years(1), transactionTypes: []))
        params
            .map { [$0.dateRange as Any, $0.transactionTypes as Any] }
            .bindTo(tableView.rx_itemsWithCellIdentifier("Cell", cellType: UITableViewCell.self)) { (rowIndex, parameter, cell) in
            let cellTitle = "\(parameter)"
            cell.textLabel?.text = cellTitle
                
        }
        .addDisposableTo(dispose)
    }
}
