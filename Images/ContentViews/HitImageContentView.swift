import UIKit

class HitImageContentView: UIView, UIContentView {
    struct Configuration: UIContentConfiguration {
        
        var image: UIImage?
        var isSelected: Bool = false
        
        func makeContentView() -> UIView & UIContentView {
            return HitImageContentView(self)
        }
    }
    
    let imageView = UIImageView()
    let selectedImageView = UIImageView()
    var configuration: UIContentConfiguration {
        didSet {
            configure(configuration: configuration)
        }
    }
    
    init(_ configuration: UIContentConfiguration) {
        self.configuration = configuration
        super.init(frame: .zero)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        selectedImageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(imageView)
        addSubview(selectedImageView)
        
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .secondarySystemBackground
        imageView.clipsToBounds = true
        
        selectedImageView.tintColor = .white
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            selectedImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            selectedImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
            selectedImageView.heightAnchor.constraint(equalTo: selectedImageView.widthAnchor),
            selectedImageView.heightAnchor.constraint(equalToConstant: 20)
        ])
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(configuration: UIContentConfiguration) {
        guard let configuration = configuration as? Configuration else { return }
        imageView.image = configuration.image
        let symbolName = configuration.isSelected ? "checkmark.circle.fill" : "circle"
        selectedImageView.image = UIImage(systemName: symbolName)
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
