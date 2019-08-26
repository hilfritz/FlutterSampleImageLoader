# imageloader_sample

A Simple Flutter project that loads images from the server, downloads them in the background and displays in a Grid.

## Usage

- Open the app named "imageloader_sample"

- Just tap Tap and Hold 
- (To start from empty list, kill the app first before opening again)
- Apk Install link is [here](https://github.com/hilfritz/FlutterSampleImageLoader/blob/master/build/app/outputs/apk/debug/app-debug.apk?raw=true)

## Code Architecture

Usage of a **modified Clean Architecture** code pattern.  Though there is only 1 usecaes of now, this Architecture's usage of usecases will offer better code reusability and structure as an app grows bigger.

### Download of Images in background
- The app uses Native Android's WorkManager to download the images, this also covers doing the process in the background thread *(No need to create a service manually)*. For iOS support, to be implemented in the future.

-  _Download Feature - if suddently device got no internet connection, the app will add the download task into queue. Whenever the device gets good internet connection, the app will continue loading the image_
-  After each image is fetched from the api, the usecase accepts the image byte data from background process and passes it to the foreground UI for displaying.

### *The project is not configured yet to run on iOS devices.


