//
//  Speaker.swift
//  Piano
//
//  Created by Evan Murray on 6/3/19.
//  Copyright © 2019 Evan's Repo. All rights reserved.
//

import Foundation
import AudioToolbox

class Speaker {
   
    var audioGraph: AUGraph?
    var synthNode = AUNode()
    var outputNode = AUNode()
    var synthUnit: AudioUnit?
    var patch = UInt32(10)
    
    func initAudio() {
        checkError(osstatus: NewAUGraph(&audioGraph))
        createOuputNode()
        createSynthNode()
        checkError(osstatus: AUGraphOpen(audioGraph!))
        checkError(osstatus: AUGraphNodeInfo(audioGraph!, synthNode, nil, &synthUnit))
        let synthOutputElement: AudioUnitElement = 0
        let ioInputElement: AudioUnitElement = 0
        checkError(osstatus: AUGraphConnectNodeInput(audioGraph!, synthNode, synthOutputElement, outputNode, ioInputElement))
        checkError(osstatus: AUGraphInitialize(audioGraph!))
        checkError(osstatus: AUGraphStart(audioGraph!))
        loadSoundFont()
        loadPatch(patchNo: 10)
    }
    
    func createOuputNode() {
        var cd = AudioComponentDescription(
        componentType: OSType(kAudioUnitType_Output),
        componentSubType: OSType(kAudioUnitSubType_RemoteIO),
        componentManufacturer: OSType(kAudioUnitManufacturer_Apple),
        componentFlags: 0, componentFlagsMask: 0
        )
        checkError(osstatus: AUGraphAddNode(audioGraph!, &cd, &outputNode))
    }
    
    func createSynthNode() {
        var cd = AudioComponentDescription(
        componentType: OSType(kAudioUnitType_MusicDevice),
        componentSubType: OSType(kAudioUnitSubType_MIDISynth),
        componentManufacturer: OSType(kAudioUnitManufacturer_Apple),
        componentFlags: 0, componentFlagsMask: 0
        )
        checkError(osstatus: AUGraphAddNode(audioGraph!, &cd, &synthNode))
    }
    
    func loadSoundFont() {
       var bankURL = Bundle.main.url(forResource: "FluidR3_GM", withExtension: "sf2")
        checkError(osstatus: AudioUnitSetProperty(synthUnit!, AudioUnitPropertyID(kMusicDeviceProperty_SoundBankURL), AudioUnitScope(kAudioUnitScope_Global), 0, &bankURL, UInt32(MemoryLayout<URL>.size)))
    }
    
    func loadPatch(patchNo: Int) {
        let channel = UInt32(0)
        var enabled = UInt32(1)
        var disabled = UInt32(0)
        patch = UInt32(patchNo)
        checkError(osstatus: AudioUnitSetProperty(synthUnit!, AudioUnitPropertyID(kAUMIDISynthProperty_EnablePreload), AudioUnitScope(kAudioUnitScope_Global), 0, &enabled, UInt32(MemoryLayout<UInt32>.size)))
        
        let programChangeCommand = UInt32(0xC0 | channel)
        checkError(osstatus: MusicDeviceMIDIEvent(self.synthUnit!, programChangeCommand, patch, 0, 0))
        
        checkError(osstatus: AudioUnitSetProperty(synthUnit!, AudioUnitPropertyID(kAUMIDISynthProperty_EnablePreload), AudioUnitScope(kAudioUnitScope_Global), 0, &disabled, UInt32(MemoryLayout<UInt32>.size)))
        
        checkError(osstatus: MusicDeviceMIDIEvent(self.synthUnit!, programChangeCommand, patch, 0, 0))
        
    }
    
    func checkError(osstatus: OSStatus) {
        if osstatus != noErr {
            print(SoundError.GetErrorMessage(osstatus))
        }
    }
    
}
