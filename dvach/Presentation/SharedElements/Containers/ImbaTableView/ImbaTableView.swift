//
//  ImbaTableView.swift
//  Receipt
//
//  Created by Kirill Solovyov on 23.03.2018.
//  Copyright © 2018 Kirill Solovyov. All rights reserved.
//

import Foundation
import UIKit

struct ImbaTableViewConfigurator {
    var separatorColor = UIColor.gray
    var separatorStyle: UITableViewCell.SeparatorStyle = .none
    var leftSeparatorInset: CGFloat = 0
    var rightSeparatorInset: CGFloat = 0
    var rowHeight: CGFloat = UITableView.automaticDimension
}

final class ImbaTableView<Cell>: UIViewController, UITableViewDataSource, UITableViewDelegate
where Cell: UITableViewCell, Cell: ConfigurableView {
    
    // Public configuration
    
    /// Обработка выбора ячейки
    var selectActionBlock: ((_ datasourceIndex: Int) -> Void)? {
        didSet {
            updateSelecionEnabled()
        }
    }
    
    // UI
    @IBOutlet weak var viewHeightConstraint: NSLayoutConstraint?
    @IBOutlet weak var tableViewBottomConstraint: NSLayoutConstraint?
    @IBOutlet weak var tableView: UITableView!
    
    // Models
    private var configurator = ImbaTableViewConfigurator()
    var dataSource: [Cell.ConfigurationModel] = [] {
        didSet {
            tableView?.reloadData()
        }
    }
    
    // MARK: - Initialization
    
    convenience init() {
        self.init(nibName: "ImbaTableView", bundle: nil)
    }
    
    deinit {
        tableView?.removeObserver(self, forKeyPath: "contentSize")
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        
        configureTableView()
        updateSelecionEnabled()
        configure(with: self.configurator)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    // MARK: - Public API
    
    func configure(with configurator: ImbaTableViewConfigurator) {
        self.configurator = configurator
        
        tableView?.separatorStyle = configurator.separatorStyle
        tableView?.separatorColor = self.configurator.separatorColor
    }
    
    func setup(dataSource: [Cell.ConfigurationModel]) {
        self.dataSource = dataSource
    }
    
    // MARK: - KVO
    
    override func observeValue(forKeyPath keyPath: String?,
                               of object: Any?,
                               change: [NSKeyValueChangeKey: Any]?,
                               context: UnsafeMutableRawPointer?) {
        guard let obj = object as? NSObject, let path = keyPath else {
            return
        }
        
        if obj == tableView && path == "contentSize" {
            let newHeight = tableView.contentSize.height
            viewHeightConstraint?.constant = newHeight
        }
    }
    
    // MARK: - Private API
    
    private func configureTableView() {
        // Auto-layout
        tableView.configureAutomaticDimensions(estimatedRowHeight: CGFloat.defaultRowHeight)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        // Cells
        tableView.register(Cell.self)
        
        // подписываемся на изменение контентсайза через KVO
        tableView.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.new, context: nil)
        
        // скрываем нижний сепаратор
        tableViewBottomConstraint?.constant = .borderWidth
    }
    
    private func updateSelecionEnabled() {
        tableView?.allowsSelection = (selectActionBlock != nil)
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: Cell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        cell.backgroundColor = .clear
        cell.configure(with: dataSource[indexPath.row])
        cell.separatorInset = UIEdgeInsets(top: 0, left: configurator.leftSeparatorInset, bottom: 0, right: configurator.rightSeparatorInset)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return configurator.rowHeight
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectActionBlock?(indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
