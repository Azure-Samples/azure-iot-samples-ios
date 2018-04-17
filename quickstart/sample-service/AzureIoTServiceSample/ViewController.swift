// Copyright (c) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE file in the project root for full license information.

import UIKit
import AzureIoTHubServiceClient
import Foundation

class ViewController: UIViewController {
    //Put you connection string and deviceID here
    //private let connectionString = "[IoTHub Connection String]"
    private let connectionString = "";
    private var service_client_handle: IOTHUB_SERVICE_CLIENT_AUTH_HANDLE!;
    private var iot_msg_handle: IOTHUB_MESSAGING_HANDLE!;
    
    @IBOutlet weak var txtDeviceId: UITextField!
    @IBOutlet weak var txtMessage: UITextField!
    @IBOutlet weak var txtOutput: UITextField!
    @IBOutlet weak var btnSend: UIButton!
    @IBOutlet weak var clearMsgBtn: UIButton!

    // Timers used to control message and polling rates
    var timerCleanup: Timer!
    var timerDoWork: Timer!
    
    // IoT hub handle
    private var serviceClientHandle: IOTHUB_SERVICE_CLIENT_AUTH_HANDLE!;
    
    /// Check for waiting messages and send any that have been buffered
    @objc func dowork() {
        IoTHubMessaging_LL_DoWork(iot_msg_handle)
    }
    
    func closeIothub()
    {
        IoTHubMessaging_LL_Close(iot_msg_handle);
        IoTHubMessaging_LL_Destroy(iot_msg_handle);
        IoTHubServiceClientAuth_Destroy(service_client_handle);
    }

    /// Display an error message
    ///
    /// parameter message: The message to display
    /// parameter startState: Start button will be set to this state
    /// parameter stopState: Stop button will be set to this state
    func showError(message: String, sendState: Bool) {
        btnSend.isEnabled = sendState;
        txtOutput.text = message;
        print(message);
    }
    
    override func viewDidLoad() {
        service_client_handle = IoTHubServiceClientAuth_CreateFromConnectionString(connectionString);
        if (service_client_handle == nil) {
            showError(message: "Failed to create IoT Service handle", sendState: false);
        }
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    let mySendCompleteCallback: IOTHUB_SEND_COMPLETE_CALLBACK = { userContext, msgResult in
        var mySelf: ViewController = Unmanaged<ViewController>.fromOpaque(userContext!).takeUnretainedValue()
        
        if (msgResult == IOTHUB_MESSAGING_OK)
        {
            mySelf.txtOutput.text = "Message has been delivered to the device";
        }
        else
        {
            mySelf.txtOutput.text = "Message has failed to be delivered";
        }
        mySelf.timerDoWork?.invalidate();
        mySelf.btnSend.isEnabled = true;
    }
    
    func openIothubMessaging() -> Bool
    {
        print("In openIotHub messaging")
        let result: Bool;
        iot_msg_handle = IoTHubMessaging_LL_Create(service_client_handle);
        let testValue : Any? = iot_msg_handle;
        if (testValue == nil) {
            showError(message: "Failed to create IoT Messaging", sendState: false);
            result = false;
        }
        else
        {
            // Open the messaging value
            if (IoTHubMessaging_LL_Open(iot_msg_handle, nil, nil) != IOTHUB_MESSAGING_OK) {
                showError(message: "Failed to open IoT Messaging", sendState: false);
                result = false;
            }
            else
            {
                result = true;
            }
        }
        return result;
    }
    
    // UI elements
    @IBAction func sendMsgBtn(_ sender: Any)
    {
        btnSend.isEnabled = false;

        let testValue : Any? = iot_msg_handle;
        if (testValue == nil && !openIothubMessaging() ) {
            print("Failued to open IoThub messaging");
        }
        else {
            // Timer for message sends and timer for message polls
            timerDoWork = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(dowork), userInfo: nil, repeats: true);

            let strCurrMsg: String! = txtMessage.text;
            let msg_handle: IOTHUB_MESSAGE_HANDLE! = IoTHubMessage_CreateFromByteArray(strCurrMsg, strCurrMsg.utf8.count);
            let msgTestValue : Any? = msg_handle;
            if (msgTestValue == nil) {
                showError(message: "Failed to create IoT Message handle", sendState: false);
            }
            else {
                // Mangle my self pointer in order to pass it as an UnsafeMutableRawPointer
                let that = UnsafeMutableRawPointer(Unmanaged.passUnretained(self).toOpaque())

                if (IoTHubMessaging_LL_Send(iot_msg_handle, txtDeviceId.text, msg_handle, mySendCompleteCallback, that) != IOTHUB_MESSAGING_OK) {
                    IoTHubMessaging_LL_Close(iot_msg_handle);
                    showError(message: "Failed to send IoT Messaging", sendState: false);
                }
                else
                {
                    txtOutput.text = "Message has been queued";
                }
                // Clean up the message
                IoTHubMessage_Destroy(msg_handle);
            }
        }
    }
    
    @IBAction func clearMsgBtnPress(_ sender: Any)
    {
        txtOutput.text = "";
        txtMessage.text = "";
    }
}

