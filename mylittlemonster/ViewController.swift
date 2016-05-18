//
//  ViewController.swift
//  mylittlemonster
//
//  Created by Vinodh Srinivasan on 5/14/16.
//  Copyright © 2016 creaTech. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    @IBOutlet weak var monsterImg: MonsterImage!
    @IBOutlet weak var heartImage: DragImage!
    @IBOutlet weak var foodImage: DragImage!
    
    @IBOutlet weak var penalty1Img: UIImageView!
    @IBOutlet weak var penalty2Img: UIImageView!
    @IBOutlet weak var penalty3Img: UIImageView!
    
    let DIM_ALPHA:CGFloat = 0.2
    let OPAQ: CGFloat = 1.0
    let MAX_PENALTIES = 3
    
    var timer:NSTimer!
    var penalties = 0
    var monsterHappy = false
    var currentItem: UInt32 = 0
    
    var musicPlayer: AVAudioPlayer!
    var sfxBite: AVAudioPlayer!
    var sfxHeart: AVAudioPlayer!
    var sfxSkull: AVAudioPlayer!
    var sfxDeath: AVAudioPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        heartImage.droppedTarget = monsterImg
        foodImage.droppedTarget = monsterImg
        resetPenalties()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.itemDroppedOnTarget(_:)), name: "targetDropped", object: nil)
    
        do {
            
            try musicPlayer = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("cave-music", ofType: "mp3")!))
            try sfxBite = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("bite", ofType: "wav")!))
            try sfxHeart = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("heart", ofType: "wav")!))
            try sfxDeath = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("death", ofType: "wav")!))
            try sfxSkull = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("skull", ofType: "wav")!))
            
            musicPlayer.prepareToPlay()
            musicPlayer.play()
            
            sfxBite.prepareToPlay()
            sfxHeart.prepareToPlay()
            sfxDeath.prepareToPlay()
            sfxSkull.prepareToPlay()
            
        }catch let err as NSError {
            print(err.debugDescription)
        }
        
        startTimer()
    }

    func itemDroppedOnTarget(notif: AnyObject) {
        monsterHappy = true
        startTimer()
        
        if currentItem == 0 {
            sfxHeart.play()
        }else {
            sfxBite.play()
        }
        
        foodImage.alpha = DIM_ALPHA
        foodImage.userInteractionEnabled = false
        heartImage.alpha = DIM_ALPHA
        heartImage.userInteractionEnabled = false
    }
    
    func startTimer() {
        
        if timer != nil {
            timer.invalidate()
        }
        
        timer = NSTimer.scheduledTimerWithTimeInterval(3.0, target: self, selector: #selector(ViewController.changeGameState), userInfo: nil, repeats: true)
        
    }
    
    func changeGameState() {
        
        if !monsterHappy {
            penalties += 1
            
            sfxSkull.play()
            
            if penalties == 1 {
                penalty1Img.alpha = OPAQ
                penalty2Img.alpha = DIM_ALPHA
            }else if penalties == 2 {
                penalty2Img.alpha = OPAQ
                penalty3Img.alpha = DIM_ALPHA
            }else if penalties >= 3 {
                penalty3Img.alpha = OPAQ
            }else {
                resetPenalties()
            }
            
            if(penalties >= MAX_PENALTIES) {
                gameOver()
            }
        }
        
        let random = arc4random_uniform(2)
        if random == 0 {
            foodImage.alpha = DIM_ALPHA
            foodImage.userInteractionEnabled = false
            heartImage.alpha = OPAQ
            heartImage.userInteractionEnabled = true
            
        }else {
            
            heartImage.alpha = DIM_ALPHA
            heartImage.userInteractionEnabled = false
            foodImage.alpha = OPAQ
            foodImage.userInteractionEnabled = true
        }
        
        currentItem = random
        monsterHappy = false
        
    }
    
    func gameOver() {
        timer.invalidate()
        sfxDeath.play()
        monsterImg.playDeathAnimation()
    }
    
    func resetPenalties() {
        penalty1Img.alpha = DIM_ALPHA
        penalty2Img.alpha = DIM_ALPHA
        penalty3Img.alpha = DIM_ALPHA

    }
    


}

