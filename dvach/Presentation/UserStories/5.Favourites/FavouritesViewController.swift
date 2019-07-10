//
//  FavouritesViewController.swift
//  dvach
//
//  Created by Kirill Solovyov on 12/06/2019.
//  Copyright © 2019 Kirill Solovyov. All rights reserved.
//

import Foundation

protocol FavouritesView: AnyObject {
    
}

final class FavouritesViewController: UIViewController {
    
    // Dependencies
    private let presenter: IFavouritesPresenter
    
    // Properties
    private var previousChildControllerIndex = 0
    
    // UI
    private lazy var segmentControll: UISegmentedControl = {
        let segment = UISegmentedControl()
        segment.addTarget(self, action: #selector(segmentedControlDidChangeValue), for: .valueChanged)
        segment.insertSegment(withTitle: "Доски", at: 0, animated: false)
        segment.insertSegment(withTitle: "Треды", at: 1, animated: false)
        segment.insertSegment(withTitle: "Посты", at: 2, animated: false)
        segment.selectedSegmentIndex = 0
        segment.tintColor = .n7Blue
        
        return segment
    }()
    private lazy var containerView = UIView()
    private lazy var childControllers: [UIViewController] = {
        return [FavouriteBoardsViewController(),
                FavouriteThreadsViewController(),
                FavouritePostsViewController()]
    }()
    
    // MARK: - Initialization
    
    init() {
        let presenter = FavouritesPresenter()
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
        
        presenter.view = self
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        changeChildController(childControllers.first)
        presenter.viewDidLoad()
    }
    
    // MARK: - Private
    
    private func setupUI() {
        view.backgroundColor = .white
        extendedLayoutIncludesOpaqueBars = true
        
        view.addSubview(segmentControll)
        segmentControll.snp.makeConstraints {
            $0.top.equalToSuperview().inset(CGFloat.inset8)
            $0.trailing.leading.equalToSuperview().inset(CGFloat.inset16)
        }
        
        view.addSubview(containerView)
        containerView.snp.makeConstraints {
            $0.top.equalTo(segmentControll.snp.bottom).offset(CGFloat.inset8)
            $0.bottom.leading.trailing.equalToSuperview()
        }
    }
    
    private func changeChildController(_ viewController: UIViewController?) {
        guard let vc = viewController,
            let previousController = childControllers[safeIndex: previousChildControllerIndex] else { return }
        
        // Ремув предыдущего
        containerView.subviews.forEach { $0.removeFromSuperview() }
        previousController.willMove(toParent: nil)
        previousController.removeFromParent()
        
        // Добавление следующего
        addChild(vc)
        containerView.addSubview(vc.view)
        vc.view.snp.makeConstraints { $0.edges.equalToSuperview() }
        vc.didMove(toParent: self)
    }
    
    // MARK: - Actions
    
    @objc private func segmentedControlDidChangeValue(_ segmentedControll: UISegmentedControl) {
        let viewController = childControllers[safeIndex: segmentedControll.selectedSegmentIndex]
        changeChildController(viewController)
        previousChildControllerIndex = segmentedControll.selectedSegmentIndex
    }
}

// MARK: - FavouritesView

extension FavouritesViewController: FavouritesView {
    
}
