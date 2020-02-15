//
//  BooksListItemCell.swift
//  TReader
//
//  Created by tadas on 2020-02-14.
//  Copyright © 2020 Scale3C. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxGesture


class BooksListItemCell: UICollectionViewCell {
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var progress: BookProgressView!

    var disposeBag = DisposeBag()

    func set(index: Int) {
        image.image = UIImage(named: "\(index)")
        title.text = "This is book with id: \(index)" + (Bool.random() ? " The longer name\nand new line\nnew line" : "")

        disposeBag = DisposeBag()

        progress.state = .waiting

        progress.rx
            .tapGesture()
            .skip(1)
            .map { _ in }
            .subscribe(onNext: animate)
            .disposed(by: disposeBag)
    }

    func animate() {
        progress.state = .downloading
        progress.progress = 0.0

        let timer = Observable<Int>.interval(0.01, scheduler: MainScheduler.instance)

        timer.subscribe(onNext: { [unowned self] _ in
            if self.progress.progress < 1 {
                self.progress.state = .downloading
                self.progress.progress += 0.02
            } else {
                self.progress.state = Bool.random() ? .downloaded : .error
                self.disposeBag = DisposeBag()
            }
        }).disposed(by: disposeBag)
    }
}
