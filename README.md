# Darts Score Amount
##### A program to calculate all possible ways of scoring a defined value.

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

## Plans
* **Respect Order**:
  Add the option to select whether the order that the darts are thrown in should be respected or not. For example: if `S2 S1` comes up, there won't be a `S1 S2` in the list – it will be sorted out. This should be optional.
* **Export All**:
  Add the option to export all possible ways (from 1 to 180) into one file. This will likely be a [CSV file](https://en.wikipedia.org/wiki/Comma-separated_values) (readable by the most common word processors), as a heck lot of data will be produced.
* **Add More Languages**:
  This program is currently available only in *English* and *German* (though German is not official yet). If you have any interests in translating it, feel free to do so (and contact me, so I can publish your work and mention your name if you want to).

For more plans and issues (all more on a technical side of things) visit this repository's [Issues page](https://github.com/SALZKARTOFFEEEL/Darts-Score-Amount/issues).