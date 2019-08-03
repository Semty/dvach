//
//  EULAViewController.swift
//  dvach
//
//  Created by Kirill Solovyov on 03/08/2019.
//  Copyright © 2019 Kirill Solovyov. All rights reserved.
//

import Foundation

private extension String {
    static let eula = """
Definitions
    
    In this EULA the expressions below shall have the meaning assigned to them in this clause, unless the context requires otherwise:
    
    “Activate” turning the Trial version into the Full version of the same application with the License Key provided by Sketch;
    “Contributor” You when You are assigned the role of contributor via the Sketch collaboration tool Sketch for Teams;
    “Contributor version” the license to Use the Sketch Mac App for the term that You qualify as a Contributor;
    “Documentation” the detailed information about the Sketch Mac App, its features and the system requirements as made available on the website of Sketch, as amended from time to time;
    “Full version” the license for the Sketch Mac App for the term specified on the webpage of the store where You purchase the license, or in any applicable agreement concerning the purchase of the license (as stand-alone product or as part of a subscription) to Use the Sketch Mac App;
    “License Key” an unique code provided by Sketch, which enables You to activate the Trial version, Full version or Contributor version by entering the code into the Sketch Mac App and to subsequently use the Sketch Mac App during the applicable license term;
    “Open Source Software” any software that requires as a condition of use, copying, modification and/or distribution of such software that such software or other software incorporated into, derived from or distributed with such software (a) be disclosed or distributed in source code form, and (b) be licensed for the purpose of making and/or distributing derivative works, and (c) be redistributable at no charge;
    “Sketch” Sketch B.V., Flight Forum 40, Ground floor, 5657 DB Eindhoven, the Netherlands with chamber of commerce registration number 60360461 and VAT number NL8538.75.273.B01;
    “Sketch Mac App” any software application and/or all of the contents of the files and/or other media, including software setup files, licensed to You by Sketch, including any Updates;
    “Trial version” the license for the Sketch Mac App for the term of 30 days to Use the Sketch Mac App for the sole purpose of testing and evaluating the Sketch Mac App;
    “Updates” any modified versions and updates of, and additions to the Sketch Mac App (excluding upgrades of the Sketch Mac App);
    “Use” the access, download, install, copy or get benefit from using the Sketch Mac App in accordance with the documentation;
    “You” you, the final and ultimate user of the Sketch Mac App or the authorized representative of a company or other legal entity that will be the final and ultimate user of the Sketch Mac App, and the company or other legal entity that will be the final and ultimate user of the Sketch Mac App, if applicable.
"""
}

final class EULAViewController: UIViewController {
    
    // Dependencies
    private let componentsFactory = Locator.shared.componentsFactory()
    
    // UI
    private lazy var closeButton = componentsFactory.createCloseButton(style: .dismiss, imageColor: nil, backgroundColor: nil) { [weak self] in
        self?.dismiss(animated: true, completion: nil)
    }
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemWith(size: 20)
        label.text = "License agreement"
        label.textColor = .n1Gray
        label.textAlignment = .center
        
        return label
    }()
    private lazy var textView: UITextView = {
        let textView = UITextView()
        textView.text = .eula
        textView.textColor = .n1Gray
        
        return textView
    }()
    
    override var prefersStatusBarHidden: Bool {
        hideStatusBar(true, animation: true)
        return false
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()
        titleLabel.snp.updateConstraints { $0.top.equalToSuperview().inset(CGFloat.inset16 + view.safeAreaInsets.top)}
    }
    
    // MARK: - Private
    
    private func setupUI() {
        view.backgroundColor = .white
        
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(CGFloat.inset16)
            $0.trailing.leading.equalToSuperview()
        }
        
        view.addSubview(textView)
        textView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(CGFloat.inset20)
            $0.leading.trailing.equalToSuperview().inset(CGFloat.inset16)
            $0.bottom.equalToSuperview()
        }
        
        view.addSubview(closeButton)
        closeButton.snp.makeConstraints { $0.top.trailing.equalToSuperview().inset(CGFloat.inset16) }
    }
}
