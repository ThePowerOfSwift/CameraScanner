//
//  ResultViewController.swift
//  WeScanSampleProject
//
//  Created by Keishin CHOU on 2019/12/25.
//  Copyright © 2019 WeTransfer. All rights reserved.
//

import UIKit
import WeScan
import PDFKit

class ResultViewController: UIViewController {
    
    private var imageView: UIImageView!
    var results: ImageScannerResults? = nil
//    var pdfData: Data? = nil
    var pdfPage: PDFPage? = nil
    
    override func loadView() {
        
        view = UIView()
        imageView = UIImageView()
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        if results?.doesUserPreferEnhancedImage == true {
            
            guard let image = results?.scannedImage else { return }
            imageView.image = image
            pdfPage = PDFPage(image: image)
            
        } else {
            
            guard let image = results?.enhancedImage else { return }
            imageView.image = image
            pdfPage = PDFPage(image: image)
        
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

