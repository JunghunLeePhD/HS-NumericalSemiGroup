module NSGroup
    (  
      NSG(..),
      frobeniusNumber,
      getMembers,
      getGaps,
      getDensity,
    ) where
import Control.Monad (forM_, when, guard)

extendedGcd :: Integer -> Integer -> (Integer, Integer, Integer)
extendedGcd a 0 = (a, 1, 0)
extendedGcd a b =
    let
        (g, x', y') = extendedGcd b (a `mod` b)
        x = y'
        y = x' - (a `div` b) * y'
    in
        (g, x, y)
{-# INLINE extendedGcd #-}

data NSG = NSG Integer Integer deriving (Show)

frobeniusNumber :: NSG -> Integer
frobeniusNumber (NSG a b) = a*b-a-b
{-# INLINE frobeniusNumber #-}

isIn :: NSG -> (Integer -> Bool)
isIn (NSG a b) = \d ->
    let
        x_d = fromIntegral d * fromIntegral x_base :: Double
        y_d = fromIntegral d * fromIntegral y_base :: Double
        a_d = fromIntegral a :: Double
        b_d = fromIntegral b :: Double
        lower_d = ceiling (- (x_d / b_d)) :: Integer
        upper_d = floor (y_d/a_d) :: Integer
    in
        lower_d <= upper_d
    where
        (g, x_base, y_base) = extendedGcd a b
{-# INLINE isIn #-}

getMembers :: NSG -> [Integer]
getMembers nsg = filter isin [1..f]
  where
    f = frobeniusNumber nsg :: Integer
    isin = isIn nsg :: Integer -> Bool
{-# INLINE getMembers #-}

getGaps :: NSG -> [Integer]
getGaps nsg = filter isnotin [1..f]
  where
    f = frobeniusNumber nsg :: Integer
    isnotin = not . isIn nsg :: Integer -> Bool
{-# INLINE getGaps #-}

getDensity :: NSG -> ([Integer] -> Double)
getDensity nsg = \nums ->
        let
            target = fromIntegral . length . filter isin $ nums :: Double
            total = fromIntegral . length $ nums :: Double
        in
            if total > 0 then target / total
            else 0.0
    where
        isin :: Integer -> Bool
        isin = isIn nsg 
{-# INLINE getDensity #-}
