//
//  TutorialScreenViewController.swift
//  TaxiNanny
//
//  Created by Shashwat B on 12/11/19.
//  Copyright © 2019 Amrit Sahay. All rights reserved.
//

import UIKit

class TutorialScreenViewController: UIViewController {
    @IBOutlet weak var pagecontroller: UIPageControl!
    @IBOutlet weak var collectionview: UICollectionView!
    @IBOutlet weak var tutotialimg: UIImageView!
    @IBOutlet weak var textmsg: UILabel!
    var img = [#imageLiteral(resourceName: "logo"),#imageLiteral(resourceName: "logo"),#imageLiteral(resourceName: "logo"),#imageLiteral(resourceName: "logo")]
    var txttitle = [Constant.tourtitle1,Constant.tourtitle2,Constant.tourtitle3,Constant.tourtitle4]
    var txtmsg = [Constant.tourtext1,Constant.tourtext2,Constant.tourtext3,Constant.tourtext4]
    var currentIndex = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidLayoutSubviews() {
        pagecontroller.subviews.forEach {
            $0.transform = CGAffineTransform(scaleX: 2, y: 2)
        }
    }
    func pushViewController(viewController:UIViewController)
    {
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        let navController = UINavigationController.init(rootViewController:viewController)
        navController.navigationBar.isHidden = true
        appDelegate.drawerController?.mainViewController = navController
        appDelegate.drawerController?.setDrawerState(.closed, animated: true)
    }
    
    @IBAction func startbutton(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier:"FirstViewController")
        self.pushViewController(viewController: vc!)
    }
    
}
extension TutorialScreenViewController: UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       return txttitle.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TutorialCollectionViewCell", for: indexPath) as! TutorialCollectionViewCell
  
//        let url1 = URL(string: imageUrl[indexPath.row])
//        cell.sliderimg.sd_setImage(with: url1, completed: nil)
        cell.tourimg.image = img[indexPath.row]
        cell.tourtitle.text = txttitle[indexPath.row]
        cell.tourmsg.text = txtmsg[indexPath.row]
        
        return cell
        
        
        
        
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //let currentIndex = (currentIndex < img.count - 1) ? currentIndex + 1 : 0
        //currentIndex = (currentIndex < img.count - 1) ? currentIndex + 1 : 0
         currentIndex = Int(scrollView.contentOffset.x/collectionview.frame.size.width)
         pagecontroller.currentPage = currentIndex
    }
    
}

extension TutorialScreenViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = collectionview.frame.size
        return CGSize(width: size.width, height: size.height)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
}
