import System.Environment
import System.Directory
import System.IO
import Data.List
import Control.Exception

dispatch :: String -> [String] -> IO ()
dispatch "add" = add
dispatch "view" = view
dispatch "remove" = remove

main = do
    (command:argList) <- getArgs
    dispatch command argList


add :: [String] -> IO ()
add [filename, todoItem] = appendFile filename (todoItem ++ "\n")

view :: [String] -> IO ()
view [filename] = do
    contents <- readFile filename
    let todoTasks = lines contents
        numberedTasks = zipWith (\n line -> show n ++ " - " ++ line)
                                [0..] todoTasks
    putStr $ unlines numberedTasks

remove :: [String] -> IO ()
remove [filename, numberString] = do
    contents <- readFile filename
    let todoTasks = lines contents
        numberedTasks = zipWith (\n line -> show n ++ " - " ++ line)
                                [0..] todoTasks
    putStrLn "These are your Todo Items:"
    mapM_ putStrLn numberedTasks
    let number = read numberString
        newTodoItem = unlines $ delete (todoTasks !! number) todoTasks
    bracketOnError (openTempFile "." "temp")
        (\(tempName, tempHandle) -> do
            hClose tempHandle
            removeFile tempName)
        (\(tempName, tempHandle) -> do
            hPutStr tempHandle newTodoItem
            hClose tempHandle
            removeFile "todo.txt"
            renameFile tempName "todo.txt")