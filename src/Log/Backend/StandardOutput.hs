-- | Stdout logging back-end.
module Log.Backend.StandardOutput (
    simpleStdoutLogger
  , stdoutLogger
  , withSimpleStdOutLogger
  ) where

import Prelude
import Control.Exception
import qualified Data.Text.IO as T
import System.IO

import Log.Data
import Log.Internal.Logger
import Log.Logger

-- | Create a 'simpleStdoutlogger' for the duration of the given
-- action, making sure that stdout is flushed afterwards.
withSimpleStdOutLogger :: (Logger -> IO r) -> IO r
withSimpleStdOutLogger act = do
  logger <- stdoutLogger
  (act logger) `finally` (do { waitForLogger logger; shutdownLogger logger; })

{-# DEPRECATED simpleStdoutLogger "Use 'withSimpleStdOutLogger'" #-}

-- | Simple, synchronous logger that prints messages to standard output.
simpleStdoutLogger :: Logger
simpleStdoutLogger = Logger {
    loggerWriteMessage = T.putStrLn . showLogMessage Nothing
  , loggerWaitForWrite = hFlush stdout
  , loggerShutdown     = return ()
  }

{-# DEPRECATED stdoutLogger "Use 'withSimpleStdOutLogger'" #-}

-- | Create a logger that prints messages to standard output.
stdoutLogger :: IO Logger
stdoutLogger = mkLogger "stdout" $ T.putStrLn . showLogMessage Nothing
