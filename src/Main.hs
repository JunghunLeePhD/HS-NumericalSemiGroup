module Main where

import PSieve (primesUpTo)
import NSGroup (
  NSG(..),
  frobeniusNumber,
  getDensity
  )

main :: IO ()
main = do
    putStrLn "Please enter a ="
    aStr <- getLine
    putStrLn "Please enter b ="
    bStr <- getLine

    let aInt = read aStr :: Integer
    let bInt = read bStr :: Integer
    let f0 = frobeniusNumber $ NSG aInt bInt

    print $ getDensity (NSG aInt bInt) (primesUpTo f0)
