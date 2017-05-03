# AIB to FreeAgent Conversion

Since AIB now allow small businesses to use the Personal Internet Banking system, instead of the archaic IBB system, it's become a lot easier to export transactions as CSV.

This script will convert the AIB CSV into a format that can be uploaded to [FreeAgent](https://www.freeagent.com).

It's built on top of the awesome [Marathon](https://github.com/JohnSundell/Marathon) Swift scripting system.

## Installation

### Install Marathon

Visit the [Marathon Github page](https://github.com/JohnSundell/Marathon) for installation instructions.
 
### Installing the Script

`git clone git@github.com:appsandwich/aib2fa.git`

`cd aib2fa`

`marathon install aib2fa`

 
### Usage

`aib2fa /path/to/your/file.csv`

This will generate a new file at `/path/to/your/file-converted.csv`