{-# LANGUAGE RankNTypes #-}
module Text.BlazeT.Renderer.String
    ( fromChoiceString
    , renderMarkup
    , renderHtml
  ) where

import           Text.Blaze.Internal (ChoiceString)
import qualified Text.Blaze.Renderer.String as BU
import           Text.BlazeT

fromChoiceString :: ChoiceString -> String -> String       
fromChoiceString = BU.fromChoiceString

renderMarkup :: MarkupM a -> String
renderMarkup = BU.renderMarkup . execMarkup

renderHtml :: MarkupM a -> String
renderHtml = renderMarkup

