<!-- markdownlint-disable MD026 MD033 -->

# "The all-new <u><span style="font-family: serif;">iElevator</span></u><sup>™</sup> [![iElevator™](/Resources/Images/l'Mao/iElevator™.gif)](https://www.youtube.com/watch?v=VBlFHuCzPgY) <sup><sup><sub><sub> ⃰</sup></sup></sub></sub><sub><sub><sub><sup><sup>Starting at $649/mo. ‮‭ ‮‭ </sup></sup><sup><sup><sup><i> ⃰VAT not included.</i></sup></sup></sup></sub></sub></sub>

## Instructions

### 1. Create a Scheduled Task:

- <i>Launch: <b>"Task Scheduler"</b>.</i> Make sure you're in:

  - <b>"Task Scheduler (Local)"</b> -> <b>"Task Scheduler Library"</b>

Then,

1. Go to: <b>"Actions"</b> -> <b>"Create Task..."</b>

2. Click on the <b>"General"</b> tab:

   1.1. Name it: <code>[KBDRacer2x2]</code>

   1.2. <i>(optional)</i> Description: <code>"KBDRacer2x2 SuperSpeed"</code>

   1.3. Make sure <b>"Run only when user is logged on"</b> is selected.

   1.4. Check the checkbox for <b>"Run with highest privileges"</b>

3. Click on the <b>"Actions"</b> tab:

   3.1. Click: <b>"New"</b>

   3.1.a. Action: <b>"Start a program"</b>

   3.1.b. Program/script: Click on <b>"Browse"</b>. Then,

   3.1.c.1. Navigate to where your <code>KBDRacer2x2.exe</code> file is located.

   3.1.c.2. Select the file -> Click <b>"Open"</b>

   3.2. Click: <b>"OK"</b>

4. Click on the <b>"Conditions"</b> tab:

   4.1. <b>Uncheck everything</b>

5. Click on the <b>"Settings"</b> tab:

   5.1. Make sure only the below 2 are checked <i><b>(uncheck the rest)</b></i>:

   5.1.a. <b>Check</b> the checkbox for <b>"Allow task to be run on demand"</b>

   5.1.b. <b>Check</b> the checkbox for <b>"If the running task does not end when requested, force it to stop"</b>

6. Click: <b>"OK"</b>

<sup>Done.</sup>

### 2. Create a Desktop Shortcut:

- <i><b>Right click</b> on your <b>Desktop</b>.</i>

Then,

1. Click: <b>"New"</b>

2. Click: <b>"Shortcut"</b>

   2.1. Paste this: <code>C:\Windows\System32\schtasks.exe /run /tn "[KBDRacer2x2]"</code>

   2.2. Click: <b>"Next"</b>

   2.3. Name it: <code>[KBDRacer2x2]</code>

   2.4. Click: <b>"Finish"</b>

<sup>Done.</sup>
