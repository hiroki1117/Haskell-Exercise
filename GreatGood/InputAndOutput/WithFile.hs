import System.IO
import Control.Exception

main :: IO ()
main = do
    withFile2 "simple.txt" ReadMode $ \handle -> do
        contents <- hGetContents handle
        putStr contents
        
withFile2 :: FilePath -> IOMode -> (Handle -> IO a) -> IO a
withFile2 name mode f = bracket (openFile name mode) (\handle -> hClose handle) (\handle -> f handle)
