module PSieve
    ( primesUpTo,
    ) where
import Control.Monad (forM_, when)
import Data.Array.ST (STUArray, newArray, readArray, writeArray, getAssocs)
import Control.Monad.ST (ST, runST)

primesUpTo :: Integer -> [Integer]
primesUpTo n
  | n < 2     = []
  | otherwise = fromIntegral <$> sieve (fromInteger n)
{-# INLINE primesUpTo #-}

sieve :: Int -> [Int]
sieve limit = runST $ do
    arr <- newArray (2, limit) True :: ST s (STUArray s Int Bool)
    forM_ [2..floor (sqrt (fromIntegral limit))] $ \p -> do
        isPrime <- readArray arr p
        when isPrime $
            forM_ [p*p, p*p+p..limit] $ \i ->
                writeArray arr i False
    assocs <- getAssocs arr
    return [i | (i, True) <- assocs]
{-# INLINE sieve #-}