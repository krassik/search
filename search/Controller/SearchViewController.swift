import UIKit
import Foundation

class SearchViewController: UIViewController {
    
    var singelImageToggle = false
    
    @IBOutlet weak var searchBar: UISearchBar! {
        didSet {
            searchBar.becomeFirstResponder()
        }
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    //var imageItems = [BingImageItem]()
    var imageItems = [FlickrImageItem]()
    var page = -1
    //let imageService = BingService()
    let imageService = FlickrService()
    let imageCache =  ImageCache()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    func fetchImageItems() {
        guard let query = searchBar.text else {
            return
        }
        
        page += 1
        
        let offset = page * 8 // screen size
        
        imageService.fetchImageItems(query: query, offset: offset) { items in
  
            if let newItems = items {
                self.updateScreen(items: newItems)
            }
            
        }
    }
    
    //func updateScreen(items: [BingImageItem]) {
    func updateScreen(items: [FlickrImageItem]) {
        imageItems.append(contentsOf: items)
        
        // print( imageItems.count )
        
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
        
    }
}

//MARK: - SearchBar Delegate
extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.resignFirstResponder()
        
        // reset 
        page = -1
        //imageService.cancelTask()
        imageItems.removeAll()
        collectionView.reloadData()
    
        fetchImageItems()
    }
}



//MARK: - UICollectionViewDelegateFlowLayout
extension SearchViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let itemSize = collectionView.bounds.width / (singelImageToggle ? 1 : 2 ) - 1
        
        return CGSize(width: itemSize, height: itemSize)  // Square
    }
}

//MARK: - Collection View DataSource
extension SearchViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        
        return imageItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! ImageCell
        
        // cell.imageView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        
        let imageItem = imageItems[indexPath.row]
        
        // imageCache.fetchImage(named: imageItem.thumbnailUrl) { image in
            
        imageCache.fetchImage(named: imageItem.path() ) { image in
        
            //let indexPath_ = collectionView.indexPath(for: cell)
            //if indexPath == indexPath_ {
                cell.imageView.image = image
            //}
            
        }
        
        return cell
    
    }
}

//MARK: - Scrollview Delegate
extension SearchViewController: UIScrollViewDelegate {
    //MARK :- Getting user scroll down event here
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // when scrolling hits bottom
        if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= (scrollView.contentSize.height)) {
            fetchImageItems()
        }
    }
}


//MARK: - CollectionViewDelegate

extension SearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        singelImageToggle = !singelImageToggle
        collectionView.collectionViewLayout.invalidateLayout()
        let flowLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        flowLayout.scrollDirection = singelImageToggle ? .horizontal : .vertical
        collectionView.isPagingEnabled = singelImageToggle
        //print("stop")e
        
        
        collectionView.scrollToItem(at: indexPath, at: singelImageToggle ? .centeredHorizontally : .centeredVertically, animated: false)
        
        view.backgroundColor = singelImageToggle ? UIColor.black : UIColor.white
        collectionView.backgroundColor = singelImageToggle ? UIColor.black : UIColor.white
        self.navigationController?.navigationBar.barStyle = singelImageToggle ? .blackOpaque : .default
        
    }
}
