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
    let chartParameters = PublishSubject<[ChartParameter]>()
    let expandedRows = PublishSubject<[Bool]>()
    var expansionUpdate: Observable<[Bool]> = Observable.never()
    
    let dateRangeSelection = PublishSubject<CommonChartParameters.DateRangeParameter>()
    let selectedDateRangeString = PublishSubject<String>()
    
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
        setupTableView()
    }
    
    var closeTapped: Observable<Void> {
        return closeButton.rx_tap.asObservable()
    }
    
    var rowSelected: Observable<Int> {
        return tableView.rx_itemSelected.asObservable().map { $0.row }
    }
    
    var parameterValues: Observable<CommonChartParameters> {
        return dateRangeSelection.map { range in
            return CommonChartParameters(dateRange: range, transactionTypes: [])
        }
    }
    
    private func setupTableView() {
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 30.0
        chartParameters
            .bindTo(tableView.rx_itemsWithCellFactory) { [unowned self] (tableView, row, parameter) in
                let cell: UITableViewCell
                switch parameter {
                case .dateRange:
                    let dateRangeCell = tableView.dequeueReusableCellWithIdentifier("DateRangeCell") as! ExpandableTableViewCell<DateRangeSelectionView>
                    self.addExpansionObservable(dateRangeCell, row: row)
                    let dateRangeView = dateRangeCell.expandableView
                    dateRangeCell.disposeBag
                        ++ self.dateRangeSelection <~ dateRangeView.dateRange
                        ++ dateRangeView.selectedDateRangeString <~ self.selectedDateRangeString
                    cell = dateRangeCell
                case .transactionTypes:
                    let transactionTypeCell = tableView.dequeueReusableCellWithIdentifier("TransactionTypeCell") as! ExpandableTableViewCell<DateRangeSelectionView>
                    self.addExpansionObservable(transactionTypeCell, row: row)
                    cell = transactionTypeCell
                }
                cell.selectionStyle = .None
                return cell
                
            }
            .addDisposableTo(dispose)
    }

    private func addExpansionObservable<T: ExpandableViewType> (cell: ExpandableTableViewCell<T>, row: Int) {
        self.dispose
            ++ cell.expandableView.expandedObserver <~ self.expansionUpdate
                .map { $0[row] }
                .takeUntil(cell.prepareForReuseObservable)
    }
    
    
    private func registerCells() {
        tableView.registerClass(ExpandableTableViewCell<DateRangeSelectionView>.self, forCellReuseIdentifier: "DateRangeCell")
        tableView.registerClass(ExpandableTableViewCell<DateRangeSelectionView>.self, forCellReuseIdentifier: "TransactionTypeCell")
    }
}
