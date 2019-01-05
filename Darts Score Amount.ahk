#SingleInstance Off ; allow the script to be run multiple times in parallel.


; define texts for localization:
If A_Args[1] = "/de" {
  Title := "Darts Würfe-Berechner"
  StaticTexts := {TextScore: "&Punktzahl:", CheckBoxDoubleOut: "Muss Double Out sein?", ButtonExecute: "&Berechnen", ListViewThrows: ["1.", "2.", "3."], ButtonExport: "E&xportieren...", TextSALZ: "von SALZKARTOFFEEEL"}
  DialogTexts := {Title: "Exportieren...", Textfile: "Textdateien"}
  DynamicTexts := {EditAmount: ["Es gibt %1 Möglichkeiten!", "Es gibt nur %1 Möglichkeit!"], FileName: [Title . " – " . "Alle %1 Wege, um %2 zu werfen.txt", Title . " – " . "Einziger Weg, um %2 zu werfen.txt"], AmountOfTime: "Circa %1 ms gebraucht."}
}
Else {
  Title := "Darts Score Amount"
  StaticTexts := {TextScore: "&Score:", CheckBoxDoubleOut: "Has to be double out?", ButtonExecute: "&Calculate", ListViewThrows: ["1st", "2nd", "3rd"], ButtonExport: "E&xport...", TextSALZ: "by SALZKARTOFFEEEL"}
  DialogTexts := {Title: "Export...", Textfile: "Text Documents"}
  DynamicTexts := {EditAmount: ["There are %1 ways!", "There is only %1 way!"], FileName: [Title . " – " . "All %1 ways to score %2.txt", Title . " – " . "Only way to score %2.txt"], AmountOfTime: "Took around %1 ms."}
}

; Create the GUI:
Gui := GuiCreate("+Resize -MaximizeBox -MinimizeBox", Title)
Gui.OnEvent("Size", "Resize"), Gui.OnEvent("Close", "Exit")
Gui.MarginX := Gui.MarginY := 8
Gui.Options("MinSize" 144 + 2 * Gui.MarginX "x" 197)

TextScore := Gui.AddText(, StaticTexts.TextScore)

EditScore := Gui.AddEdit("W32 Yp-4 X" TextScore.Pos.W + 2*Gui.MarginX " Number")
EditScore.Value := 180

ButtonExecute := Gui.AddButton("W144 X" Gui.MarginX " Default", StaticTexts.ButtonExecute), ButtonExecute.OnEvent("Click", "Execute")

ListViewThrows := Gui.AddListView("NoSort W144 H" A_ScreenHeight-360 " -LV0x10", StaticTexts.ListViewThrows), ListViewThrows.ModifyCol(1, "Center"), ListViewThrows.ModifyCol(2, "Center"), ListViewThrows.ModifyCol(3, "Center")

EditAmount := Gui.AddEdit("W144 ReadOnly")

ButtonExport := Gui.AddButton("W144 Disabled", StaticTexts.ButtonExport), ButtonExport.OnEvent("Click", "Export")

Gui.SetFont("S7 CGray")
TextSALZ := Gui.AddText("W144 BackgroundTrans Center", StaticTexts.TextSALZ)
Gui.SetFont()


; program's calculation logic:
AllCombinations := {}, Output := ""
Multipliers := {"S": 1, "D": 2, "T": 3}
Fields := List(1, 20), Fields.Push(25)

For Letter, Multiplier in Multipliers {
  If Multiplier = 3 { ; there is no T25:
    Fields.Pop()
  }
  
  Count := 0 ; separate Counter var, because I need this later, outside the loop.
  For I, Field in Fields {
    AllCombinations[Letter . Field] := Field * Multiplier ; => for example: AllCombinations[T20] := 30 * 3.
    Count++
  }
}

Gui.Show()

Execute() ; execute when the script starts.

#If WinActive("ahk_id " Gui.HWND)
Enter::Execute()


Execute() {
  Global

  DllCall("GetSystemTimeAsFileTime", "UInt64*", StartTime) ; start the time counter.

  ; cap the score to between 1 and 180:
  If EditScore.Value < 1
    EditScore.Value := 1
  Else If EditScore.Value > 180
    EditScroeValue := 180

  Gui.Options("Disabled") ; disable the user input so that this function doesn't activate while it's already running. This loution is generally bad, but since every Execute() only takes a split second, it should be fine.

  Count := 0 ; reset Count (it is used for a different purpose now – to count all combinations and give an end result. I know... I know).
  Output := ""
  Value := EditScore.Value ; short-hand.
  
  ; ComboN is the combination, like "T20",
  ; ValueN is its value, like 180:
  For Combo1, Value1 in AllCombinations {
    If Value1 == Value { ; if the current 1-dart combo already matches the Value we need:
      thisCombo := Combo1 ; short-hand.
      
      If !InStr(Output, thisCombo) { ; if the current combo doesn't already exist:
        Output .= thisCombo "`r`n"
        Count++
      }
    }
    For Combo2, Value2 in AllCombinations {
      If Value1 + Value2 == Value { ; if the 2-dart combo matches Value:
        thisCombo := Sort(Combo1 "," Combo2, "FSort1 D,") ; sort this combo in a logical way, so we can check for duplicates easier.
        
        If !InStr(Output, thisCombo) {
          Output .= thisCombo "`r`n"
          Count++
        }
      }
      For Combo3, Value3 in AllCombinations {
        If Value1 + Value2 + Value3 == Value { ; if hte 3-dart combo matches Value:
          thisCombo := Sort(Combo1 "," Combo2 "," Combo3, "FSort1 D,")
          
          If !InStr(Output, thisCombo) {
            Output .= thisCombo "`r`n"
            Count++
          }
        }
      }
    }
  }
  
  DllCall("GetSystemTimeAsFileTime", "UInt64*", EndTime) ; end the time counter.
  
  ButtonExecute.Text := StrReplace(DynamicTexts.AmountOfTime, "%1", Format("{:i}", (EndTime - StartTime) / 10000)) ; show how long the calculation took.
  
  Gui.Options("-Disabled")
  
  ButtonExport.Options("-Disabled") ; enable the export button.
  
  ListViewThrows.Delete() ; empty the ListView.
  
  If not Count < 1 {
    Output := Sort(Output, "FSort2") ; sort in a logical way.
    Output := RTrim(Output, "`r`n") ; remove the last newline.
    
    Loop Parse, Output, "`n" { ; on every line of Output...
      Array := StrSplit(A_LoopField, ",") ; separate the combos into an array...
      ListViewThrows.Add(, Array*) ; and place that into the ListView.
    }
  }
  
  EditAmount.Value := StrReplace(DynamicTexts.EditAmount[Count=1? 2 : 1], "%1", Count) ; display the result in the read-only Edit.
  
  SetTimer(() => (ButtonExecute.Text := StaticTexts.ButtonExecute), -1500)
}

; functions:

Sort1(One, Two) { ; sorts throws:
  /*
    Each throw is of the format MN. M is the multiplier (S, D, T), N is the number (1-20 and 25).
    Sort priority:
      The higher N * M, the earlier.
  */
  
  static Multipliers := {S: 1, D: 2, T: 3}
  Return (Multipliers[SubStr(Two, 1, 1)] * SubStr(Two, 2)) - (Multipliers[SubStr(One, 1, 1)] * SubStr(One, 2))
}
Sort2(One, Two) { ; sorts lines:
  /*
    Sort priority:
      1: The less throws a line requires, the earlier.
      2: The higher the multiplier of a throw, the earlier.
      3: The higher the number of a throw, the earlier.
  */
  
  static Multipliers := {S: 1, D: 2, T: 3}
  
  ; arrays are easier to work with:
  ArrayOne := StrSplit(One, ",")
  ArrayTwo := StrSplit(Two, ",")
  
  Loop Max(ArrayOne.Length(), ArrayTwo.Length()) {
    If ArrayOne.Length() != ArrayTwo.Length() { ; one line requires less throws:
      Return ArrayOne.Length() - ArrayTwo.Length() ; put that line first.
    }
    
    If Multipliers[SubStr(ArrayOne[A_Index], 1, 1)] != Multipliers[SubStr(ArrayTwo[A_Index], 1, 1)] { ; one throw is on a higher-grade field (e.g.: T20 vs. D20):
      Return Multipliers[SubStr(ArrayTwo[A_Index], 1, 1)] - Multipliers[SubStr(ArrayOne[A_Index], 1, 1)] ; put that line first.
    }
    
    If SubStr(ArrayOne[A_Index], 2) != SubStr(ArrayTwo[A_Index], 2) { ; one throw is on a field with a higher number (e.e.: S2 vs. S1):
      Return SubStr(ArrayTwo[A_Index], 2) - SubStr(ArrayOne[A_Index], 2) ; put that line first.
    }
    
    ; If nothing is true, the loop continues and the next throw is being examined.
  }
}

List(From := 1, To := 100) {
  Number := From, Array := []
  While Number <= To {
    Array.Push(Number)
    Number++
  }
  Return Array
}

Export() {
  Global
  SetTimer("FixFileSelectWindow", 10) ; launch the function in another thread.
  Path := FileSelect("S 16", A_MyDocuments, DialogTexts.Title, DialogTexts.Textfile " (*.txt)")
  If Path {
    SplitPath(Path, FileName, FileDir, FileExt, FileNameNoExt)
    FileDelete(Path)
    FileAppend(Output "`r`n" EditAmount.Value, FileDir "\" FileNameNoExt "." (FileExt? FileExt : "txt"))
  }
  
  FixFileSelectWindow() {
    Global
    If WinActive("ahk_class #32770") { ; if the FileSelect window is open:
      SetTimer("FixFileSelectWindow", "Off") ; stop retrying to find it.
      ControlSetText(Text := StrReplace(StrReplace(DynamicTexts.FileName[Count=1? 2 : 1], "%1", Count), "%2", Value), "Edit1") ; place the proper filename into the Edit control.
      HWND := ControlGetHWND("Edit1")
      SendMessage(0xB1, 0, InStr(Text, ".",, -1) - 1,, "ahk_id " HWND) ; Select the filename.
    } Else {
      Return
    }
  }
}
Resize(GuiObj, MinMax, W, H) { ; callback for every mouse event while resizing the window.
  ; Everything is using commas to get maximum performance as this function is run several times per second.
  Global
  ; Use SetTimer to update the ListView only after the user stopped their mouse movement for a little while:
  SetTimer("FinishResize", "Off")
  ,	SetTimer("FinishResize", -100)
  ; move stuff:
  ,	EditScore.Move("W" W - 3 * Gui.MarginX - TextScore.Pos.W)
  ,	ButtonExecute.Move("W" W - 2 * Gui.MarginX)
  ,	ListViewThrows.Move("W" W - 2 * Gui.MarginX " H" H - 2 * Gui.MarginY - 136)
  ,	EditAmount.Move("Y" Gui.MarginY + ListViewThrows.Pos.Y + ListViewThrows.Pos.H " W" W - 2 * Gui.MarginX)
  ,	ButtonExport.Move("Y" Gui.MarginY + EditAmount.Pos.Y + EditAmount.Pos.H " W" W - 2 * Gui.MarginX)
  ,	TextSALZ.Move("Y" Gui.MarginY + ButtonExport.Pos.Y + ButtonExport.Pos.H " W" W - 2 * Gui.MarginX, True)
}
FinishResize() {
  Global
  For I, Obj in Gui { ; redraw all controls:
    Obj.Move(, True)
  }
  Loop 3 { ; three columns:
    ListViewThrows.ModifyCol(A_Index, ((ListViewThrows.Pos.W - 20.5) / 3))
  }
}
Exit() { ; EGGSHIT!
  ExitApp
}
