# 🧑‍🏫 Teacher Prep — Camp Drama Llama

This guide gets each student's **Windows** computer ready for the 3-hour
workshop. Do this **before** the kids arrive (allow ~30–45 min per machine the
first time — mostly downloads).

## What each machine needs
- **WSL + Ubuntu** — the Linux terminal used in all three activities.
- **git, Python 3, Java 17** — for the activities.
- **Node.js + Claude Code** — the AI coding tool (Activities 2 & 3).
- **Zed** — a simple text editor (Activity 2).
- **This repo**, at `~/drama-llama/` inside WSL.

---

## Step 1 — Install WSL + Ubuntu (Windows side)

Run **PowerShell as Administrator** and either run the helper script or the
one command it wraps:

```powershell
wsl --install -d Ubuntu
```

Then **reboot**. After reboot, Ubuntu opens — create a **username and
password** (write them down!).

Username: rainbow
Password: dash

> Already have WSL? Skip to Step 2.

---

## Step 2 — Get the repo into WSL

Inside the **Ubuntu** window:

```bash
git clone https://github.com/thinkjones/drama-llama.git ~/drama-llama
```

Replace the URL with your actual repo URL. (No repo host? Copy the folder into
`\\wsl$\Ubuntu\home\<user>\drama-llama` from Windows File Explorer instead.)

---

## Step 3 — Run the Linux setup script

Inside Ubuntu:

```bash
bash ~/drama-llama/teacher-prep/setup-wsl.sh
```

This installs git, Python 3, Java 17, Node.js, **Claude Code**, and **Zed**,
and makes sure the repo is at `~/drama-llama`. It's safe to re-run.

> Tip: set the repo URL once so the script can self-heal a missing clone:
> `DRAMA_LLAMA_REPO_URL=https://github.com/you/drama-llama.git bash ~/drama-llama/teacher-prep/setup-wsl.sh`

---

## Step 4 — Log in to Claude Code (once per machine)

```bash
claude
```

It will prompt you to sign in. Complete the login so kids don't have to. Then
type `/exit`.

---

## Step 5 — Verify everything

```bash
git --version && python3 --version && java -version && node --version && claude --version
```

You should see a version number for each. Then do a 60-second smoke test of
each activity:

```bash
cd ~/drama-llama/twilightsparkle && ls          # Activity 1: folders exist
cd ~/drama-llama/gohan && ls                     # Activity 2: cheatsheet present
cd ~/drama-llama/steve && ./gradlew tasks        # Activity 3: Gradle runs (first run downloads Forge)
```

---

## Notes & gotchas
- **First `./gradlew build` is slow** (downloads Minecraft + Forge, ~minutes).
  Consider running it once per machine during prep so it's cached for the kids.
- **Zed is a GUI app.** In WSL it needs **WSLg** (built into Windows 11). If
  Zed won't open a window, install **VS Code** on Windows + the **WSL**
  extension and have kids use `code <file>` instead of `zed <file>`.
- **Claude Code login** is per-machine; doing it in prep avoids eating class
  time.
- If `claude.ai/install.sh` is blocked on your network, the script falls back
  to `npm install -g @anthropic-ai/claude-code`.

---

## Activity 3 runs on Windows (not WSL)

Activities 1 & 2 use WSL/Ubuntu. **Activity 3 (the Minecraft mod) runs natively
on Windows in PowerShell**, because Minecraft needs Windows to render the game.
Claude Code, the Forge build, and the in-game test all run on the Windows side
against a Windows copy of the repo.

**Prep each machine for Activity 3:** open **PowerShell** and run:

```powershell
# from teacher-prep\  (if scripts are blocked first run: Set-ExecutionPolicy -Scope Process Bypass)
.\setup-windows-modding.ps1
```

That installs **JDK 17 (Temurin)**, **Git**, **VS Code**, and **Claude Code
(native)** via `winget` + the official installer, and clones the repo to
`%USERPROFILE%\drama-llama`. Then, in a fresh PowerShell window:

```powershell
cd $HOME\drama-llama\steve
claude                 # log in once so kids don't have to, then /exit
.\gradlew.bat build    # first build downloads Forge (5-15 min) - do this during prep
```

**Two ways for kids to test the mod** (full steps in
[`../steve/TESTING.md`](../steve/TESTING.md)):

- **Way A — `.\gradlew.bat runClient`** — launches a practice Minecraft with the
  mod loaded. **No Minecraft account or Forge installer needed.** Recommended
  for the workshop.
- **Way B — real Minecraft + Forge** — build the jar and drop it into
  `%APPDATA%\.minecraft\mods`, then launch the **Forge 1.20.1** profile.
  Requires **Minecraft: Java Edition** (paid) and the **Forge 1.20.1** installer
  per machine. Use this only if kids will play the mod in their real Minecraft.

> Pre-run `.\gradlew.bat build` **and** one `.\gradlew.bat runClient` on each
> machine during prep — the first launch caches Minecraft + Forge so class time
> isn't spent downloading.

---

## Bonus: printable decoder worksheets

`worksheets/` holds three **secret binary decoder** activity sheets — a fun
warm-up or filler. Each has its own random letter→number key; kids convert the
binary numbers to decimal, look them up, and spell a hidden phrase.

- `worksheet-1.html` → phrase: **Search High**
- `worksheet-2.html` → phrase: **Above Fire**
- `worksheet-3.html` → phrase: **To Get Treat**
- `ANSWER-KEY.md` → **teacher only** — the solutions. Don't print this for kids!

**To print:** open a `worksheet-N.html` file in any web browser and use
File → Print (they're styled to print cleanly on one page).


# Troubleshoting WSL
To fix the Ubuntu WSL "Catastrophic failure" error, you need to resolve an issue with frozen background services, corrupted installation states, or a mismatch in user permissions. [[1](https://github.com/microsoft/WSL/discussions/13434#:~:text=If%20it%20still%20says%20%E2%80%9CCatastrophic%20failure%E2%80%9D%20*,reboot.%20*%20Virtualization%20really%20isn't%20on%20\(even), [2](https://superuser.com/questions/1818227/why-does-wsl-install-always-yield-catastrophic-failure-on-my-new-windows-11-ho)]

  

Follow these steps sequentially to resolve the issue.

  

Step 1: Force Kill and Restart WSL

  

A hanging or locked background instance often triggers this crash.

- Open PowerShell or Command Prompt (do not run as Administrator).
- Execute .
- Attempt to launch Ubuntu again. [[2](https://superuser.com/questions/1818227/why-does-wsl-install-always-yield-catastrophic-failure-on-my-new-windows-11-ho), [3](https://superuser.com/questions/1921809/why-am-i-getting-a-catastrophic-failure-in-wsl), [4](https://github.com/microsoft/WSL/issues/13263#:~:text=Sequence%20of%20events:%20*%20VS%20Code%20with,I%20am%20working.%20*%20Run%20the%20collect%2Dwsl%2Dlogs.), [5](https://learn.microsoft.com/en-us/answers/questions/4051919/wsl2-not-working-wslregisterdistribution-failed-wi#:~:text=When%20finished%2C%20try%20to%20open%20Ubuntu%20again,problem.%20Here%20is%20a%20link%20to%20t)]

Step 2: Toggle App Storage Location (Common Fix for 24H2+)

  

If you get this failure during installation or after a major Windows update, Windows may be attempting to write to an incorrect drive.

- Open Windows Settings ().
- Navigate to System &gt; Storage &gt; Advanced storage settings &gt; Where new content is saved.
- Change the dropdown under "New apps will save to:" to your C: drive.
- Restart your PC. [[6](https://www.elevenforum.com/t/wsl-wont-install-after-upgrading-to-24h2.24652/#:~:text=I've%20tried%20uninstalling%20the%20distro%20\(Ubuntu\)%2C%20uninstalling,in%20Control%20Panel\)%2C%20making%20sure%20%22New%20a), [7](https://www.reddit.com/r/bashonubuntuonwindows/comments/1di4kqd/catastrophic_failure_on_wsl_first_install/#:~:text=Running%20the%20%22wsl.exe%20%2D%2Dinstall%22%20command%20both%20through,an%20administrator.%20Double%20checking%20that%20I%20act), [8](https://www.reddit.com/r/Winsides/comments/1imygli/fix_installing_windows_subsystem_for_linux/#:~:text=Fix%20%22Installing%20Windows%20Subsystem%20for%20Linux%20Catastrophic%20Failure%22%20Issue%20Windows%2011.&text=The%20Windows%20Subsystem%20for%20Linux%20\(WSL\)%20allows%20you%20to%20run%20a%20Linux%20environm)]

Step 3: Bypass the Windows Store via Manual Update

  

If the internal Windows installer engine is stuck in a loop, updating WSL manually bypasses the breakdown.

- Run in PowerShell.
- If that fails, download the latest package directly from the Official WSL GitHub Releases page and install it manually. [[1](https://github.com/microsoft/WSL/discussions/13434#:~:text=If%20it%20still%20says%20%E2%80%9CCatastrophic%20failure%E2%80%9D%20*,reboot.%20*%20Virtualization%20really%20isn't%20on%20\(even), [2](https://superuser.com/questions/1818227/why-does-wsl-install-always-yield-catastrophic-failure-on-my-new-windows-11-ho), [9](https://stackoverflow.com/questions/79157482/why-am-i-getting-catastrophic-failure-when-installing-wsl-on-windows-10), [10](https://github.com/microsoft/WSL/issues/10222)]

Step 4: Reset Network and System Files

  

Network socket glitches or corrupted underlying system files can completely block the virtual platform.

1. Open Command Prompt as Administrator.
2. Run to clear network dependencies.
3. Run followed by .
4. Reboot your PC. [[8](https://www.reddit.com/r/Winsides/comments/1imygli/fix_installing_windows_subsystem_for_linux/#:~:text=Fix%20%22Installing%20Windows%20Subsystem%20for%20Linux%20Catastrophic%20Failure%22%20Issue%20Windows%2011.&text=The%20Windows%20Subsystem%20for%20Linux%20\(WSL\)%20allows%20you%20to%20run%20a%20Linux%20environm), [11](https://github.com/microsoft/WSL/issues/9420#:~:text=In%20a%20Command%20Prompt%20\(%20%25windir%25%5Csystem32%5Ccmd.exe%20\),Then%2C%20in%20a%20Command%20Prompt%20\(%20%25windir%25%5Csystem32)]

Step 5: Backup and Re-register (If Still Broken)

  

If the prompt opens but crashes moments later, your environment configuration might be corrupt. You can rebuild it without losing your data.

- Export your data: .
- Wipe the broken registration: .
- Re-import a clean copy: . [[2](https://superuser.com/questions/1818227/why-does-wsl-install-always-yield-catastrophic-failure-on-my-new-windows-11-ho), [12](https://www.atera.com/blog/how-to-uninstall-a-wsl-distro-in-windows-11/#:~:text=The%20backup%20command%20is:)]

If you'd like to narrow down the specific fix, tell me:

- When does the error happen? (On WSL startup, during wsl --install, or randomly while working?)
- What Windows version or build number are you running? (Check via )
- Does it display an accompanying error code like ? [[3](https://superuser.com/questions/1921809/why-am-i-getting-a-catastrophic-failure-in-wsl), [4](https://github.com/microsoft/WSL/issues/13263#:~:text=Sequence%20of%20events:%20*%20VS%20Code%20with,I%20am%20working.%20*%20Run%20the%20collect%2Dwsl%2Dlogs.), [13](https://github.com/microsoft/WSL/issues/12324), [14](https://github.com/microsoft/WSL/issues/11862), [15](https://github.com/microsoft/WSL/issues/12672)]

  

_AI responses may include mistakes._

[1] [https://github.com/microsoft/WSL/discussions/13434](https://github.com/microsoft/WSL/discussions/13434#:~:text=If%20it%20still%20says%20%E2%80%9CCatastrophic%20failure%E2%80%9D%20*,reboot.%20*%20Virtualization%20really%20isn't%20on%20\(even)

[2] [https://superuser.com/questions/1818227/why-does-wsl-install-always-yield-catastrophic-failure-on-my-new-windows-11-ho](https://superuser.com/questions/1818227/why-does-wsl-install-always-yield-catastrophic-failure-on-my-new-windows-11-ho)

[3] [https://superuser.com/questions/1921809/why-am-i-getting-a-catastrophic-failure-in-wsl](https://superuser.com/questions/1921809/why-am-i-getting-a-catastrophic-failure-in-wsl)

[4] [https://github.com/microsoft/WSL/issues/13263](https://github.com/microsoft/WSL/issues/13263#:~:text=Sequence%20of%20events:%20*%20VS%20Code%20with,I%20am%20working.%20*%20Run%20the%20collect%2Dwsl%2Dlogs.)

[5] [https://learn.microsoft.com/en-us/answers/questions/4051919/wsl2-not-working-wslregisterdistribution-failed-wi](https://learn.microsoft.com/en-us/answers/questions/4051919/wsl2-not-working-wslregisterdistribution-failed-wi#:~:text=When%20finished%2C%20try%20to%20open%20Ubuntu%20again,problem.%20Here%20is%20a%20link%20to%20t)

[6] [https://www.elevenforum.com/t/wsl-wont-install-after-upgrading-to-24h2.24652/](https://www.elevenforum.com/t/wsl-wont-install-after-upgrading-to-24h2.24652/#:~:text=I've%20tried%20uninstalling%20the%20distro%20\(Ubuntu\)%2C%20uninstalling,in%20Control%20Panel\)%2C%20making%20sure%20%22New%20a)

[7] [https://www.reddit.com/r/bashonubuntuonwindows/comments/1di4kqd/catastrophic_failure_on_wsl_first_install/](https://www.reddit.com/r/bashonubuntuonwindows/comments/1di4kqd/catastrophic_failure_on_wsl_first_install/#:~:text=Running%20the%20%22wsl.exe%20%2D%2Dinstall%22%20command%20both%20through,an%20administrator.%20Double%20checking%20that%20I%20act)

[8] [https://www.reddit.com/r/Winsides/comments/1imygli/fix_installing_windows_subsystem_for_linux/](https://www.reddit.com/r/Winsides/comments/1imygli/fix_installing_windows_subsystem_for_linux/#:~:text=Fix%20%22Installing%20Windows%20Subsystem%20for%20Linux%20Catastrophic%20Failure%22%20Issue%20Windows%2011.&text=The%20Windows%20Subsystem%20for%20Linux%20\(WSL\)%20allows%20you%20to%20run%20a%20Linux%20environm)

[9] [https://stackoverflow.com/questions/79157482/why-am-i-getting-catastrophic-failure-when-installing-wsl-on-windows-10](https://stackoverflow.com/questions/79157482/why-am-i-getting-catastrophic-failure-when-installing-wsl-on-windows-10)

[10] [https://github.com/microsoft/WSL/issues/10222](https://github.com/microsoft/WSL/issues/10222)

[11] [https://github.com/microsoft/WSL/issues/9420](https://github.com/microsoft/WSL/issues/9420#:~:text=In%20a%20Command%20Prompt%20\(%20%25windir%25%5Csystem32%5Ccmd.exe%20\),Then%2C%20in%20a%20Command%20Prompt%20\(%20%25windir%25%5Csystem32)

[12] [https://www.atera.com/blog/how-to-uninstall-a-wsl-distro-in-windows-11/](https://www.atera.com/blog/how-to-uninstall-a-wsl-distro-in-windows-11/#:~:text=The%20backup%20command%20is:)

[13] [https://github.com/microsoft/WSL/issues/12324](https://github.com/microsoft/WSL/issues/12324)

[14] [https://github.com/microsoft/WSL/issues/11862](https://github.com/microsoft/WSL/issues/11862)

[15] [https://github.com/microsoft/WSL/issues/12672](https://github.com/microsoft/WSL/issues/12672)