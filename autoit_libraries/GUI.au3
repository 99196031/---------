#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <EditConstants.au3>
#include <GDIPlus.au3>

Global $hBrowser = ""

Func createGUI()
	Local $hGUIWidth = 560
	Local $hGUIHeight = 300
	Local $sVersion = FileRead(@ScriptDir & "\VERSION.txt")
	$hGUI = GUICreate("Auto SquadMortar " & $sVersion, $hGUIWidth, $hGUIHeight, -1, -1, $WS_SYSMENU + $WS_MINIMIZEBOX)
	GUISetOnEvent($GUI_EVENT_CLOSE, "exitScript")
	GUISetBkColor(0x202225)
	$iLog = GUICtrlCreateEdit("", 10, 10, $hGUIWidth - 25, $hGUIHeight - 115, BitOR($ES_AUTOVSCROLL, $ES_AUTOHSCROLL, $ES_WANTRETURN, $WS_VSCROLL, $ES_READONLY))
	GUICtrlSetBkColor($iLog, 0x000000)
	GUICtrlSetFont($iLog, 9, 400, 0, "Arial")
	GUICtrlSetColor($iLog, 0xF7FF01)
	loadDataLog($iLog)

	Local $buttonWidth = ($hGUIWidth - 45) / 3
	Local $buttonHeight = 30

	GUICtrlCreateButton("打开Auto SquadMortar本地站点", 10, $hGUIHeight - 100, $hGUIWidth - 25, $buttonHeight)
	GUICtrlSetOnEvent(-1, "eventButtonOpenHTMLFileClick")

	GUICtrlCreateButton("Discord", 10, $hGUIHeight - 65, $buttonWidth, $buttonHeight)
	GUICtrlSetOnEvent(-1, "eventButtonDiscordClick")

	GUICtrlCreateButton("Github", 20 + $buttonWidth, $hGUIHeight - 65, $buttonWidth, $buttonHeight)
	GUICtrlSetOnEvent(-1, "eventButtonGithubClick")

	GUICtrlCreateButton("Check Update", 30 + $buttonWidth * 2, $hGUIHeight - 65, $buttonWidth, $buttonHeight)
	GUICtrlSetOnEvent(-1, "eventButtonUpdateClick")

	GUISetState(@SW_SHOW)
EndFunc   ;==>createGUI


Func exitScript()
	ControlSend("Squad", "", "", "{a Up}")
	ControlSend("Squad", "", "", "{d Up}")
	ControlSend("Squad", "", "", "{w Up}")
	ControlSend("Squad", "", "", "{s Up}")
	ControlSend("Squad", "", "", "{i Up}")
	ControlSend("Squad", "", "", "{r Up}")
	ControlSend("Squad", "", "", "{o Up}")
	If ProcessExists("squadMortarServerSilent.exe") Then
		ProcessClose("squadMortarServerSilent.exe")
	EndIf
	_GDIPlus_Shutdown()
	Exit
EndFunc   ;==>exitScript

Func customConsole($iComponent, $sText, $bAppend = False)
	If $bAppend Then
		$sText = $sText & "	"
	Else
		$sText = $sText & @CRLF
	EndIf
	GUICtrlSetData($iComponent, $sText, 1)
EndFunc   ;==>customConsole


Func loadDataLog($iLogData)
	Sleep(100)
	GUICtrlSetData($iLogData, "")

	If WinExists("SquadGame") == 1 Then
		Local $aWinPos = WinGetClientSize("SquadGame")
		Eval("i" & $aWinPos[0] & "x" & $aWinPos[1])
		If Not @error Then
			customConsole($iLogData, "游戏尺寸正确 :" & $aWinPos[0] & "x" & $aWinPos[1] & ".")
		Else
			customConsole($iLogData, "游戏尺寸不正确，请设置为: 1024x768, 1920x1080, 2560x1440, 3840x1600")
			customConsole($iLogData, "当前尺寸为: " & $aWinPos[0] & "x" & $aWinPos[1] & ".")
			customConsole($iLogData, "解决问题后请重新启动 Auto SquadMortar.")
			customConsole($iLogData, "通常原因: 设置 -> 视觉效果 -> 分辨率范围 设为 100% 以修复 ")
		EndIf
	Else
		customConsole($iLogData, "Squad 未激活")
		customConsole($iLogData, "解决问题后请重新启动Auto SquadMortar.")
	EndIf
	customConsole($iLogData, "")
	customConsole($iLogData, "在Squad中设置以下选项:")
	customConsole($iLogData, "  • 控制 -> 步兵 -> 开火/使用 -> 替代 = O")
	customConsole($iLogData, "  • 控制 -> 步兵 -> 瞄准 -> 替代 = P")
	customConsole($iLogData, "")
	customConsole($iLogData, "如果你打算使用同步目标和同步地图:") ;
	customConsole($iLogData, "  • 如果你只有一个显示器，请在窗口模式下以1024x768分辨率进行游戏.")
	customConsole($iLogData, "  • 如果你有两个或更多显示器，请在全屏模式或")
	customConsole($iLogData, "     无边框模式下进行游戏.")
	customConsole($iLogData, "")
	customConsole($iLogData, "如果你只打算使用同地图:")
	customConsole($iLogData, "  • 以所有支持的分辨率进行游戏，其中1024x768以窗口模式进行游戏，其他分辨率")
	customConsole($iLogData, "    以全屏或无边框模式进行游戏.")
	customConsole($iLogData, "  •  如果你只有一个显示器，请使用同步地图中的 同步地图激活.")
	customConsole($iLogData, "")
	customConsole($iLogData, "备注:")
	customConsole($iLogData, "  • 战术小队必须见（不能被挡）.")
	customConsole($iLogData, "  • 同步目标仅适用于标准迫击炮.")
	customConsole($iLogData, "  • 要激活同步目标功能，您需要在迫击炮上，并处于瞄准模式.")
	customConsole($iLogData, "  • 使用快捷键"."（句号）作为快速切换战队和网站的快捷键")
	customConsole($iLogData, "")
	customConsole($iLogData, "Optional Improvements:")
	customConsole($iLogData, "  • Tab -> 屏幕侧 -> 地图图标缩放 0.3")
	customConsole($iLogData, "  • Tab -> 屏幕右侧 -> 网格透明度 0", True)
EndFunc   ;==>loadDataLog

Func eventButtonUpdateClick()
	Local $sVersion = FileRead(@ScriptDir & "\VERSION.txt")
	Local $dData = InetRead("https://raw.githubusercontent.com/Devil4ngle/squadmortar/release/VERSION.txt")
	$sRemoteVersion = BinaryToString($dData)
	If $sVersion == $sRemoteVersion Then
		MsgBox($MB_OK, "已更新", "您的脚本已经是最新的")
	Else
		ShellExecute("scripts\update.bat")
		exitScript()
	EndIf
EndFunc   ;==>eventButtonUpdateClick

Func eventButtonGithubClick()
	ShellExecute("https://github.com/Devil4ngle/squadmortar")
EndFunc   ;==>eventButtonGithubClick

Func eventButtonDiscordClick()
	ShellExecute("https://discord.gg/ghrksNETNA")
EndFunc   ;==>eventButtonDiscordClick

Func eventButtonOpenHTMLFileClick()
	ShellExecute("http://localhost:3000/", "", @ScriptDir, "open")
	Sleep(200)
	$hBrowser = WinGetHandle("[active]")
EndFunc   ;==>eventButtonOpenHTMLFileClick
