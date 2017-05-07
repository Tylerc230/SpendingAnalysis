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
    @IBOutlet fileprivate var closeButton: UIButton!
    @IBOutlet fileprivate var tableView: UITableView!
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
        return closeButton.rx.tap.asObservable()
    }
    
    var rowSelected: Observable<Int> {
        return tableView.rx.itemSelected.asObservable().map { $0.row }
    }
    
    var parameterValues: Observable<CommonChartParameters> {
        return dateRangeSelection.map { range in
            return CommonChartParameters(dateRange: range, transactionTypes: [])
        }
    }
    
    fileprivate func setupTableView() {
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 30.0
        Observable.just([ChartParameter.dateRange, ChartParameter.transactionTypes])
            .bindTo(tableView.rx.items) { [unowned self] (tableView, row, parameter) in
                let cell: UITableViewCell
                switch parameter {
                case .dateRange:
                    let dateRangeCell = tableView.dequeueReusableCell(withIdentifier: "DateRangeCell") as! ExpandableTableViewCell<DateRangeSelectionView>
                    self.addExpansionObservable(dateRangeCell, row: row)
                    let dateRangeView = dateRangeCell.expandableView
                    dateRangeCell.disposeBag
                        ++ self.dateRangeSelection <~ dateRangeView.dateRange
                        ++ dateRangeView.selectedDateRangeString <~ self.selectedDateRangeString.map { Optional.some($0) }
                    cell = dateRangeCell
                case .transactionTypes:
                    let transactionTypeCell = tableView.dequeueReusableCell(withIdentifier: "TransactionTypeCell") as! ExpandableTableViewCell<DateRangeSelectionView>
                    self.addExpansionObservable(transactionTypeCell, row: row)
                    cell = transactionTypeCell
                }
                cell.selectionStyle = .none
                return cell
                
            }
            .addDisposableTo(dispose)
    }

    fileprivate func addExpansionObservable<T: ExpandableViewType> (_ cell: ExpandableTableViewCell<T>, row: Int) {
        self.dispose
            ++ cell.expandableView.expandedObserver <~ self.expansionUpdate
                .map { $0[row] }
                .takeUntil(cell.prepareForReuseObservable)
    }
    
    
    fileprivate func registerCells() {
        tableView.register(ExpandableTableViewCell<DateRangeSelectionView>.self, forCellReuseIdentifier: "DateRangeCell")
        tableView.register(ExpandableTableViewCell<DateRangeSelectionView>.self, forCellReuseIdentifier: "TransactionTypeCell")
    }
}
