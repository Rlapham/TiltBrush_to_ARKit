# TiltBrush_to_ARKit
Workflow for bringing Tilt Brush assets into ARKit through Unity

Requirements to follow along
  * Unity v5.6.2+ 
  * Xcode beta 9+ 
  * Apple Developer ID
  * iOS device that supports ARKit (iOS 11+, processing chip A9+ --> i.e. iPhone 6S or later, iPad (2017)) 

General Steps
 * Import [Unity ARKit Plugin](https://www.assetstore.unity3d.com/en/#!/content/92515) & [Tilt Brush Unity SDK](https://github.com/googlevr/tilt-brush-toolkit)
 * Create a scene using ARKit's RemoteConnection & build to Xcode and to device
 * Bring in Tilt Brush Assets as .obj or .fbx files - add to scene. 
 * Test with RemoteConnection. Recommended to work from ARKit example scene (or bring in ARKit Camera Manager and Generate Planes, to position Tilt Brush assets in space). 
 * When completed, delete RemoteConnection and build to Xcode and to device again.

![doc1](https://github.com/Rlapham/TiltBrush_to_ARKit/blob/master/doc_images/doc1.png)
![doc2](https://github.com/Rlapham/TiltBrush_to_ARKit/blob/master/doc_images/doc2.png)
[![video doc](https://github.com/Rlapham/TiltBrush_to_ARKit/blob/master/doc_images/doc3.png)](https://www.youtube.com/watch?v=fr_N8ge6kpk&feature=youtu.be "Walkthrough")
