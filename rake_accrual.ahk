#NoEnv 
SendMode, Input 
SetWorkingDir %A_ScriptDir% 
SetFormat, Float, 0.2
#SingleInstance force

RunningTables:=0
TotalRake:=0.00
TotalTablesOpened:=0
Total5Tables:=0
Total10Tables:=0
Total20Tables:=0

Menu,RakeAccrual, Add, Minimize To Tray, Minimize
Menu,RakeAccrual, Add, Reset Counter, ResetCounter
Menu,RakeAccrual, Add, Exit, GuiClose

Gui -MaximizeBox -MinimizeBox +AlwaysOnTop +Caption +LastFound +Border
Gui, Color, 000000
Gui, Font, s18 cWhite, Verdana

Gui,Margin,5,10,5,10
Gui, Add, Text, Center w25 vMyControl, 0
Gui, Add, Text, Left x+10 w40 cFF8C00 vTotalRake, $0.00
Gui, Show, AutoSize, Rake
Gui, Add, Text, Left w25 y+ cBlack vTotal5Tables, 0
Gui, Add, Text, Left w25 x+15 cBlack vTotal10Tables, 0
Gui, Add, Text, Left w25 x+15 cBlack vTotal20Tables, 0
Gui, Add, Text, Left w50 x+15 cWhite vTotalTablesOpened, 0
Gui, Add, Button, x+25 y7 Center w100 h25 gSubmit, Submit
RakeAccrualHwnd:=winExist()

OnMessage(0x201, "WM_LBUTTONDOWN")
SetTimer,RakeAccrual,3000
Return 

RakeAccrual:

  RunningTables := 0

  WinGet, Id, list, ahk_class GLFW30,, Program Manager
  Loop,%Id%
  {
    hwnd:=Id%A_index%

    RunningTables += 1
    IF hwnd not in %AnteCheck% 
    {
      WinGetTitle, Title, ahk_id%hwnd%
      IF InStr(Title, "75/150")
      {
        WinActivate ahk_id %hwnd%
        Sleep 200
        Send ^s
        AnteCheck:= AnteCheck ? AnteCheck . "," . hwnd : hwnd
      }
    }
    IF hwnd not in %TableHwndList% 
    { 
      WinGetTitle, Title, ahk_id%hwnd%
      IF InStr(Title, "$5") AND InStr(Title, " Logged In as ")
      {
        TableHwndList:= TableHwndList ? TableHwndList . "," . hwnd : hwnd
        TotalRake += 0.40
        TotalTablesOpened += 1
        Total5Tables += 1
        Gui Font, cGreen
        GuiControl Font, Total5Tables
      } 
      Else IF InStr(Title, "$10") AND InStr(Title, " Logged In as ")
      {
        TableHwndList:= TableHwndList ? TableHwndList . "," . hwnd : hwnd
        TotalRake += 0.77
        TotalTablesOpened += 1
        Total10Tables += 1
        Gui Font, cYellow
        GuiControl Font, Total10Tables
      }
      Else IF InStr(Title, "$20") AND InStr(Title, " Logged In as ")
      {
        TableHwndList:= TableHwndList ? TableHwndList . "," . hwnd : hwnd
        TotalRake += 1.50
        TotalTablesOpened += 1
        Total20Tables += 1
        Gui Font, cRed
        GuiControl Font, Total20Tables
      }
    }
  }

  IF (RunningTables != LastCheckedNumTables) OR (SavedTotalTablesOpened != TotalTablesOpened)
  {	
    IF TrayCounter
    {
      WinSetTitle,Ahk_id%RakeAccrualHwnd%,,%RunningTables% // %TotalRake% 
    } 

    LastCheckedNumTables = %RunningTables%
    SavedTotalTablesOpened = %TotalTablesOpened%
    GuiControl,, MyControl, %RunningTables%
    GuiControl,, TotalRake, $%TotalRake%
    GuiControl,, Total5Tables, %Total5Tables%
    GuiControl,, Total10Tables, %Total10Tables%
    GuiControl,, Total20Tables, %Total20Tables%
    GuiControl,, TotalTablesOpened, %TotalTablesOpened%
  }
Return

Submit:
  file := FileOpen("daily_rake.csv","a")
  FormatTime, TimeString,, ShortDate
  file.write(TimeString . "," . TotalRake . "," . Total5Tables . "," . Total10Tables . "," . Total20Tables . ",")
  file.close()
  FileAppend, `n, daily_rake.csv
  file.write(TableHwndList)
  file.close()
  Gosub, ResetCounter 
Return

Minimize: 
  Gui, Minimize
  WinSetTitle, ahk_id%RakeAccrualHwnd%,, %SavedTotalTablesOpened% // $%TotalRake%
Return

GuiSize:
  TrayCounter := A_EventInfo=1 ? 1 : 0
  GuiControl, MoveDraw, WinText, x0 w%A_GuiWidth%
Return

GuiContextMenu:
  Menu, RakeAccrual, Show 
Return

ResetCounter:
  TotalRake:=0.00
  Total5Tables:=0
  Total10Tables:=0
  Total20Tables:=0
  GuiControl,, TotalRake,$0.00 
  GuiControl,, Total5Tables,0 
  GuiControl,, Total10Tables,0 
  GuiControl,, Total20Tables,0 
Return

GuiClose:
  ExitApp
Return