//
//  MainMenuScene.swift
//  Word Search
//
//  Created by Mike Stoltman on 2020-05-11.
//  Copyright © 2020 Mike Stoltman. All rights reserved.
//

import SpriteKit

class MainMenuScene: SKScene {
    
    private var backgroundNodes: [[MainMenuBackgroundNode]] = []
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        var screenLength: CGFloat = 0
        if size.width > size.height {
            screenLength = size.width
        }else{
            screenLength = size.height
        }
        
        let cellLength: CGFloat = (screenLength / 10)
        
        for i in 0...10 {
            var nodes: [MainMenuBackgroundNode] = []
            
            let xPosition: CGFloat = CGFloat(-1.0 * (screenLength / 2.0)) + (cellLength * CGFloat(i))
            
            for j in 0...10 {
                let yPosition: CGFloat = (screenLength / 2.0) - (cellLength * CGFloat(j))
                
                let node = MainMenuBackgroundNode()
                node.position.x = xPosition
                node.position.y = yPosition
                
                let shapeNode = SKShapeNode(rectOf: CGSize(width: cellLength, height: cellLength))
                shapeNode.lineWidth = 0.0
                shapeNode.zPosition = 1.0
                
                if i % 2 == 0 {
                    if j % 2 == 0 {
                        shapeNode.fillColor = UIColor.lightGray
                    }else{
                        shapeNode.fillColor = UIColor.white
                    }
                }else{
                    if j % 2 == 0 {
                        shapeNode.fillColor = UIColor.white
                    }else{
                        shapeNode.fillColor = UIColor.lightGray
                    }
                }
                node.shapeNode = shapeNode
                node.addChild(shapeNode)
                
                let labelNode = SKLabelNode(text: nil)
                labelNode.fontSize = (cellLength / 2)
                labelNode.fontColor = UIColor.darkGray
                labelNode.fontName = UIFont.boldSystemFont(ofSize: 0.0).fontName
                labelNode.zPosition = 2.0
                labelNode.horizontalAlignmentMode = .center
                labelNode.verticalAlignmentMode = .center
                if let letter = Alphabet.letters.randomElement() {
                    labelNode.text = letter
                }else{
                    labelNode.text = "?"
                }
                node.labelNode = labelNode
                node.addChild(labelNode)
                
                nodes.append(node)
                
                addChild(node)
            }
            backgroundNodes.append(nodes)
        }
        
        
    }
    
}
