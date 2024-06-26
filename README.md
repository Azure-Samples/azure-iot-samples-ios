---
page_type: sample
languages:
- swift
products:
- azure
- azure-iot-hub
description: "A set of easy-to-understand, continuously-tested samples for connecting to Azure IoT Hub via Azure/azure-iot-sdk-c/CocoaPod."
---

# Azure IoT samples for iOS platform

azure-iot-samples-iot provides a set of easy-to-understand, continuously-tested samples for connecting to Azure IoT Hub via Azure/azure-iot-sdk-c/CocoaPod

## Prerequisites

- This repository cloned or downloaded onto your development machine.
- An IoT hub in your Azure subscription. If you don't have an IoT hub, follow the steps in [Create an IoT hub](https://learn.microsoft.com/azure/iot-hub/iot-hub-create-through-portal).
- A device registered in your IoT hub. If you don't have a device, follow the steps in [Create and manage device identities](https://learn.microsoft.com/en-us/azure/iot-hub/create-connect-device) to register a device and retrieve its device connection string.
- The latest version of [XCode](https://developer.apple.com/xcode/), running the latest version of the iOS SDK. This quickstart was tested with XCode 9.3 and iOS 11.3.
- The latest version of [CocoaPods](https://guides.cocoapods.org/using/getting-started.html).

## Simulate an IoT device

In this section, you simulate an iOS device running a Swift application to receive cloud-to-device messages from the IoT hub. 

### Install CocoaPods

CocoaPods manages dependencies for iOS projects that use third-party libraries.

In a terminal window, navigate to the folder containing this repository on your development machine. Then, navigate to the sample project folder:

```sh
cd quickstart/sample-device
```

Make sure that XCode is closed, then run the following command to install the CocoaPods that are declared in the **podfile** file:

```sh
pod install
```

Along with installing the pods required for your project, the installation command also created an XCode workspace file that is already configured to use the pods for dependencies.

### Run the sample device application

1. Retrieve the connection string for your device. You can copy this string from the [Azure portal](https://portal.azure.com) in the device details page, or retrieve it with the following CLI command:

   ```azurecli-interactive
   az iot hub device-identity connection-string show --hub-name {YourIoTHubName} --device-id {YourDeviceID} --output table
   ```

2. Open the sample workspace in XCode.

   ```sh
   open "MQTT Client Sample.xcworkspace"
   ```

3. Expand the **MQTT Client Sample** project and then folder of the same name.  

4. Open **ViewController.swift** for editing in XCode.

5. Search for the **connectionString** variable and update the value with the device connection string that you copied in the first step.

6. Save your changes.

7. Run the project in the device emulator with the **Build and run** button or the key combo **command + r**.

## Send a cloud-to-device message

You're now ready to receive cloud-to-device messages. Use the Azure portal to send a test cloud-to-device message to your simulated IoT device.

1. In the **iOS App Sample** app running on the simulated IoT device, select **Start**. The application starts sending device-to-cloud messages, but also starts listening for cloud-to-device messages.

2. In the [Azure portal](https://portal.azure.com), navigate to your IoT hub.

3. Select **Device management** > **Devices** from the IoT Hub menu.

4. On the **Devices** page, select the device ID for your simulated IoT device.

5. Select **Message to Device** to open the cloud-to-device message interface.

6. Write a plaintext message in the **Message body** text box, then select **Send message**.

7. Watch the app running on your simulated IoT device. It checks for messages from IoT Hub and prints the text from the most recent one on the screen. Your output should look like the following example:

## CocoaPods

* [AzureIoTHubClient](https://cocoapods.org/pods/AzureIoTHubClient) contains the [Azure IoT Hub Client](https://github.com/azure/azure-iot-sdk-c)
* [AzureIoTHubServiceClient](https://cocoapods.org/pods/AzureIoTHubServiceClient) contains the [Azure IoT Hub Service Client](https://github.com/azure/azure-iot-sdk-c)
* [AzureIoTUtility](https://cocoapods.org/pods/AzureIoTUtility) contains the [Azure IoT C Shared Utility library](https://github.com/Azure/azure-c-shared-utility)
* [AzureIoTuAmqp](https://cocoapods.org/pods/AzureIoTuAmqp) contains the [Azure IoT AMQP library](https://github.com/Azure/azure-uamqp-c)
* [AzureIoTuMqtt](https://cocoapods.org/pods/AzureIoTuMqtt) contains the [Azure IoT MQTT library](https://github.com/Azure/azure-umqtt-c)

## Resources

- [azure-iot-sdk-c](https://github.com/Azure/azure-iot-sdk-c): contains the source code for Azure IoT C SDK, as well as the platform specific adaption layer for iOS
