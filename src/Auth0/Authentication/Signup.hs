{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE DuplicateRecordFields #-}

module Auth0.Authentication.Signup where

---------------------------------------------------------------------------------
import Control.Monad.Catch (MonadThrow)
import Control.Monad.IO.Class (MonadIO)
import Data.Aeson
import Data.Aeson.Types
import Data.Map
import Data.Text
import GHC.Generics
---------------------------------------------------------------------------------
import Auth0.Request
import Auth0.Types
---------------------------------------------------------------------------------

-- POST /dbconnections/signup

data Signup
  = Signup
  { clientId     :: ClientId
  , email        :: Text
  , password     :: Text
  , connection   :: Text
  , userMetadata :: Maybe (Map Text Text)
  } deriving (Generic)

instance ToJSON Signup where
  toJSON =
    genericToJSON defaultOptions { fieldLabelModifier = camelTo2 '_' }

data SignupResponse
  = SignupResponse
  { _id           :: Text
  , emailVerified :: Bool
  , email         :: Text
  } deriving (Generic)

instance FromJSON SignupResponse where
  parseJSON =
    genericParseJSON defaultOptions { fieldLabelModifier = camelTo2 '_' }

runSignup
  :: (MonadIO m, MonadThrow m)
  => Host -> Signup -> m (Int, Maybe SignupResponse)
runSignup h o =
  let api = API Post "/dbconnections/signup"
  in execRequest h api () o Nothing