let AllOS = ./lib/all-os.dhall

let monpad = ./lib/monpad.dhall AllOS.Axis AllOS.Button

let Evdev = ./lib/evdev.dhall

let ButtonL = AllOS.ButtonLinux

let ButtonW = {}

let axis =
      λ(a : Evdev.AbsAxis) →
      λ(multiplier : Double) →
        { linux = { axis = Evdev.Axis.Abs a, multiplier }
        , windows = {=}
        , mac = {=}
        }

let button =
      λ(x : Integer) →
      λ(y : Integer) →
      λ(linux : ButtonL) →
      λ(windows : ButtonW) →
      λ(name : Text) →
      λ(colour : monpad.Colour) →
        { element =
            monpad.Element.Button
              { buttonData = { linux, windows, mac = {=} }
              , colour
              , shape = monpad.Shape.Circle 120
              }
        , location = { x, y }
        , name
        , showName = None monpad.TextStyle
        }

in    { elements =
        [ button +250 +0 ButtonL.BtnWest {=} "Blue" monpad.cols.blue
        , button +500 -250 ButtonL.BtnSouth {=} "Green" monpad.cols.green
        , button +750 +0 ButtonL.BtnEast {=} "Red" monpad.cols.red
        , button +500 +250 ButtonL.BtnNorth {=} "Yellow" monpad.cols.yellow
        , { element =
              monpad.Element.Button
                { buttonData =
                  { linux = ButtonL.BtnMode, windows = {=}, mac = {=} }
                , colour = monpad.cols.white
                , shape = monpad.Shape.Circle 80
                }
          , location = { x = +0, y = -300 }
          , name = "M"
          , showName = Some monpad.defaultTextStyle
          }
        , { element =
              monpad.Element.Stick
                { radius = 120
                , range = 320
                , stickColour = monpad.cols.white
                , backgroundColour = monpad.cols.grey
                , stickDataX = axis Evdev.AbsAxis.AbsX 255.0
                , stickDataY = axis Evdev.AbsAxis.AbsY -255.0
                }
          , location = { x = -500, y = +0 }
          , name = "Stick"
          , showName = None monpad.TextStyle
          }
        ]
      , viewBox = { x = -1000, y = -500, w = +2000, h = +1000 }
      , backgroundColour = monpad.cols.pastelBlue
      , name = "default"
      }
    : monpad.Layout
