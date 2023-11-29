import UIKit

class ImagesViewController: UIViewController, UIPageViewControllerDelegate {
    
    var pageController: UIPageViewController!
    var imageControllers = [UIViewController]()
    
    weak var timer: Timer?
    
    /// The array of `Hit` represent the selected images.
    var hits: [Hit]
    
    init(hits: [Hit]) {
        self.hits = hits
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Not implemented")
    }
    
    deinit {
        timer?.invalidate()
    }
    
    override func viewDidLoad() {
        pageController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
        pageController.dataSource = self
        pageController.delegate = self
        
        configureHierarchy()
        
        hits.forEach { hit in
            createImageController(hit: hit)
        }
        
        pageController.setViewControllers([imageControllers[0]], direction: .forward, animated: false)
        
        configureTimer()
        
    }
    
    /// Configure hierarchy by adding the page controller as a child
    /// Used VFL language to set up constraints
    private func configureHierarchy() {
        addChild(pageController)
        view.addSubview(pageController.view)
        
        let views = ["pc": pageController.view] as [String: AnyObject]
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[pc]|", options: [], metrics: nil, views: views))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[pc]|", options: [], metrics: nil, views: views))
    }
    
    /// Initialize a new image controller for the given `Hit`
    /// representing one of the selected images
    private func createImageController(hit: Hit) {
        let imageController = UIViewController()
        let imageView = UIImageView()
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageController.view.addSubview(imageView)
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .secondarySystemGroupedBackground
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: imageController.view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: imageController.view.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: imageController.view.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: imageController.view.bottomAnchor)])
        
        imageView.image = ImageCache.placeholderImage
        ImageCache.shared.loadImage(url: hit.webFormat as NSURL) { loadedImage in
            if let loadedImage {
                imageView.image = loadedImage
            }
        }
        
        imageControllers.append(imageController)
    }
    
    /// Configure timer to move to next page controller regularly
    private func configureTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 3, repeats: true, block: { [weak self] _ in
            
            guard let self = self else { return }
            
            if let currentController = self.pageController.viewControllers?[0],
               let index = self.imageControllers.firstIndex(of: currentController) {
                
                self.pageController.setViewControllers([self.imageControllers[(index+1) % self.imageControllers.count]], direction: .forward, animated: true)
                
            }
        })
    }
    
}

