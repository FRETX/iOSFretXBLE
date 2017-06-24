# iOSFretXBLE
An iOS framework for easily handling the BLE connection with the FretX device

### Usage:
Implement `FretxProtocol` in your `UIViewController`. Then assign it as the delegate to the shared instance of the `FretxBLE` object

```
class ViewController: UIViewController, FretxProtocol {
    
    var fretx = FretxBLE.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        fretx.delegate = self
        
    }
}
```

To conform with the protocol, you must overload three functions:

```
    public func didConnect() {
    }
    
    public func didDisconnect() {
    }
    
    public func didBLEStateChange(state: CBManagerState) {
    }
 ```
 
 Start a scan and automatically connect to the FretX device when it's found (powered on) with:
 
 ```
 fretx.connect()
 ```
 
 Change the lights on the FretX device with:
 ```
 fretx.send(fretCodes: [46,35,24,12,01,41,32,23,15,06])
 ```
 
 The array to be used in `fretx.send()` is a `[UInt8]`. Each element is a two-digit number, where the first digit corresponds to the fret, and the second digit corresponds to the string. Valid values are:
 
 ```
 Frets: 0,1,2,3,4
 Strings: 1,2,3,4,5,6
 ```
 
 where the `0`th fret indicates an "open string", i.e. the blue light on the FretX device. 
 
You can clear the LED matrix (turn off all the lights) with:
```
fretx.clear()
```
