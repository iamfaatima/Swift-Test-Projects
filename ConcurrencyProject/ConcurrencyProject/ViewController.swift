//
//  ViewController.swift
//  ConcurrencyProject
//
//  Created by Dev on 05/12/2023.
//

import UIKit
import Alamofire
import MultipeerConnectivity

class ViewController: UIViewController {

    @IBOutlet weak var progressBarOne: UIProgressView!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var imageViewTwo: UIImageView!
    @IBOutlet weak var progressBarTwo: UIProgressView!
    
    @IBOutlet weak var imageViewThree: UIImageView!
    @IBOutlet weak var progressBarThree: UIProgressView!
    
    @IBOutlet weak var downloadButton: UIButton!
    @IBOutlet weak var transferButton: UIButton!
    
    let imageURLs = [
        "https://images.pexels.com/photos/842711/pexels-photo-842711.jpeg?auto=compress&cs=tinysrgb&w=1200",
        "https://images.pexels.com/photos/1229042/pexels-photo-1229042.jpeg?auto=compress&cs=tinysrgb&w=1200",
        "https://images.pexels.com/photos/1413412/pexels-photo-1413412.jpeg?auto=compress&cs=tinysrgb&w=1200"
    ]

    
    var peerID: MCPeerID!
    var session: MCSession!
    var browser: MCBrowserViewController!
    var advertiser: MCAdvertiserAssistant!
    
    let group = DispatchGroup()

    override func viewDidLoad() {
            super.viewDidLoad()
            progressBarOne.progress = 0.0
            progressBarTwo.progress = 0.0
            progressBarThree.progress = 0.0
            transferButton.isEnabled = false

            // Initialize Multipeer Connectivity
            peerID = MCPeerID(displayName: UIDevice.current.name)
            session = MCSession(peer: peerID)
            session.delegate = self

            browser = MCBrowserViewController(serviceType: "image-transfer", session: session)
            browser.delegate = self

            advertiser = MCAdvertiserAssistant(serviceType: "image-transfer", discoveryInfo: nil, session: session)
            advertiser.delegate = self
            advertiser.start()
        }

        @IBAction func downloadButtonPressed(_ sender: UIButton) {
            
            progressBarOne.progress = 0.0
            progressBarTwo.progress = 0.0
            progressBarThree.progress = 0.0

            for (index, url) in imageURLs.enumerated() {
                group.enter()
                print("entered \(index)")
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                           self.downloadImage(from: url, index: index)
                       }
            }

            group.notify(queue: DispatchQueue.main) {
                print("All downloads completed")
                self.transferButton.isEnabled = true
            }
        }
    
    @IBAction func transferButtonPressed(_ sender: UIButton) {
        guard session.connectedPeers.count > 0 else {
                    print("No connected peers.")
                    return
                }

                for (index, url) in imageURLs.enumerated() {
                    group.enter()
                    print("entered \(index)")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                               self.downloadImage(from: url, index: index)
                           }
                }

                group.notify(queue: DispatchQueue.main) {
                    print("All downloads completed. Sending images.")
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        self.sendImages()
                           }
                }
    }
    
    
    @IBAction func browserButtonPressed(_ sender: UIButton) {
        present(browser, animated: true, completion: nil)
    }
    
    func downloadImage(from url: String, index: Int) {
        AF.download(url)
            .downloadProgress { progress in
                DispatchQueue.main.async {
                    switch index {
                    case 0:
                        self.progressBarOne.progress = Float(progress.fractionCompleted)
                    case 1:
                        self.progressBarTwo.progress = Float(progress.fractionCompleted)
                    case 2:
                        self.progressBarThree.progress = Float(progress.fractionCompleted)
                    default:
                        break
                    }

                    // Ensure there's at least one connected peer before attempting to send progress
                    if let peerID = self.session.connectedPeers.first {
                        let progressData = "\(index):\(progress.fractionCompleted)".data(using: .utf8)!
                        do {
                            try self.session.send(progressData, toPeers: [peerID], with: .reliable)
                        } catch {
                            print("Error sending progress to peers: \(error.localizedDescription)")
                        }
                    } else {
                        print("No connected peers to send progress to.")
                    }
                }
            }
            .responseData { response in
                defer {
                    print("left \(index)")
                    self.group.leave()
                }

                switch response.result {
                case .success(let data):
                    self.updateImageView(data: data, index: index)
                case .failure(let error):
                    print("Download failed for index \(index): \(error)")
                }
            }
    }

    func sendImages() {
            let imageDataArray = [
                imageView.image?.jpegData(compressionQuality: 0.8),
                imageViewTwo.image?.jpegData(compressionQuality: 0.8),
                imageViewThree.image?.jpegData(compressionQuality: 0.8)
            ]

            for (index, data) in imageDataArray.enumerated() {
                do {
                    // Ensure there's at least one connected peer before attempting to send images
                    if let peerID = session.connectedPeers.first {
                        try session.send(data!, toPeers: [peerID], with: .reliable)
                        print("Image \(index) sent to peers.")
                    } else {
                        print("No connected peers to send image \(index).")
                    }
                } catch {
                    print("Error sending image \(index): \(error.localizedDescription)")
                }
            }
        }

    func updateImageView(image: UIImage) {
            // Update the image view based on the received image
            // This method assumes that you have UIImageView outlets connected in your storyboard
            // and imageView, imageViewTwo, imageViewThree are valid outlets.
            // Adjust your code accordingly if needed.
            if imageView.image == nil {
                imageView.image = image
            } else if imageViewTwo.image == nil {
                imageViewTwo.image = image
            } else if imageViewThree.image == nil {
                imageViewThree.image = image
            }
        }
    
    func updateImageView(data: Data, index: Int) {
                switch index {
                case 0:
                    self.imageView.image = UIImage(data: data)
                case 1:
                    self.imageViewTwo.image = UIImage(data: data)
                case 2:
                    self.imageViewThree.image = UIImage(data: data)
                default:
                    break
                }
            }

    }

extension ViewController: MCSessionDelegate {
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
            switch state {
            case .connected:
                print("Connected to peer: \(peerID.displayName)")
            case .connecting:
                print("Connecting to peer: \(peerID.displayName)")
            case .notConnected:
                print("Disconnected from peer: \(peerID.displayName)")
            @unknown default:
                break
            }
        }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        if let progressString = String(data: data, encoding: .utf8) {
            // Update progress bars based on received progress
            let components = progressString.components(separatedBy: ":")
            if components.count == 2, let index = Int(components[0]), let progress = Float(components[1]) {
                DispatchQueue.main.async {
                    switch index {
                    case 0:
                        self.progressBarOne.progress = progress
                    case 1:
                        self.progressBarTwo.progress = progress
                    case 2:
                        self.progressBarThree.progress = progress
                    default:
                        break
                    }
                }
            }
        } else if let imageData = data as? Data, let image = UIImage(data: imageData) {
            // Handle received image data and update the image view
            DispatchQueue.main.async {
                self.updateImageView(image: image)
            }
        }
    }
        // Implement other MCSessionDelegate methods as needed
    }

extension ViewController: MCAdvertiserAssistantDelegate {
    func advertiserAssistantWillPresentInvitation(_ advertiserAssistant: MCAdvertiserAssistant) {
        print("Will present invitation")
    }

    func advertiserAssistantDidDismissInvitation(_ advertiserAssistant: MCAdvertiserAssistant) {
        print("Did dismiss invitation")
    }

    func advertiserAssistant(_ advertiserAssistant: MCAdvertiserAssistant, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        print("Received invitation from peer: \(peerID.displayName)")

        let acceptInvitation = true

        if acceptInvitation && !session.connectedPeers.contains(peerID) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                invitationHandler(acceptInvitation, self.session)
            }
                } else {
                    // If you want to decline the invitation, you can do the following:
                    // invitationHandler(false, nil)
                    print("Invitation declined.")
                }
        // Print the context or any other relevant information for debugging
        print("Context: \(String(describing: context))")

    }

}

extension ViewController: MCBrowserViewControllerDelegate {
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true, completion: nil)
    }

    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true, completion: nil)
    }

    func browserViewController(_ browserViewController: MCBrowserViewController, didNotStartBrowsingForPeers error: Error) {
        print("Error starting browsing: \(error.localizedDescription)")
    }

    func browserViewController(_ browserViewController: MCBrowserViewController, shouldPresentNearbyPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) -> Bool {
        print("Discovered Peer: \(peerID.displayName)")
        // You can customize the logic here if needed
        return true
    }
}
