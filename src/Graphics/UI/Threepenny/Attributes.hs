module Graphics.UI.Threepenny.Attributes (
    -- * Synopsis
    -- | Element attributes, for convenience.
    
    -- * Documentation
    style, class_, href,
    
    -- * Drag and Drop
    draggable, droppable, dragData,
    ) where

import Control.Monad
import Graphics.UI.Threepenny.Core
import Graphics.UI.Threepenny.Internal.Core

{-----------------------------------------------------------------------------
    Attributes
------------------------------------------------------------------------------}
style :: WriteAttr Element [(String,String)]
style = mkWriteAttr set
    where
    set vs a = setStyle vs a >> return ()


mkElementAttr name = mkWriteAttr (set' (attr name))

-- | CSS class.
class_ :: WriteAttr Element String
class_ = mkElementAttr "class"

href :: WriteAttr Element String
href = mkElementAttr "href" 

{-----------------------------------------------------------------------------
    Drag and Drop
------------------------------------------------------------------------------}
-- | Enable or disable dragging an element.
draggable :: WriteAttr Element Bool
draggable = mkWriteAttr set
    where
    set v = set' (attr "draggable") $ if v then "true" else "false"

-- | Set the data that is transferred when dragging.
dragData :: WriteAttr Element String
dragData = mkWriteAttr set
    where
    set v = set' (attr "ondragstart") $
        "event.dataTransfer.setData('dragData', '" ++ v ++ "')"

-- | Enable or disable whether the element accepts drops.
droppable :: WriteAttr Element Bool
droppable = mkWriteAttr enable
    where
    enable v = void . if v then allowDrop else blockDrop
    allowDrop el =
        element el
            # set (attr "ondragover") "event.preventDefault()"
            # set (attr "ondrop"    ) "event.preventDefault()"
    blockDrop el =
        element el
            # set (attr "ondragover") ""
            # set (attr "ondrop"    ) ""