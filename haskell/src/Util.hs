module Util where

import Data.Bifunctor (Bifunctor (bimap))
import Data.List.Extra (firstJust)
import Data.Proxy (Proxy (Proxy))
import Data.Text (Text)
import qualified Data.Text as T
import GHC.TypeLits (KnownSymbol, symbolVal)
import Network.HostName (getHostName)
import Network.Socket (AddrInfo (addrAddress), HostAddress, SockAddr (SockAddrInet), getAddrInfo, hostAddressToTuple)
import System.Directory (listDirectory)
import System.FilePath ((</>))
import Type.Reflection (Typeable, typeRep)

symbolValT :: forall a. KnownSymbol a => Text
symbolValT = T.pack $ symbolVal $ Proxy @a

showT :: Show a => a -> Text
showT = T.pack . show

typeRepT :: forall a. Typeable a => Text
typeRepT = showT $ typeRep @a

biVoid :: Bifunctor p => p a b -> p () ()
biVoid = bimap (const ()) (const ())

untilLeft :: Monad m => m (Either e a) -> m e
untilLeft x = x >>= either pure (const $ untilLeft x)

mapRightM :: Monad m => (a -> m b) -> Either e a -> m (Either e b)
mapRightM f = either (return . Left) (fmap Right . f)

-- | Like 'listDirectory', but returns paths relative to the input.
listDirectory' :: FilePath -> IO [FilePath]
listDirectory' d = map (d </>) <$> listDirectory d

getLocalIp :: IO (Maybe HostAddress)
getLocalIp = do
    h <- getHostName
    sockAddrs <- map addrAddress <$> getAddrInfo Nothing (Just $ h <> ".local") Nothing
    pure $ flip firstJust sockAddrs \case
        SockAddrInet _ a -> Just a
        _ -> Nothing

-- adapted from an internal function of the same name in Network.Socket.Info
showHostAddress :: HostAddress -> Text
showHostAddress ip =
    let (u3, u2, u1, u0) = hostAddressToTuple ip
     in T.intercalate "." $ map showT [u3, u2, u1, u0]
