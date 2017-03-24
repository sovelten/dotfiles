import XMonad
import qualified Data.Map as M
import Data.Either.Utils
import System.IO
import XMonad.Actions.GridSelect
import XMonad.ManageHook
import XMonad.Hooks.ManageHelpers
import XMonad.Layout.NoBorders
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Actions.SpawnOn
import XMonad.Util.Run(spawnPipe)
import qualified XMonad.Util.EZConfig as EZ
import qualified XMonad.Layout.Tabbed as Tab
import qualified XMonad.Layout.WorkspaceDir as WD
import qualified XMonad.Prompt as P
import XMonad.Hooks.FadeInactive

myStatusBar = "conky -c /home/eric/.xmonad/.conky_dzen | dzen2 -fn '-*-profont-*-*-*-*-11-*-*-*-*-*-iso8859' -x '220' -w '1096' -h '24' -ta 'r' -bg '#000000' -fg '#FFFFFF' -y '0'"
myXmonadBar = "dzen2 -fn '-*-profont-*-*-*-*-11-*-*-*-*-*-iso8859' -x '1440' -y '0' -h '24' -w '220' -ta 'l' -fg '#FFFFFF' -bg '#000000'"
trayer = "trayer --edge top --widthtype pixel --align right --width 50 --heighttype pixel --height 24 --transparent true --alpha 0 --tint 0x000000 --SetPartialStrut true --SetDockType true"
main = do
	leftBar <- spawnPipe myXmonadBar
	rightBar <- spawnPipe myStatusBar
	systray <- spawnPipe trayer
	xmonad myConfig {
		terminal = myTerminal,
		handleEventHook = docksEventHook <+> ewmhDesktopsEventHook,
		manageHook = myManageHook,
		layoutHook = myLayouts,
		logHook = myLogHook leftBar >> fadeInactiveLogHook 0xdddddddd,
		startupHook = myStartupHook	
        }

myImgDir = "/home/eric/.xmonad/dzen2"

myLogHook :: Handle -> X ()
myLogHook h = do
    ewmhDesktopsLogHook
    dynamicLogWithPP $ defaultPP
        {
             ppCurrent = dzenColor "black" "#cccccc". pad
            ,ppVisible = dzenColor "white" "black" . pad
            ,ppHidden = dzenColor "white" "black" . pad
            ,ppHiddenNoWindows = (\x -> "")
            ,ppUrgent = dzenColor "$ff0000" "black" . pad
            ,ppWsSep = ""
            ,ppSep = " | "
            ,ppTitle = (\x -> "")
            ,ppOutput = hPutStrLn h
            ,ppLayout = dzenColor "#ebac54" "black" .
                (\x -> case x of
                 "Tall" -> "^i(" ++ myImgDir ++ "/tall.xbm)"
                 "Mirror Tall" -> "^i(" ++ myImgDir ++ "/mtall.xbm)"
                 "Tabbed Simplest" -> "^i(" ++ myImgDir ++ "/full.xbm)"
                 _ -> x
                )
        }

myTerminal = "termite"

_myKeys =
	[
	 ("M-g", goToSelected defaultGSConfig)
	,("M-p", spawnHere "exe=`yeganesh -x` && eval \"exec $exe\"")
	,("M-s", sendMessage ToggleStruts)
	,("M-x", WD.changeDir P.defaultXPConfig)
	,("M-S-t", spawn "slock")
	,("M-S-h", spawn "systemctl hibernate")
	,("M-S-r", spawn "systemctl reboot")
	,("<XF86Tools>", spawn "mpd")
	,("<XF86AudioPlay>", spawn "mpc --no-status toggle")
	,("<XF86AudioStop>", spawn "mpc stop")
	,("<XF86AudioNext>", spawn "mpc next")
	,("<XF86AudioPrev>", spawn "mpc prev")
	,("<XF86AudioLowerVolume>", spawn "amixer set Master 2-")
	,("<XF86AudioRaiseVolume>", spawn "amixer set Master 2+")
	,("<XF86AudioMute>", spawn "amixer set Master toggle")
	,("<XF86MonBrightnessUp>", spawn "xbacklight -inc 10")
	,("<XF86MonBrightnessDown>", spawn "xbacklight -dec 10")
	]

myConfig = EZ.additionalKeysP defaultConfig _myKeys
myLayouts = avoidStrutsOn []
            $ smartBorders
            $ _homeDir

_tiled   = Tall nmaster delta ratio
    where
      nmaster = 1
      ratio   = 1/2
      delta   = 3/100

_easyLay = _tiled ||| Mirror _tiled ||| Tab.simpleTabbed
_homeDir = WD.workspaceDir "/home/eric" _easyLay

myManageHook :: ManageHook
myManageHook = composeAll [ isFullscreen --> doFullFloat,
                            manageSpawn,
                            className =? "trayer" --> doIgnore,
                            className =? "popcorntime" --> doFloat,
                            className =? "Do" --> doIgnore ]

myStartupHook = do
    ewmhDesktopsStartup
    docksStartupHook
