//
//  PhotoViewController.swift
//  Example
//
//  Created by Paul Zabelin on 1/5/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import PerspectiveTransform

class FittingPolygon {
    var points: [CGPoint] = []

    init(svgPointsString:String) {
        let formatter = NumberFormatter()
        let eightNumbers: [CGFloat] = svgPointsString.split(separator: " ").map { substring in
            let string = String(substring)
            let number = formatter.number(from: string)
            return CGFloat(truncating: number!)
        }
        for point in stride(from:0, to: 7, by: 2) {
            let x = eightNumbers[point]
            let y = eightNumbers[point + 1]
            points.append(CGPoint(x: x, y: y))
        }
        assert(points.count == 4, "should have 4 point")
    }

    class func loadFromSvgFile() -> FittingPolygon {
        let loader = PolygonLoader(fileName: "with-overlay.svg")
        return loader.load()
    }
}

class PolygonLoader: NSObject {

    let svgFileUrl: URL

    init(fileName: String) {
        let bundle = Bundle(for: type(of: self))
        let name = fileName.split(separator: ".")
        let fileName: String = String(name.first!)
        let fileExtension: String = String(name.last!)
        svgFileUrl = bundle.url(forResource: fileName, withExtension: fileExtension)!
        let contents = try! String(contentsOf: svgFileUrl)
        print(contents)
        assert(contents.count > 10, "too short content")
    }

    func load() -> FittingPolygon {
        let parser = XMLParser(contentsOf: svgFileUrl)!
        parser.delegate = self
        parser.parse()
        print(pointStrings!)
        return FittingPolygon(svgPointsString: pointStrings!)
    }

    var pointStrings: String?
}

extension PolygonLoader: XMLParserDelegate {
    func parser(_ parser: XMLParser,
                didStartElement elementName: String,
                namespaceURI: String?,
                qualifiedName qName: String?,
                attributes attributeDict: [String : String] = [:]) {
        if elementName == "polygon" {
            pointStrings = attributeDict["points"]?.trimmingCharacters(in: .whitespacesAndNewlines)
        }
    }
}

class PhotoViewController: UIViewController {

    @IBOutlet var containerImageView: UIImageView!
    @IBOutlet var overlayImageView: UIImageView!
    @IBOutlet var tapGesture: UITapGestureRecognizer!

    override func viewDidLoad() {
        super.viewDidLoad()
        applyTranformation()
    }

    @IBAction func didTap(_ sender: UITapGestureRecognizer) {
        UIView.animate(withDuration: 0.5) {
            self.overlayImageView.layer.transform = CATransform3DIdentity
        }
    }

    func applyTranformation() {
        let start = Perspective(overlayImageView.frame)
        let transform = FittingPolygon.loadFromSvgFile()
        var destination = Perspective(overlayImageView.frame)
        print("transform.points:", transform.points)
        destination = Perspective(transform.points)
        overlayImageView.layer.transform = start.projectiveTransform(destination: destination)
    }

}