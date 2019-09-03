//
//  Synth.swift
//  Piano
//
//  Created by Evan Murray on 8/29/19.
//  Copyright © 2019 Evan's Repo. All rights reserved.
//

import Foundation
import CoreAudio
import AudioKit

final class Synth: Speaker {
    override init() {
        super.init()
        initAudio()
        loadSoundFont()
        loadPatch(patchNo: 10)
    }
    
    var octave = 4
    let midiChannel = 0
    let midiVelocity = UInt8(127)
    
    func playNoteOn(channel: Int, note: UInt8, midiVelocity: Int) {
        let noteCommand = UInt32(0x90 | channel)
        let base = note - 48
        let octaveAdjust = (UInt8(octave) * 12) + base
        let pitch = UInt32(octaveAdjust)
        checkError(osstatus: MusicDeviceMIDIEvent(synthUnit!, noteCommand, pitch, UInt32(midiVelocity), 0))
    }
    
    func playNoteOff(channel: Int, note: UInt32, midiVelocity: Int) {
        let noteCommand = UInt32(0x80 | channel)
        let base = UInt8(note - 48)
        let octaveAdjust = (UInt8(octave) * 12) + base
        let pitch = UInt32(octaveAdjust)
        checkError(osstatus: MusicDeviceMIDIEvent(synthUnit!, noteCommand, pitch, 0, 0))
    }
}
 
