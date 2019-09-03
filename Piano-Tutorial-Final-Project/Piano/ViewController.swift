import UIKit
import AudioKit
import AudioKitUI
import AudioToolbox

//A view controller is the window through which a user views the app elements; without it, the screen would just be black/white
class ViewController: UIViewController {
    
    let synth = Synth()

    //This function loads the view controller (window through which users view app elements)
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setSpeakersAsDefaultAudioOutput()
        loadVoices()
        loadKeyboard()
        //Remember how I told you guys that you can name functions whatever you want

        
    }
    
    // work around for when some devices only play through the headphone jack
    func setSpeakersAsDefaultAudioOutput() {
        do {
            try
        AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playAndRecord, options: AVAudioSession.CategoryOptions.defaultToSpeaker)
        }
        catch {
            // hard to imagine how we'll get this exception
            let alertController = UIAlertController(title: "Speaker Problem", message: "You may be able to hear sound using headphones.", preferredStyle: UIAlertController.Style.alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                (result: UIAlertAction) -> Void in
            }
            
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    //We need to define a function before we call it
    func loadKeyboard() {
        //Were going to set a new variable that is the actual piano keyboard
        //We need to define something, our keyboard in this case, in order for it to appear
        let keyboardView = AKKeyboardView(frame: ScreenControl.manageSize(rect: CGRect(x: 0, y:200, width: 800, height: 250)))
        //Finally, we need to add our new keyboardView to our View Controller for it to appear
        self.view.addSubview(keyboardView)
        keyboardView.delegate = self
        keyboardView.polyphonicMode = true
    }
    
    func loadVoices() {
        DispatchQueue.global(qos: .background).async {
            self.synth.loadPatch(patchNo: 10)
            DispatchQueue.main.async {
                
            }
        }
    }


}

extension ViewController: AKKeyboardDelegate {
    
    func noteOn(note: MIDINoteNumber) {
        synth.playNoteOn(channel: 0, note: note, midiVelocity: 127)
    }
    
    func noteOff(note: MIDINoteNumber) {
        synth.playNoteOff(channel: 0, note: UInt32(note), midiVelocity: 127)
    }
}

