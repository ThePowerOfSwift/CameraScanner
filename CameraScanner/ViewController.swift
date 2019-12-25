//
//  ViewController.swift
//  CameraScanner
//
//  Created by Keishin CHOU on 2019/12/25.
//  Copyright © 2019 Keishin CHOU. All rights reserved.
//

import UIKit
import PDFKit
import WeScan

class ViewController: UIViewController {
    
    lazy private var logoImageView: UIImageView = {
        let image = UIImage(named: "WeScanLogo")
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy private var logoLabel: UILabel = {
        let label = UILabel()
        label.text = "WeScan"
        label.font = UIFont.systemFont(ofSize: 25.0, weight: .bold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy private var scanButton: UIButton = {
        let button = UIButton(type: .custom)
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
        button.setTitle("Scan Item", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(scanOrSelectImage(_:)), for: .touchUpInside)
        button.backgroundColor = UIColor(red: 64.0 / 255.0, green: 159 / 255.0, blue: 255 / 255.0, alpha: 1.0)
        button.layer.cornerRadius = 10.0
        return button
    }()
    
    private enum Mode {
        case scanImage
        case scanPDF
        case selectImage
    }
    
    private var mode: Mode = .scanImage
    
//    var pdfPage: PDFPage? = nil
    var pdfDocument = PDFDocument()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupConstraints()
        
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        
        navigationController?.isNavigationBarHidden = false
    }
    
    // MARK: - Setups
    
    private func setupViews() {
        view.addSubview(logoImageView)
        view.addSubview(logoLabel)
        view.addSubview(scanButton)
    }
    
    private func setupConstraints() {
        
        let logoImageViewConstraints = [
            logoImageView.widthAnchor.constraint(equalToConstant: 150.0),
            logoImageView.heightAnchor.constraint(equalToConstant: 150.0),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            NSLayoutConstraint(item: logoImageView, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 0.75, constant: 0.0)
        ]
        
        let logoLabelConstraints = [
            logoLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 20.0),
            logoLabel.centerXAnchor.constraint(equalTo: logoImageView.centerXAnchor)
        ]
        
        NSLayoutConstraint.activate(logoLabelConstraints + logoImageViewConstraints)
        
        let scanButtonConstraints = [
            scanButton.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 16),
            scanButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -16),
            scanButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            scanButton.heightAnchor.constraint(equalToConstant: 55)
        ]
        
        NSLayoutConstraint.activate(scanButtonConstraints)

    }
    
    // MARK: - Actions
    
    @objc func scanOrSelectImage(_ sender: UIButton) {
        let actionSheet = UIAlertController(title: "Would you like to scan an image or select one from your photo library?", message: nil, preferredStyle: .actionSheet)
        
        let scanImageAction = UIAlertAction(title: "Scan an image", style: .default) { (_) in
            self.scanImage()
        }

        let scanPDFAction = UIAlertAction(title: "Scan a document", style: .default) { (_) in
            self.scanPDF()
        }
        
        let selectAction = UIAlertAction(title: "Select an image", style: .default) { (_) in
            self.selectImage()
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        actionSheet.addAction(scanImageAction)
        actionSheet.addAction(scanPDFAction)
        actionSheet.addAction(selectAction)
        actionSheet.addAction(cancelAction)
        
        present(actionSheet, animated: true)
    }
    
    func scanImage() {
        
        mode = .scanImage
        
        let scannerViewController = ImageScannerController(delegate: self)
        scannerViewController.modalPresentationStyle = .fullScreen
        present(scannerViewController, animated: true)
    }

    func scanPDF() {
        
        mode = .scanPDF
        
        let scannerViewController = ImageScannerController(delegate: self)
        scannerViewController.modalPresentationStyle = .fullScreen
        present(scannerViewController, animated: true)
        
    }
    
    func selectImage() {
        
        mode = .selectImage
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true)
    }
    
    
    func useImage(_ results: ImageScannerResults) {
        print(results)
        let newViewController = ResultViewController()
        newViewController.results = results
        self.navigationController?.pushViewController(newViewController, animated: true)
    }

    func convertImageToPDF(_ results: ImageScannerResults) {
        let resultImage: UIImage?
        if results.doesUserPreferEnhancedImage == true {
//            resultImage = results.enhancedImage?.resize(toWidth: 250)
            resultImage = results.enhancedImage
        } else {
//            resultImage = results.scannedImage.resize(toWidth: 250)
            resultImage = results.scannedImage
        }
        guard let image = resultImage else { return }
        let pdfPage = PDFPage(image: image)
        pdfDocument.insert(pdfPage!, at: pdfDocument.pageCount)
        
        print("Convert successed.")
        print(pdfDocument)
    }
    
    func usePDF(_ pdf: PDFDocument) {
        let newViewController = PDFViewController()
        newViewController.pdfDocument = pdf
        self.navigationController?.pushViewController(newViewController, animated: true)
        
        for i in 0 ..< pdfDocument.pageCount {
            pdfDocument.removePage(at: i)
        }
    }
    
    
}

extension ViewController: ImageScannerControllerDelegate {
    func imageScannerController(_ scanner: ImageScannerController, didFailWithError error: Error) {
        print(error)
    }
    
    func imageScannerController(_ scanner: ImageScannerController, didFinishScanningWithResults results: ImageScannerResults) {
        scanner.dismiss(animated: true, completion: nil)
        
        print(mode)
        
        if mode == .selectImage {
            useImage(results)
        } else if mode == .scanImage {
            useImage(results)
        } else if mode == .scanPDF {
            
            convertImageToPDF(results)
            
            let alert: UIAlertController = UIAlertController(title: "Scan one more document?", message: "", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "Yes", style: .default) { (_) in
                self.scanPDF()
            }
            let cancelAction = UIAlertAction(title: "No", style: .cancel) { (_) in
                self.usePDF(self.pdfDocument)
            }
            alert.addAction(defaultAction)
            alert.addAction(cancelAction)
            present(alert, animated: true, completion: nil)
        }
        
    }
    
    
    
    func imageScannerControllerDidCancel(_ scanner: ImageScannerController) {
        scanner.dismiss(animated: true, completion: nil)
    }
    
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: true)
        
        guard let image = info[.originalImage] as? UIImage else { return }
        let scannerViewController = ImageScannerController(image: image, delegate: self)
        present(scannerViewController, animated: true)
    }
}

extension UIImage{
    func resize(toWidth width: CGFloat) -> UIImage? {
        let canvas = CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))
        return UIGraphicsImageRenderer(size: canvas, format: imageRendererFormat).image {
            _ in draw(in: CGRect(origin: .zero, size: canvas))
        }
    }
}


