import UIKit

class HitImageContentView: UIView, UIContentView {
    struct Configuration: UIContentConfiguration {
        
        var image: UIImage?
        
        func makeContentView() -> UIView & UIContentView {
            return HitImageContentView(self)
        }
    }
    
    let imageView = UIImageView()
    var configuration: UIContentConfiguration {
        didSet {
            configure(configuration: configuration)
        }
    }
    
    init(_ configuration: UIContentConfiguration) {
        self.configuration = configuration
        super.init(frame: .zero)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(imageView)
        
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .secondarySystemBackground
        imageView.clipsToBounds = true
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(configuration: UIContentConfiguration) {
        guard let configuration = configuration as? Configuration else { return }
        imageView.image = configuration.image
    }
}

extension UICollectionViewCell {
    func hitImageConfiguration() -> HitImageContentView.Configuration {
        HitImageContentView.Configuration()
    }
}


extension UIContentConfiguration {
    func updated(for state: UIConfigurationState) -> Self {
        return self
    }
}
