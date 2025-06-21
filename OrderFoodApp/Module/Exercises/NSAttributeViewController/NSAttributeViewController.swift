//
//  NSAttributeViewController.swift
//  OrderFoodApp
//
//  Created by Phincon on 08/10/24.
//

import UIKit
import AVFoundation
import FirebaseStorage
import SnapKit

class NSAttributeViewController: UIViewController {
    
    @IBOutlet weak var toolbarView: ToolBarView!
    @IBOutlet weak var imgMusicView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var startLabel: UILabel!
    @IBOutlet weak var endLabel: UILabel!
    
    
    @IBOutlet weak var shuffleBtn: UIButton!
    @IBOutlet weak var skipBackBtn: UIButton!
    @IBOutlet weak var playBtn: UIButton!
    @IBOutlet weak var skipForwardBtn: UIButton!
    @IBOutlet weak var repeatBtn: UIButton!
    
    let textView: UITextView = {
        let tv = UITextView()
        tv.isEditable = false
        tv.isScrollEnabled = true
        tv.dataDetectorTypes = .link
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    var audioPlayer: AVAudioPlayer?
    var progressTimer: Timer?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        toolbarView.titleLabel.text = "Ophelia"
        setup()
        
        view.addSubview(textView)
        
        textView.snp.makeConstraints { make in
            make.top.equalTo(repeatBtn.snp.bottom)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(20)
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideNavigationBar()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        // Invalidate the timer when the view is no longer visible
        progressTimer?.invalidate()
    }
    
    
    func hideNavigationBar(){
        self.navigationController?.isToolbarHidden = true
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.isNavigationBarHidden = true
        self.hidesBottomBarWhenPushed = false
    }
    
    func setup() {
        playBtn.addTarget(self, action: #selector(playBtnAction), for: .touchUpInside)
        playAudio("masha-and-the-bear")
        
        titleLabel.font = .foodBrownie(14)
        
        let attrText = NSMutableAttributedString(string: String(format: .localized("welcome"), "ophelia", "6"))
        attrText.addColoredText(color: .foodBrightCoral5, forText: "ophelia")

        // Tetapkan teks berwarna pada label
        titleLabel.attributedText = attrText
        
        
        

        let htmlString = """
           <ol>
               <li>Paket berlaku untuk 1 hari sejak jam aktivasi hingga pukul 23.59.</li>
               <li>Paket berlaku hanya untuk pemakaian domestik (tidak berlaku untuk pemakaian luar negeri yang akan dikenakan biaya terpisah).</li>
               <li>Setelah melewati kuota yang disediakan, pelanggan akan dikenakan tarif dasar internet.</li>
               <li>Harga paket dapat berubah sewaktu-waktu sesuai dengan kebijakan harga yang ditetapkan oleh Telkomsel.</li>
           </ol>
           """
        textView.attributedText = htmlString.htmlToAttributedString
        
    }
    
    @objc func playBtnAction() {
        if audioPlayer?.isPlaying == true {
            audioPlayer?.pause()
            
        } else {
            audioPlayer?.play()
            startProgressTimer()
            
        }
    }
    
    func startProgressTimer() {
        // Invalidate the timer if it's already running
        progressTimer?.invalidate()
        
        // Schedule a new timer to update the progress view every 0.1 seconds
        progressTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateProgress), userInfo: nil, repeats: true)
    }
    
    @objc func updateProgress() {
        guard let player = audioPlayer else { return }
        
        // Calculate the current progress (currentTime / duration)
        let progress = Float(player.currentTime / player.duration)
        
        // Update the progress view
        progressView.setProgress(progress, animated: true)
        
        // Update the label with the current time and total duration
        let currentTimeText = formatTime(player.currentTime)
        startLabel.text = "\(currentTimeText)"
        
        // Stop the timer when the audio finishes
        if player.currentTime >= player.duration {
            progressTimer?.invalidate()
        }
    }
    
    // AVAudioPlayerDelegate - Detect when the audio finishes playing
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        // Reset the progress bar and stop the timer
        progressView.setProgress(0.0, animated: true)
        progressTimer?.invalidate()
    }
    
    
    

}

extension NSAttributeViewController {
    
    func playAudio(_ audioName: String, type: String = "mp3") {
        guard let path = Bundle.main.path(forResource: audioName, ofType: type) else {return}
        let url = URL(fileURLWithPath: path)
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            startProgressTimer()
            
            if let duration = audioPlayer?.duration {
                let durationText = formatTime(duration)
                endLabel.text = "\(durationText)"
            }
        } catch  {
            print("error")
        }
    }
    
    // Helper function to format time as mm:ss
    func formatTime(_ time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    // Function to download music from Firebase Storage and play it
    func downloadMusicFromFirebase() {
        // Reference to Firebase Storage
        let storage = Storage.storage()
        
        // Path to the music file in Firebase Storage (make sure the path is correct)
        let musicPath = "music/masha-and-the-bear.mp3" // Adjust the path as per your Firebase storage structure
        
        // Create a reference to the file you want to download
        let musicRef = storage.reference().child(musicPath)
        
        // Download to a local file URL
        let tempURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("myMusicFile.mp3")
        
        // Download the file
        musicRef.write(toFile: tempURL) { url, error in
            if let error = error {
                print("Error downloading music: \(error.localizedDescription)")
            } else {
                print("Music file downloaded successfully")
                // Play the music after download
                self.playMusic(fileURL: tempURL)
            }
        }
    }
    
    // Function to play music using AVAudioPlayer
    func playMusic(fileURL: URL) {
        do {
            // Initialize AVAudioPlayer with the downloaded file URL
            audioPlayer = try AVAudioPlayer(contentsOf: fileURL)
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
        } catch let error {
            print("Error playing audio: \(error.localizedDescription)")
        }
    }
    
    
}
