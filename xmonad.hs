--------------------------
--        IMPORTS       --
--------------------------
import XMonad
-- HOOKS --
import XMonad.ManageHook
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.SetWMName
import XMonad.Hooks.DynamicLog hiding (xmobarColor)
import XMonad.Hooks.EwmhDesktops hiding (fullscreenEventHook)
import XMonad.Hooks.InsertPosition as H
-- UTILS --
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeys)
import XMonad.Util.SpawnOnce
import XMonad.Util.Dmenu
-- LAYOUTS --
import XMonad.Layout.Spacing
import XMonad.Layout.ResizableTile
import XMonad.Layout.WindowArranger
import XMonad.Layout.NoBorders
import XMonad.Layout.Circle
import XMonad.Layout.Gaps
import XMonad.Layout.Fullscreen 
import XMonad.Layout.PerWorkspace
import XMonad.Layout.SimplestFloat
import XMonad.Layout.Tabbed 
import XMonad.Layout.Circle
import XMonad.Layout.ThreeColumns
import XMonad.Layout.Renamed
-- ACTIONS --
import XMonad.Actions.CycleWS (prevWS, nextWS)
import XMonad.Actions.FloatKeys
import XMonad.Actions.DynamicWorkspaces
import XMonad.Actions.CopyWindow(copy)
import XMonad.Actions.SpawnOn
import XMonad.Actions.UpdatePointer
-- OTHER --
import Data.List
import Data.Monoid
import System.Exit
import System.IO
import Graphics.X11.ExtraTypes.XF86
import qualified XMonad.StackSet as W
import qualified XMonad.Actions.FlexibleResize as FlexibleResize
import Control.Monad (liftM2)
-- import qualified GHC.IO.Handle.Types as H

--------------------------
--      WORKSPACES      --
--------------------------
-- myWorkSpaces :: [String]
-- myWorkSpaces = clickable $ ["1:MAIN", "2:MPD", "3:TOR", "4:;CODE", "5:CON;APP", "6:CON;BASE", "7:FTP", "8:WEB", "9:FILE"]
--     where
--         clickable l = ["<action='xdotool key super+" ++ show (n) ++ "'>" ++ ws ++ "</action>" | (i,ws) <- zip [1..] l, let n = i]

myWorkSpaces = ["1:MAIN", "2:MPD", "3:TOR", "4:;CODE", "5:CON;APP", "6:CON;BASE", "7:FTP", "8:WEB", "9:FILE"]
--------------------------
--     MANAGE HOOK      --
--------------------------
-- myManageHook :: ManageHook
myManageHook = composeAll . concat $ [
    [isFullscreen --> doFullFloat]
    , [manageDocks]
    , [(className =? c <||> title =? c <||> resource =? c) --> doCenterFloat | c <- utils ]
    , [(className =? c <||> title =? c <||> resource =? c) --> doIgnore | c <- selfpositioned ]
    , [(className =? c <||> title =? c <||> resource =? c) --> doFloat | c <- floating ]
    , [(className =? c <||> title =? c <||> resource =? c) --> doFullFloat | c <- fullscreened ]
    , [(className =? c <&&> isDialog) --> H.insertPosition H.Above H.Newer | c <- fm ]
    , [(className =? c <||> title =? c <||> resource =? c) --> doShift "8:WEB" | c <- browsers ]
    ]
    where
        utils = ["Galculator", "galculator"]
        selfpositioned = ["polybar"]
        browsers = ["firefox", "Firefox", "Navigator", "firefox-bin", "Firefox-bin", "Waterfox", "waterfox"]
        floating = ["xpad"]
        fullscreened = ["mplayer", "MPlayer", "gimp", "GIMP", "vlc", "VLC", "eog", "Eog"]
        fm = ["doublecmd", "Doublecmd"]

--------------------------
--         KEYS         --
--------------------------
mKeys = [
    ((mod1Mask, xK_F4), kill)
    , ((modm, xK_Left), prevWS)
    , ((modm, xK_Right), nextWS)
    , ((modm .|. controlMask              , xK_s    ), sendMessage  Arrange         )
    , ((modm .|. controlMask .|. shiftMask, xK_s    ), sendMessage  DeArrange       )
    , ((modm .|. controlMask              , xK_Left ), sendMessage (MoveLeft      10))
    , ((modm .|. controlMask              , xK_Right), sendMessage (MoveRight     10))
    , ((modm .|. controlMask              , xK_Down ), sendMessage (MoveDown      10))
    , ((modm .|. controlMask              , xK_Up   ), sendMessage (MoveUp        10))
    , ((modm                 .|. shiftMask, xK_Left ), sendMessage (IncreaseLeft  10))
    , ((modm                 .|. shiftMask, xK_Right), sendMessage (IncreaseRight 10))
    , ((modm                 .|. shiftMask, xK_Down ), sendMessage (IncreaseDown  10))
    , ((modm                 .|. shiftMask, xK_Up   ), sendMessage (IncreaseUp    10))
    , ((modm .|. controlMask .|. shiftMask, xK_Left ), sendMessage (DecreaseLeft  10))
    , ((modm .|. controlMask .|. shiftMask, xK_Right), sendMessage (DecreaseRight 10))
    , ((modm .|. controlMask .|. shiftMask, xK_Down ), sendMessage (DecreaseDown  10))
    , ((modm .|. controlMask .|. shiftMask, xK_Up   ), sendMessage (DecreaseUp    10))
    , ((modm, xK_KP_Add), sequence_ [sendMessage (IncreaseLeft 10), sendMessage (IncreaseRight 10), sendMessage (IncreaseUp 10), sendMessage (IncreaseDown 10)])
    , ((modm, xK_KP_Subtract), sequence_ [ sendMessage (DecreaseLeft 10), sendMessage (DecreaseRight 10), sendMessage (DecreaseUp 10), sendMessage (DecreaseDown 10)])
    , ((0, xK_grave), spawn "tilix")
    ]
    where
        modm = mod4Mask

--------------------------
--        LAYOUTS       --
--------------------------
decentLayout = onWorkspace (myWorkSpaces !! 1) (gappedLayout) 
--    $ onWorkspace (myWorkSpaces !! 7) (avoidStruts (borderlessFSLayout))
    $ gappedLayout ||| standartLayout ||| Mirror standartLayout ||| Full
    where
        gappedLayout = (gaps [(U, 22), (R, 0), (L, 0), (D, 0)] $ avoidStruts (spacing 0 $ ResizableTall 1 (2/100) (1/2) [])) ||| Circle
        standartLayout = spacing 2 $ ResizableTall 1 (2/100) (1/2) []
--        borderlessFSLayout = noBorders (fullscreenFull Full)

--------------------------
--       STARTUP        --
--------------------------
startUp :: X()
startUp = do
    setWMName "LG3D"
    spawn "amixer -q set Master -- 66%"
    spawn "mpd ~/.config/mpd/mpd.conf"
    spawn "compton -fF -t-5 -l-5 -r4 -o.55 -D2 -m.83"
    spawn "nitrogen --restore"
    spawn "nm-applet"
    spawn "xpad"
    spawn "waterfox"
    spawn "polybar purplecum"
    spawn "polybar purplecumsup"
--------------------------

main = do
--    xmproc <- spawnPipe "polybar purplecum"
    xmonad $ defaultConfig
        { manageHook = myManageHook
        , startupHook = startUp
        , layoutHook = decentLayout
        , handleEventHook = fullscreenEventHook
        , workspaces = myWorkSpaces
        , modMask = mod4Mask
        , borderWidth = 0
        , focusedBorderColor = "#6A555C" --"#404752"
        , normalBorderColor = "#404752" --"#343C48"
--        , logHook =  dynamicLogWithPP $ defaultPP {
--            ppOutput = System.IO.hPutStrLn xmproc
--            , ppTitle = xmobarColor "green" "" . shorten 20
--            , ppCurrent = xmobarColor "white" ""
--            , ppSep = "   "
--            , ppWsSep = " "
--             , ppLayout  = (\ x -> case x of
--                 "Spacing 6 Mosaic"                      -> "[:]"
--                 "Spacing 6 Mirror Tall"                 -> "[M]"
--                 "Spacing 6 Hinted Tabbed Simplest"      -> "[T]"
--                 "Spacing 6 Full"                        -> "[ ]"
--                 _                                       -> x )
--            , ppHiddenNoWindows = showNamedWorkspaces
--        }
--         , logHook = dynamicLogWithPP xmobarPP
--             {ppOutput = hPutStrLn xmproc
--             , ppCurrent = xmobarColor "yellow" "" . wrap "[""]"
-- --            , ppHiddenNoWindows = xmobarColor "grey" ""
--             , ppTitle   = xmobarColor "green" "" . shorten 50
--             , ppVisible = wrap "("")"
-- --            , ppUrgent  = xmobarColor "red" "yellow"
--             }
        } `additionalKeys` mKeys
        where
            showNamedWorkspaces wsId = if any (`elem` wsId) ['a'..'z'] then pad wsId else ""
