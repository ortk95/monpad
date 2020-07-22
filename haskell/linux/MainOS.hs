{-# OPTIONS_GHC -Wno-orphans #-}
module MainOS (main) where

import Data.Bool (bool)
import Data.Int (Int32)
import Data.Text.Encoding (encodeUtf8)
import Dhall (Generic, FromDhall)

import Evdev
import Evdev.Codes

import Monpad

main :: IO ()
main = do
    args' <- getCommandLineArgs args
    server defaultConfig
        { args = args'
        , onNewConnection = \c@(ClientID i) -> do
            _ <- onNewConnection c
            fmap (,()) $ newUDevice $ encodeUtf8 i
        , onMessage = \update _ -> onMessage update ()
        , onAxis = \a x dev () -> writeBatch dev
            [AbsoluteEvent a $ EventValue $ translate x]
        , onButton = \key up dev () -> writeBatch dev
            [KeyEvent key $ bool Released Pressed up]
        , onDroppedConnection = \cid _ -> onDroppedConnection cid ()
        }
  where ServerConfig{..} = defaultConfig

-- input is in [-1,1], output in [0,255]
translate :: Double -> Int32
translate x = round $ (x + 1) * 255 / 2

deriving instance Generic Key
deriving instance FromDhall Key
deriving instance Generic AbsoluteAxis
deriving instance FromDhall AbsoluteAxis
