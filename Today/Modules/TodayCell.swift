//
//  TodayCell.swift
//  Today
//
//  Created by Milton Leung on 2017-07-27.
//Copyright © 2017 milton. All rights reserved.
//

import UIKit

internal final class TodayCell: UITableViewCell, ReusableNibView {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!

    func configure(with presenter: TodayCellPresenter) {
        titleLabel.text = presenter.title
        descriptionLabel.text = presenter.content
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
