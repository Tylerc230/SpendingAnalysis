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
import RxSugar

class ChartParameterView: UIView {
    @IBOutlet private var closeButton: UIButton!
    @IBOutlet private var tableView: UITableView!
    let chartParameters = PublishSubject<[String]>()
    let expandedRows = PublishSubject<[Bool]>()
    var expansionUpdate: Observable<[Bool]> = Observable.never()
    
    let dispose = DisposeBag()
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        expansionUpdate = Observable.create{ observer in
            return self.expandedRows.subscribe{ (event) in
                self.tableView.beginUpdates()
                observer.on(event)
                self.tableView.endUpdates()
            }
            }
            .shareReplay(1)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        registerCells()
        setupTableView(chartParameters)
    }
    
    var closeTapped: Observable<Void> {
        return closeButton.rx_tap.asObservable()
    }
    
    var rowSelected: Observable<Int> {
        return tableView.rx_itemSelected.asObservable().map { $0.row }
    }
    
    private func setupTableView(params: Observable<[String]>) {
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 30.0
        params
            .bindTo(tableView.rx_itemsWithCellFactory) { [unowned self] (tableView, row, parameter) in
                let cell: UITableViewCell
                switch row {
                case 0:
                    let dateRangeCell = tableView.dequeueReusableCellWithIdentifier("DateRangeCell") as! ExpandableTableViewCell<DateRangeSelectionView>
                    dateRangeCell.expandableView.selectedDateRange = parameter
                    self.addExpansionObservable(dateRangeCell, row: row)
                    cell = dateRangeCell
                case 1:
                    let transactionTypeCell = tableView.dequeueReusableCellWithIdentifier("TransactionTypeCell") as! ExpandableTableViewCell<DateRangeSelectionView>
                    transactionTypeCell.expandableView.selectedDateRange = parameter
                    self.addExpansionObservable(transactionTypeCell, row: row)
                    cell = transactionTypeCell
                default:
                    fatalError()
                }
                cell.selectionStyle = .None
                return cell
                
            }
            .addDisposableTo(dispose)
    }

    private func addExpansionObservable<T: ExpandableViewType> (cell: ExpandableTableViewCell<T>, row: Int) {
        self.dispose
            ++ cell.expandableView.expandedObserver <~ self.expansionUpdate.map { $0[row] }.takeUntil(cell.prepareForReuseObservable).debug("Expansion tapped")
    }
    
    
    private func registerCells() {
        tableView.registerClass(ExpandableTableViewCell<DateRangeSelectionView>.self, forCellReuseIdentifier: "DateRangeCell")
        tableView.registerClass(ExpandableTableViewCell<DateRangeSelectionView>.self, forCellReuseIdentifier: "TransactionTypeCell")
    }
}
