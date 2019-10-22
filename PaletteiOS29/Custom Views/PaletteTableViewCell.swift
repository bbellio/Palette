//
//  PaletteTableViewCell.swift
//  PaletteiOS29
//
//  Created by Bethany Wride on 10/22/19.
//  Copyright © 2019 Darin Armstrong. All rights reserved.
//

import UIKit

class PaletteTableViewCell: UITableViewCell {
// MARK: - Properties
    var photo: UnsplashPhoto? {
        didSet {
            updateViews()
        }
    }

// MARK: - Life Cycle
    override func layoutSubviews() {
        super.layoutSubviews()
        setUpViews()
    }
    
// MARK: - Subviews
    // Initialized only when property is called (lazy)
    lazy var paletteImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = (contentView.frame.height/20)
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    lazy var paletteTitleLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    lazy var colorPaletteView: ColorPaletteView = {
        let paletteView = ColorPaletteView()
        return paletteView
    }()
    
// MARK: - Subview Methods
    // Add subviews
    func addAllSubviews() {
        self.addSubview(paletteImageView)
        self.addSubview(paletteTitleLabel)
        self.addSubview(colorPaletteView)
    }
    
    // Constraints
    func setUpViews() {
        addAllSubviews()
        let imageDimensions = (contentView.frame.width - (SpacingConstants.outerHorizontalPadding * 2))
        paletteImageView.anchor(top: contentView.topAnchor, bottom: nil, leading: contentView.leadingAnchor, trailing: contentView.trailingAnchor, topPadding: SpacingConstants.outerVerticalPadding, bottomPadding: 0, leadingPadding: SpacingConstants.outerHorizontalPadding, trailingPadding: SpacingConstants.outerHorizontalPadding, width: imageDimensions, height: imageDimensions)
        paletteTitleLabel.anchor(top: paletteImageView.bottomAnchor, bottom: nil, leading: contentView.leadingAnchor, trailing: contentView.trailingAnchor, topPadding: SpacingConstants.verticalObjectBuffer, bottomPadding: 0, leadingPadding: SpacingConstants.outerHorizontalPadding, trailingPadding: SpacingConstants.outerHorizontalPadding, width: nil, height: SpacingConstants.oneLineElementHeight)
        colorPaletteView.anchor(top: paletteTitleLabel.bottomAnchor, bottom: contentView.bottomAnchor, leading: contentView.leadingAnchor, trailing: contentView.trailingAnchor, topPadding: SpacingConstants.verticalObjectBuffer, bottomPadding: SpacingConstants.outerVerticalPadding, leadingPadding: SpacingConstants.outerHorizontalPadding, trailingPadding: SpacingConstants.outerHorizontalPadding, width: nil, height: SpacingConstants.twoLineElementHeight)
        colorPaletteView.clipsToBounds = true
        colorPaletteView.layer.cornerRadius = SpacingConstants.twoLineElementHeight/2
    }

// MARK: - Custom Methods
    func updateViews() {
        guard let photo = photo else { return }
        fetchAndSetImage(for: photo)
        fetchAndSetColors(for: photo)
        paletteTitleLabel.text = photo.description
    }
    
    func fetchAndSetImage(for photo: UnsplashPhoto) {
        UnsplashService.shared.fetchImage(for: photo) { (photo) in
            DispatchQueue.main.async {
                self.paletteImageView.image = photo
            }
        }
    }
    
    func fetchAndSetColors(for photo: UnsplashPhoto) {
        ImaggaService.shared.fetchColorsFor(imagePath: photo.urls.regular) { (colors) in
            DispatchQueue.main.async {
                guard let colors = colors else { return }
                self.colorPaletteView.colors = colors
            }
        }
    }
} // End of class


