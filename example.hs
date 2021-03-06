{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE DataKinds #-}
{-# LANGUAGE OverloadedStrings #-}

import Graphics.BokeHS
import qualified Data.ByteString.Lazy as BS
import Control.Monad
import System.Process
import Data.Scientific
import GHC.TypeLits

myPlot :: Plot
myPlot = plt
    %> addLinearAxis BBelow
    %> addLinearAxis BLeft
    %> addLine myData2 (Key :: Key "x") (Key :: Key "y") def
        { lineColor = red
        , lineAlpha = 0.6
        , lineWidth = 6
        , lineCap = Rounded
        }
    %> addLine myData (Key :: Key "x") (Key :: Key "y2") def 
        { lineColor = green
        , lineDash = DotDash
        , lineWidth = 3
        }
    where plt = defaultPlot{
            width = 1000,
            height = 1000,
            title = "Sample BokeHS plot",
            xRange = Range1d (-0.5) 22,
            yRange = Range1d (-0.5) 22 
        }

main :: IO ()
main = do
    plotHTML <- emitPlotHTML myPlot
    BS.writeFile "sample.html" plotHTML
    void $ system "firefox --new-window sample.html"    

-- Automatic deriving for record types

data CustomData = CD
    { x :: Scientific
    , y :: Scientific }

myData2 :: [CustomData]
myData2 = zipWith CD xcols ycols
    where
            xcols =  [-0.5,
                     1.8333333333333335,
                     4.166666666666667,
                     6.5,
                     8.833333333333334,
                     11.166666666666668,
                     13.5,
                     15.833333333333336,
                     18.166666666666668,
                     20.5]
            ycols = [3.75,
                     4.916666666666667,
                     6.083333333333334,
                     7.25,
                     8.416666666666667,
                     9.583333333333334,
                     10.75,
                     11.916666666666668,
                     13.083333333333334,
                     14.25] 

-- Or define your own: 

instance HasColumn (Scientific, Double) "x" Scientific where
    getValue _ (x, y) = x

instance HasColumn (Scientific, Double) "y2" Scientific where
    getValue _ (x, y) = fromFloatDigits y

myData :: [(Scientific, Double)]
myData = zip xcols ycols
    where 
            xcols = [-0.5,
                     1.8333333333333335,
                     4.166666666666667,
                     6.5,
                     8.833333333333334,
                     11.166666666666668,
                     13.5,
                     15.833333333333336,
                     18.166666666666668,
                     20.5]
            ycols = [2.75,
                     3.916666666666667,
                     5.083333333333334,
                     6.25,
                     10.416666666666667,
                     2.583333333333334,
                     7.75,
                     5.916666666666668,
                     19.083333333333334,
                     13.25] 
