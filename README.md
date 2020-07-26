
# Monpad

Monpad allows you to use touchscreen devices remotely as inputs to your computer, via a web interface. While initially designed to emulate gamepads, it is highly customisable - for example, you could use it to set up your phone as a wireless keyboard or mouse.

While touchscreen controls are probably too fiddly for particularly serious/complex games, Monpad is ideal for 'party' games, where relatively few buttons/joysticks are required, and the player limit is often much higher than the number of controllers one is likely to own.

![](screenshots/default.png)
![](screenshots/numpad.png)
![](screenshots/sliders.png)

Prerequisites:
--------------

[Haskell](https://www.haskell.org/):
- `cabal` ≥ 3.2
- `ghc` ≥ 8.10.1

[Elm](https://elm-lang.org/):
- `elm` ≥ 0.19.1

You will need permissions to write to `/dev/uinput`.

Build
-----

If you haven't done so before, run `cabal update` to grab the latest package index from [Hackage](https://hackage.haskell.org/).

Run `./Build.hs` to build. The first time you run this, it could take a while, as `cabal` will need to download and build all dependencies.

Run
---

Run `./dist/monpad` to start the server (you can pass the `-h` flag to see all options).

Then connect from your web browser:
- From the same device, you can navigate to eg. `http://localhost:8000/monpad`.
- From another device on the same network, connect with your local ip, instead of `localhost`.
- Allowing connections from an external or unsecured network is strongly discouraged, since no security features are yet implemented.

Note that the `monpad` binary is self-contained - you can move it to any location you wish.

Customise
---------

The controller layout and button/axis mapping can be fully customised using [Dhall](https://dhall-lang.org/). Examples are [in this repository](https://github.com/georgefst/monpad/tree/master/dhall). Note that some of these files import each other by relative path, so they are best kept together.

Compatibility
-------------

The server just creates a `uinput` device, which is not enough to be picked up by many games. Until [we find a better solution](https://github.com/georgefst/monpad/issues/4), it is recommended to use [xboxdrv](https://xboxdrv.gitlab.io/) to emulate an Xbox controller. For Monpad's default layout, you will need to run `xboxdrv --evdev /dev/input/eventX --evdev-debug --evdev-keymap KEY_R=b, KEY_G=a,KEY_B=x,KEY_Y=y --evdev-absmap ABS_X=x1,ABS_Y=y1` for each device, replacing `eventX` with the location of the device. This should allow Monpad to be used with almost all Steam games, for example.

Due to the use of some bleeding-edge Web APIs, at time of writing, the client only really works satisfactorily on Firefox Beta for Android:
- The *pointer events* API is unreliable in Chrome (offsets are reported wrong), and in beta in Firefox.
- Firefox does not currently give permission to switch to fullscreen on a change of rotation.

There is currently no Windows support, but [it's very much on the roadmap](https://github.com/georgefst/monpad/issues/5).
