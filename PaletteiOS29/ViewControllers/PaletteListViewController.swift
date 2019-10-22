//
//  PaletteListViewController.swift
//  PaletteiOS29
//
//  Created by Bethany Wride on 10/22/19.
//  Copyright © 2019 Darin Armstrong. All rights reserved.
//

import UIKit

// Declare views, add subviews to superview, constrain our views

class PaletteListViewController: UIViewController {
// MARK: - Properties
    // Could include subview elements here
    var safeArea: UILayoutGuide {
        return self.view.safeAreaLayoutGuide
    }
    
    var buttons: [UIButton] {
        return [featuredButton, doubleRainbowButton, randomButton]
    }
    
    var photos: [UnsplashPhoto] = []
    
// MARK: - Life Cycle
    override func loadView() {
        super.loadView()
        addAllSubviews()
        setUpStackView()
        constrainViews()
        activateButtons()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        searchForCategory(.featured)
        selectButton(featuredButton)
    }

// MARK: - Subview Elements
    let featuredButton: UIButton = {
        let button = UIButton()
        button.setTitle("Featured", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.contentHorizontalAlignment = .center
        return button
    }()
    
    let doubleRainbowButton: UIButton = {
        let button = UIButton()
        button.setTitle("Double Rainbow", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.contentHorizontalAlignment = .center
        return button
    }()

    let randomButton: UIButton = {
        let button = UIButton()
        button.setTitle("Random", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.contentHorizontalAlignment = .center
        return button
    }()
    
    // Stack View
    let buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalCentering
        stackView.alignment = .fill
        return stackView
    }()
    
    let paletteTableView = UITableView()
    
// MARK: - Subview Methods
    // Add subviews to view hierarchy
    func addAllSubviews() {
        self.view.addSubview(featuredButton)
        self.view.addSubview(doubleRainbowButton)
        self.view.addSubview(randomButton)
        self.view.addSubview(buttonStackView)
        self.view.addSubview(paletteTableView)
    }
    
    // Added to stack view
    func setUpStackView() {
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        buttonStackView.addArrangedSubview(featuredButton)
        buttonStackView.addArrangedSubview(doubleRainbowButton)
        buttonStackView.addArrangedSubview(randomButton)
    }
    
    func configureTableView() {
        paletteTableView.delegate = self
        paletteTableView.dataSource = self
        paletteTableView.register(PaletteTableViewCell.self, forCellReuseIdentifier: "paletteCell")
        paletteTableView.allowsSelection = false
    }
    
// MARK: - Constrain Subviews
    // Trailing is negative
    func constrainViews() {
        paletteTableView.anchor(top: buttonStackView.bottomAnchor, bottom: self.safeArea.bottomAnchor, leading: self.safeArea.leadingAnchor, trailing: self.safeArea.trailingAnchor, topPadding: buttonStackView.frame.height/2, bottomPadding: 0, leadingPadding: 0, trailingPadding: 0)
        
        // Button has intrinsic size so no need to bottom anchor
        buttonStackView.anchor(top: self.safeArea.topAnchor, bottom: nil, leading: self.safeArea.leadingAnchor, trailing: self.safeArea.trailingAnchor, topPadding: 0, bottomPadding: 0, leadingPadding: 8, trailingPadding: 8)
    }
    
// MARK: - IBActions
    func activateButtons() {
        buttons.forEach{$0.addTarget(self, action: #selector(searchButtonTapped(sender:)), for: .touchUpInside)}
    }
    
    @objc func searchButtonTapped(sender: UIButton) {
        selectButton(sender)
        switch sender {
        case randomButton:
            searchForCategory(.random)
        case doubleRainbowButton:
            searchForCategory(.doubleRainbow)
        case featuredButton:
            searchForCategory(.featured)
        default:
            print("Error, button not found.")
        }
    }
    
    func selectButton(_ button: UIButton) {
        buttons.forEach {$0.setTitleColor(UIColor(named: "offWhite"), for: .normal)}
        button.setTitleColor(UIColor(named: "devMountainBlue"), for: .normal)
    }
    
// MARK: - API Methods
    func searchForCategory(_ route: UnsplashRoute) {
        UnsplashService.shared.fetchFromUnsplash(for: route) { (photos) in
            DispatchQueue.main.async {
                guard let photos = photos else { return }
                self.photos = photos
                self.paletteTableView.reloadData()
            }
        }
    }
}

// MARK: - DataSource and Delegate Extension
extension PaletteListViewController: UITableViewDelegate, UITableViewDataSource {
    // Data Source Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = paletteTableView.dequeueReusableCell(withIdentifier: "paletteCell", for: indexPath) as! PaletteTableViewCell
        let photo = photos[indexPath.row]
        cell.photo = photo
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let imageViewSpace: CGFloat = (view.frame.width - (2 * SpacingConstants.outerHorizontalPadding))
        let textLabelSpace: CGFloat = SpacingConstants.oneLineElementHeight
        let colorPaletteSpace: CGFloat = SpacingConstants.twoLineElementHeight
        let outerVerticalSpacing: CGFloat = 2 * SpacingConstants.outerVerticalPadding
        let innerVerticalSpacing: CGFloat = 4 * SpacingConstants.verticalObjectBuffer
        return imageViewSpace + textLabelSpace + colorPaletteSpace + outerVerticalSpacing + innerVerticalSpacing
    }
}
