//
//  ReviewCommentTableViewCell.swift
//  iplix
//
//  Created by Farhan Adji on 15/04/20.
//  Copyright © 2020 Farhan Adji. All rights reserved.
//

import UIKit

protocol ReviewDelegate {
    func getReview(review: String)
}

class ReviewCommentTableViewCell: UITableViewCell {

    @IBOutlet weak var reviewTextView: UITextView!
    var delegate: ReviewDelegate?
    var color: UIColor = .lightGray
    override func awakeFromNib() {
        super.awakeFromNib()
        reviewTextView.delegate = self
        reviewTextView.isScrollEnabled = false
        reviewTextView.textColor = color
        reviewTextView.text = K.text.review
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

extension ReviewCommentTableViewCell: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if reviewTextView.isFirstResponder && reviewTextView.textColor == color {
            reviewTextView.text = nil
            reviewTextView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        print(textView.text!)
        if reviewTextView.text.isEmpty || reviewTextView.text == "" {
            reviewTextView.textColor = color
            reviewTextView.text = K.text.review
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        delegate?.getReview(review: textView.text!)
    }
}
