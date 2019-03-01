# putnzonthemap

A `< 5k` custom Flutter application to rally to John Oliver's cry to please help
the country of New Zealand be recognized on maps.

## Testing

The application runs on both Android and iOS.  It has been tested on the 
iOS simulators for an iPhone XS and XR with iOS 12.1, the Android Emulator using
the default Pixel 2 XL specs, and a hardware Pixel 3 XL device with Android 9.

## Inspiration

This project was inspired by plea by John Oliver for people to please ensure 
that Maps includes the country of New Zealand, the plea can be viewed
[here](https://www.youtube.com/watch?v=6dlMDnT_P1E).

## How to Use

The application is fairly straight forward.  It includes a list of maps that 
have, unfortunately, left poor New Zealand out of the picture.  All you have to
do is select a map from the list and tap approximately where New Zealand should
be to correct things.  You will be rewarded by a very satisfying animation of
slapping New Zealand on the map, plus you will get an encouraging green check on
the master list to let you know you've made things right for that map.

The application does not persist state across launches so if you kill it and
relaunch, you will be asked to please help the citizens of New Zealand out once
more by please fixing the maps of the world.

There's a relatively strong bottom-right bias in the tap area for placing New
Zealand.  If you're ever unsure that you are putting the country where it really
belongs, trend down and to the right and the application will help you out.

## Credits

I'd like to give a shout out to the developer of the amazing 
[photo_view](https://pub.dartlang.org/packages/photo_view) without which this
application could not have been successfully built within the contest's limits.

Credits to the team behind John Oliver's Last Week Tonight for the inspiration.

Finally, credits to the folks who have contributed to the
[World Maps Without New Zealand](http://worldmapswithoutnewzealand.tumblr.com/)
Tumblr which was the source for the maps in the application.