//
//  ProductTableViewCell.swift
//  LoginApp
//
//  Created by Quan Pham Van on 8/8/18.
//  Copyright © 2018 QuanPV. All rights reserved.
//

import UIKit

protocol ProductTableViewCellDelegate: class {
    func didTapBuy(forProduct product: Product)
}


class ProductTableViewCell: UITableViewCell {

    @IBOutlet var priceButton: UIButton!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var productImageView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    weak var delegate: ProductTableViewCellDelegate?
    
    var productCellViewModel: ProductCellViewModel! {
        didSet {
            self.nameLabel.text = productCellViewModel.name
            self.priceButton.setTitle(productCellViewModel.displayPrice, for: .normal)
            self.descriptionLabel.text = productCellViewModel.desc
            self.productImageView.downloaded(from: productCellViewModel.imageURL)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.priceButton.layer.borderColor = Color.omiseGOBlue.cgColor()
        self.priceButton.layer.borderWidth = 1
        self.priceButton.layer.cornerRadius = 5
        self.productImageView.layer.cornerRadius = 10
        self.productImageView.clipsToBounds = true
    }

    @IBAction func didTapBuyButton(_ sender: UIButton) {
        print("didTapBuyButton:====>")
        self.delegate?.didTapBuy(forProduct: self.productCellViewModel.product)
    }
}
