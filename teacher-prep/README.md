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
# Option A: run the helper script (from this folder)
.\setup-windows.ps1

# Option B: just the core command
wsl --install -d Ubuntu
```

Then **reboot**. After reboot, Ubuntu opens — create a **username and
password** (write them down!).

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
