import UIKit
import RxSwift


/**
 The cell which displays a campaign.
 */
class CampaignCell: UICollectionViewCell {
    
    static let spacingBetweenTitleAndText = 8

    private let disposeBag = DisposeBag()

    /** Used to display the campaign's title. */
    @IBOutlet private(set) weak var nameLabel: UILabel!

    /** Used to display the campaign's description. */
    @IBOutlet private(set) weak var descriptionLabel: UILabel!

    /** The image view which is used to display the campaign's mood image. */
    @IBOutlet private(set) weak var imageView: UIImageView!

    /** The mood image which is displayed as the background. */
    var moodImage: Observable<UIImage>? {
        didSet {
            moodImage?
                .observeOn(MainScheduler.instance)
                .subscribe(onNext: { [weak self] image in
                    guard let self = self else { return }
                    self.imageView.image = image
                    self.imageHeightObservable.onNext(image.size)
                    })
                .disposed(by: disposeBag)
        }
    }
    
    /** The campaign's name. */
    var name: String? {
        didSet {
            nameLabel?.text = name
            let bounds = CGSize(width: bounds.size.width, height: CGFloat(MAXFLOAT))
            // Layouting so that systemLayoutSizeFitting(_:)
            // would return values reflecting the new layout
            self.layoutIfNeeded()
            self.titleHeightObservable.onNext(self.nameLabel.systemLayoutSizeFitting(bounds))
        }
    }

    var descriptionText: String? {
        didSet {
            descriptionLabel?.text = descriptionText
            let bounds = CGSize(width: bounds.size.width, height: CGFloat(MAXFLOAT))
            self.layoutIfNeeded()
            let size = self.descriptionLabel.systemLayoutSizeFitting(bounds, withHorizontalFittingPriority: .fittingSizeLevel, verticalFittingPriority: .defaultLow)
            self.textHeightObservable.onNext(size)
        }
    }
    
    /** An observable that emits the height, to be observed by the collection view */
    var heightObservable: Observable<CGFloat> { get {
        Observable.combineLatest(imageHeightObservable, textHeightObservable, titleHeightObservable).map {
            // For readability, give names to the tuple elements
            return (image: $0.0, text: $0.1, title: $0.2)
        }.observeOn(MainScheduler.instance).map { [weak self] heights -> CGFloat in
            guard let self = self else { return CGFloat(0.0) }
            let imageHeight = (self.bounds.width / 4) * 3
            let textHeight = heights.text.height
            let titleHeight = heights.title.height
            return imageHeight + ceil(textHeight) + ceil(titleHeight) + CGFloat(CampaignCell.spacingBetweenTitleAndText)
        }
    } }
    
    private let cachedImageObservable = ReplaySubject<UIImage>.create(bufferSize: 1)
    private let imageHeightObservable = ReplaySubject<CGSize>.create(bufferSize: 1)
    private let textHeightObservable = ReplaySubject<CGSize>.create(bufferSize: 1)
    private let titleHeightObservable = ReplaySubject<CGSize>.create(bufferSize: 1)

    override func awakeFromNib() {
        super.awakeFromNib()

        assert(nameLabel != nil)
        assert(descriptionLabel != nil)
        assert(imageView != nil)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}
