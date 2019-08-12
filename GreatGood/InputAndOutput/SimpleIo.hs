import System.IO

main :: IO ()
main = do
    handle <- openFile "simple.txt" ReadMode
    contents <- hGetContents handle
    putStr contents
    hClose handle
