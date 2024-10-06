//
//  ADCarouselView.swift
//  AppIOS2
//
//  Created by ios on 2024/10/6.
//
import UIKit

class ADCarouselView: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var collectionView: UICollectionView!
    var pageControl: UIPageControl!
    var ads: [DataADBanner] = [DataADBanner(adSeqNo: -1, linkUrl: "")] {
        didSet {
            // 在廣告數據更新時刷新 UICollectionView 和 UIPageControl
            collectionView.reloadData()
            pageControl.numberOfPages = ads.count
        }
    }
    var timer: Timer?

    // 初始化方法
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    // 設置 view
    private func setupView() {
        
        
        // 設置 UICollectionViewFlowLayout
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.itemSize = CGSize(width: self.frame.size.width, height: self.frame.size.height)

        // 設置 UICollectionView
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        let nib = UINib(nibName: "ADCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "ADCell")
        collectionView.backgroundColor = UIColor.init(red: 255, green: 255, blue: 255, alpha: 0)
        
        self.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        // 設置 UIPageControl
        pageControl = UIPageControl()
        pageControl.numberOfPages = ads.count
        pageControl.currentPage = 0
        pageControl.pageIndicatorTintColor = UIColor.lightGray
        pageControl.currentPageIndicatorTintColor = UIColor.black
        
        self.addSubview(pageControl)
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        pageControl.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        
        // 自動播放計時器
        startAutoScrollTimer()
    }

    // UICollectionViewDataSource 協定方法
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ads.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ADCell", for: indexPath) as? ADCell else{
            fatalError("Cell not exists in storyBoard")
        }
        let urlString = ads[indexPath.row].linkUrl
        if(urlString == ""){
            cell.noADView.isHidden = false
        }else{
            cell.noADView.isHidden = true
            cell.adImageView.load(url: URL(string:ads[indexPath.row].linkUrl)!)
        }
        
        return cell
    }

    // UICollectionViewDelegate 協定方法
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let page = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
        pageControl.currentPage = page
    }

    // 自動滾動廣告
    func startAutoScrollTimer() {
        timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(autoScrollAds), userInfo: nil, repeats: true)
    }

    @objc func autoScrollAds() {
        let visibleItems = collectionView.indexPathsForVisibleItems
        if let currentItem = visibleItems.first {
            let nextItem = IndexPath(item: (currentItem.item + 1) % ads.count, section: 0)
            collectionView.scrollToItem(at: nextItem, at: .centeredHorizontally, animated: true)
            pageControl.currentPage = nextItem.item
        }
    }

    // 停止計時器
    func stopAutoScrollTimer() {
        timer?.invalidate()
        timer = nil
    }

    override func willMove(toSuperview newSuperview: UIView?) {
        if newSuperview == nil {
            stopAutoScrollTimer()
        }
    }
}
extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
