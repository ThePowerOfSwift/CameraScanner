//
//  PDFViewController.swift
//  CameraScanner
//
//  Created by Keishin CHOU on 2019/12/25.
//  Copyright © 2019 Keishin CHOU. All rights reserved.
//

import UIKit
import PDFKit
import WeScan

class PDFViewController: UIViewController {
    
    private var pdfView = PDFView()
    private var pdfThumnbnailView = PDFThumbnailView()
    
    var results: ImageScannerResults? = nil
    var pdfDocument = PDFDocument()
    
    override func loadView() {
        super.loadView()
        
        pdfView.translatesAutoresizingMaskIntoConstraints = false
        pdfThumnbnailView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(pdfView)
        view.addSubview(pdfThumnbnailView)
        
        pdfView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        pdfView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        pdfView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        pdfView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.85).isActive = true
        
        pdfThumnbnailView.topAnchor.constraint(equalTo: pdfView.bottomAnchor).isActive = true
        pdfThumnbnailView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        pdfThumnbnailView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        pdfThumnbnailView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true

    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        pdfView.document = pdfDocument
        pdfView.displayDirection = .horizontal
        pdfView.pageBreakMargins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        pdfView.autoScales = true
        
        pdfThumnbnailView.pdfView = pdfView
        pdfThumnbnailView.layoutMode = .horizontal
        pdfThumnbnailView.pdfView = pdfView
        pdfThumnbnailView.backgroundColor = UIColor(displayP3Red: 179/255, green: 179/255, blue: 179/255, alpha: 0.5)
        pdfThumnbnailView.thumbnailSize = CGSize(width: 80, height: 100)
        pdfThumnbnailView.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
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
