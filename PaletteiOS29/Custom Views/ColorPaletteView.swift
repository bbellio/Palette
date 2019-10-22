//
//  ColorPaletteView.swift
//  PaletteiOS29
//
//  Created by Bethany Wride on 10/22/19.
//  Copyright © 2019 Darin Armstrong. All rights reserved.
//

import UIKit

class ColorPaletteView: UIView {
// MARK: - Properties
    var colors: [UIColor] {
        didSet {
            buildColorBricks()
        }
    }
    
    init(colors: [UIColor] = [], frame: CGRect = .zero) {
        self.colors = colors
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
// MARK: - Life Cycle
    override func layoutSubviews() {
        super.layoutSubviews()
        setUpViews()
    }
    
// MARK: - Subview Elements
    lazy var colorStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        return stackView
    }()
    
// MARK: - Subview Methods
    private func setUpViews() {
        addSubview(colorStackView)
        colorStackView.anchor(top: topAnchor, bottom: bottomAnchor, leading: leadingAnchor, trailing: trailingAnchor, topPadding: 0, bottomPadding: 0, leadingPadding: 0, trailingPadding: 0)
    }
    
    private func generateColorBrick(for color: UIColor) -> UIView {
        let colorBrick = UIView()
        colorBrick.backgroundColor = color
        return colorBrick
    }
    
    private func resetColorBricks() {
        for subview in colorStackView.arrangedSubviews {
            self.colorStackView.removeArrangedSubview(subview)
        }
    }
    
    private func buildColorBricks() {
        resetColorBricks()
        for color in self.colors {
            let colorBrick = generateColorBrick(for: color)
            self.addSubview(colorBrick)
            self.colorStackView.addArrangedSubview(colorBrick)
        }
    }
}
