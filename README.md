# JPWeather
 A weather app that integrates with OpenWeather. It started as a coding challenge, but I’ll be evolving this project with better aesthetics and I’ll use it to dive deeper into SwiftUI and its integrations with SpriteKit and other frameworks I’ve used in previous work. 

# Instructions to run
Clone the repo into your local directory. We are using two Swift Managed Packages, which Xcode will need a little bit of time to install. There’s no Cocoapods usage, and I minimized our dependencies to external frameworks when possible (and prudent for the purposes of this exercise)

Also, if you plan to run this on your device, make sure there's an appropriate code signing team selected, etc. etc. 

## Attention
Since the app requires an OpenWeather API KEY, you **NEED** to create your own `secrets.xcconfig` file. The contents of the file are straightforward. 

```
OPENWEATHER_API_KEY = <ENTER YOUR KEY HERE>
```

That’s it. There should be a missing link to this file in the XCode project. Just add the file at the root directory of the project and everything should work as designed. There's a .gitignore callout for this file specifically in order to stop me from accidentally committing the credentials. 

## Notes
The repo fulfills the requirements (except explicit use of Size classes, as our UI is simple enough that SwiftUI’s native resizing does the job well), but takes some liberties in our interpretation of them. For example:
1) There's no need to force the user to always load the location data in order to retrieve the weather data just because we have permission to do so. We've instead configured that as a setting, making it the user's choice to drain their battery by constantly polling GPS.
2) There's a UIKit view "integrated" into the project, but it's definitely a straightforward case. UIKit/SwiftUI integration shines (read: is incredibly frustrating and heartwrenching) when you need to handle custom designs and animations that SwiftUI *just* can't do at this time. (**coughs** Collection Views **coughs**)


That being said, there are a number of quirks and bugs I’ll fix when able: 

~~1) CoreLocation-based data retrieval is abysmally slow. In working with the new async/await concurrency model, the library I’m using requires that its main object be created on the main thread. I’m doing this twice (which is redundant but I needed to get this project out asap) as well, which inherently slows things down performance a lot. ~~ Fixed in version 0.2.1
2) Had plans to implement caching for some of our JSON objects, but simply ran out of time and other things were important to implement. 
~~3) No unit tests nor UI tests. Again, sacrificed to meet deadlines, but I did try to capture gracefully most errors that I could foresee.  ~~ Fixed in version 0.2.1
4) Selecting a location in search triggers a warning on the console that goes `**=== AttributeGraph: cycle detected through attribute**`. I suspect this is because we’re not handling the dismissal of the search bar well enough, and there’s a subtle conflict between that UI action and the app switching tabs and reloading the screen (ahh, a SwiftUI quirk). There’s definitely a proper, SwiftUI compliant way to ensure this doesn’t happen. However, deadlines and exhaustion have forced a repriotarization of tasks to complete, and there's no apparent impact on performance as far as I can see so ¯\_(ツ)_/¯. 
