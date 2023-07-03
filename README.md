**Demo:**

https://github.com/iosdevelopmentzp/zonalchallenge/assets/45419384/ebd24184-3904-46e3-9bf6-3813dc386efd

Zonal iOS Technical Assessment
==============================

About
-----

With space tourism such a hot topic currently, Zonal has decided to capitalise on the moment and has begun development on an app within which users can find out more information about their galaxy. Unfortunately, during a fact finding mission, the development team were lost to a black hole. Our last communication with their ship indicated they had asked Siri to "go back home", and, well, clearly Siri misunderstood. We've filled a bug with Apple in the meantime. We remain hopeful our developers are alive within the black hole, but development of the app must continue.

Before they went into orbit, the development team handed over a basic proof of concept that had been created, based on a finite universe first, namely, the Star Wars universe. As this is the last codebase we have from the developers, and given the apparent risks of developing in space, Zonal has agreed that we should complete development of our Star Wars based proof of concept, before risking more spaceships.

The codebase has been verified to run on an iPhone, and functionally displays some basic information about planets from Star Wars. A message from one of the devs mentioned that there was some optimisation required on the codebase, but the app behaves as expected on an iPhone so we are not sure what they were referring to.


Assessment
----------

Included in this archive is an Xcode project, named StarWarsAPIViewer. This is a basic iOS app which pulls data from the Star Wars API, also known as [SWAPI](https://swapi.dev).

The current implementation launches the app, and offers a button to view information about all planets found within the Star Wars universe.

For this assessment, we are looking for you to improve the existing project by adding some features. These are:
    - Add a way to view detail about an individual planet when tapping on an entry in the all planets list
    - Implement a way for a user to refresh the data shown on screen
    - Extend or improve the project in any way you feel is appropriate. This can be anything from refactoring Objective-C to Swift, migrating to SwiftUI, increasing test coverage etc

Please do not spend more than five hours on these tasks. We know that this may not be enough time to complete all these tasks, and we do not expect all tasks to be completed. We are more interested in your approach to developing these features, rather than how many lines of code you can produce within a given timeframe.

Submitting
----------

Submission of your work can be done by either linking us to your public repository (i.e. Github, Bitbucket, etc) if applicable, or by zipping the project and sending to Zonal via email.

After you have submitted your work, we will arrange a catch-up with you, where we will ask you to walk us through your changes to this project.

Technical Requirements
----------------------

The project is built using Xcode 12.5.1, with iOS 14.5 as the minimum deployment level. The app currently runs on iPhone. Further documentation about SWAPI endpoints can be found on the website, https://swapi.dev

If you have any questions or issues with the code, or this assessment, please contact Matt Brooks(matt.brooks@zonal.co.uk) or Scott Runciman(scott.runciman@zonal.co.uk)
