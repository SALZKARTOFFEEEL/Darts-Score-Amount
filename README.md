# Darts Score Amount
#### A program to calculate all possible ways of scoring a defined value in the game Darts.

## Purpose
You enter a value from 1 to 180, hit Calculate, it calculates the number of ways to score that amount. – As simple as that.

For example: If you enter "26", you will get a list of all ways to score 26 points:

1st | 2nd | 3rd
:--:|:---:|:--:
D13 |     |    
T8  | D1  |    
T8  | S2  |    
T7  | S5  |    

_and so on..._

It will also tell you the total amount of ways – in this case 360!


## How To Download & Use
### Downloading
Use GitHub's Download button at the top-right, or click [**here**](https://github.com/SALZKARTOFFEEEL/Darts-Score-Amount/archive/master.zip) to download a ZIP-Archive of all the required files.

To know which files are relevant to you, refer to the next section.

### Running

This program is written in [AutoHotkey](https://www.autohotkey.com/). Do you know AutoHotkey?

#### I know AutoHotkey!
Great! Just download the source code and run it. **Make sure you have v2 installed**, as this will not run in v1!

This program will run on any system AutoHotkey runs on.  
It is tested on the 64-bit, Unicode version, but you should run into no trouble using other versions.


#### I don't know AutoHotkey :(
Don't be sad, that's okay. I have prepared an executable file (.exe) so you can run this program without any knowledge of AutoHotkey.
Just run `Darts Score Amount.exe` and you are good to go.

This program will run on Windows machines.  
While Windows XP is no longer supported, I could imagine it still running on it. All newer versions of Windows, like Windows 10, Windows 8, or Windows 7, should work perfectly fine.


## Plans
* **Respect Order**:
  Add the option to select whether the order that the darts are thrown in should be respected or not. For example: if `S2 S1` comes up, there won't be a `S1 S2` in the list – it will be sorted out. This should be optional.
* **Export All**:
  Add the option to export all possible ways (from 1 to 180) into one file. This will likely be a [CSV file](https://en.wikipedia.org/wiki/Comma-separated_values) (readable by the most common word processors), as a heck lot of data will be produced.
* **Add More Languages**:
  This program is currently available only in *English* and *German* (though German is not official yet). If you have any interests in translating it, feel free to do so (and contact me, so I can publish your work and mention your name if you want to).

For more plans and issues (all more on a technical side of things) visit this repository's [Issues page](https://github.com/SALZKARTOFFEEEL/Darts-Score-Amount/issues).
