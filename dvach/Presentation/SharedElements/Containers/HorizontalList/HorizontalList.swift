//
//  HorizontalList.swift
//  dvach
//
//  Created by Kirill Solovyov on 01/06/2019.
//  Copyright © 2019 Kirill Solovyov. All rights reserved.
//

import Foundation

enum Constants {
    static let cellSize = CGSize(width: 90, height: 130)
    static let collectionHeight: CGFloat = 160
}

struct HorizontalListConfiguration {
    let itemSize: CGSize
    let shadow: Shadow?
    let height: CGFloat
    let itemSpacing: CGFloat
    let insets: UIEdgeInsets // отступы ячеек внутри коллекции
    
    static var `default` = HorizontalListConfiguration(itemSize: Constants.cellSize,
                                                       shadow: .default,
                                                       height: Constants.collectionHeight,
                                                       itemSpacing: .inset8,
                                                       insets: .defaultInsets)
}

final class HorizontalList<Cell>: UIView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate
where Cell: UICollectionViewCell, Cell: ConfigurableView {
    
    // Public properties
    var selectionHandler: ((_ indexPath: IndexPath, _ cells: [UICollectionViewCell?]) -> Void)?
    
    // Private properties
    private let configuration: HorizontalListConfiguration
    private var dataSource = [Cell.ConfigurationModel]()
    
    private var collectionFlowLayout: UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = configuration.itemSize
        layout.scrollDirection = .horizontal
        layout.sectionInset = configuration.insets
        layout.minimumInteritemSpacing = configuration.itemSpacing
        layout.minimumLineSpacing = configuration.itemSpacing
        return layout
    }
    
    // UI
    private lazy var collectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: collectionFlowLayout)
        collection.delegate = self
        collection.dataSource = self
        collection.register(Cell.self)
        collection.backgroundColor = .clear
        collection.allowsMultipleSelection = false
        collection.showsHorizontalScrollIndicator = false
        collection.clipsToBounds = false
        return collection
    }()
    
    private lazy var shadowCollectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: collectionFlowLayout)
        collection.delegate = self
        collection.dataSource = self
        collection.register(ShadowCollectionViewCell.self)
        collection.backgroundColor = .clear
        collection.allowsMultipleSelection = false
        collection.showsHorizontalScrollIndicator = false
        collection.clipsToBounds = false

        return collection
    }()
    
    // MARK: - Initiazation
    
    init(configuration: HorizontalListConfiguration = .default) {
        self.configuration = configuration
        super.init(frame: .zero)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    // MARK: - Public
    
    public func update(dataSource: [Cell.ConfigurationModel]) {
        self.dataSource = dataSource
        collectionView.reloadData()
    }
    
    // MARK: - Private
    
    private func setupUI() {
        backgroundColor = .clear
        addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalTo(configuration.height)
        }
        
        guard configuration.shadow != nil else { return }
        insertSubview(shadowCollectionView, at: 0)
        shadowCollectionView.snp.makeConstraints {
            $0.edges.equalTo(collectionView.snp.edges)
        }
    }
    
    // MARK: - UICollectionViewDataSource, UICollectionViewDelegate

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView === shadowCollectionView {
            let cell: ShadowCollectionViewCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
            let model = ShadowCollectionViewCell.Model(underlyingShadow: nil, shadow: configuration.shadow)
            cell.configure(with: model)
            return cell
        }
        
        let cell: Cell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
        cell.configure(with: dataSource[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var cells: [UICollectionViewCell?] = [UICollectionViewCell]()
        for (index, _) in dataSource.enumerated() {
            cells.append(collectionView.cellForItem(at: IndexPath.init(row: index,
                                                                       section: 0)))
        }
        selectionHandler?(indexPath, cells)
    }
    
    // MARK: - UIScrollViewDelegate
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView === collectionView {
            shadowCollectionView.contentOffset = collectionView.contentOffset
        }
    }
}
