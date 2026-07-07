# 🦙 Camp Drama Llama

A 3-hour workshop that teaches kids computer fundamentals and AI. Each folder is
one hands-on activity. This repo gets synced to `~/drama-llama/` on each
student machine (Windows + WSL/Ubuntu).

## For teachers — start here
See **[`teacher-prep/README.md`](teacher-prep/README.md)** to set up each
computer (WSL, apps, Claude Code, and this repo) before class.

## Activities

| # | Folder | Topic | Kids' guide |
|---|--------|-------|-------------|
| 1 | [`twilightsparkle/`](twilightsparkle/) | Files & Folders — hunt for `activity2.txt` in the terminal | [CHEATSHEET](twilightsparkle/CHEATSHEET.md) |
| 2 | [`gohan/`](gohan/) | Welcome to Python — use Claude Code to write `agent_welcome.py` | [CHEATSHEET](gohan/CHEATSHEET.md) |
| 3 | [`steve/`](steve/) | Minecraft Mod — alter a Forge 1.20.1 mod with Claude Code | [CHEATSHEET](steve/CHEATSHEET.md) |

### Activity 1 — Files & Folders (`twilightsparkle/`)
A 5-level-deep maze of folders named after ponies, Barbie, and Dragon Ball Z.
Kids navigate with `cd`/`ls` to find the one `activity2.txt` hidden among the
`dead-end` files. It reveals a code word for Activity 2.

### Activity 2 — Welcome to Python (`gohan/`)
Kids launch Claude Code and ask it to write a Python program that greets them by
their "agent name" with ASCII art, then customize the art. (The `gohan/` folder
starts empty except its cheatsheet — the kids create the code.)

### Activity 3 — Minecraft Mod (`steve/`)
A ready-to-build **Forge 1.20.1** mod that adds an **Agent Armor** set and builds
a **Spy HQ** with a giant "CAMP DRAMA LLAMA" sign at spawn. When a player joins a
world it flashes a **"Camp Drama Llama"** welcome, plays a sound, hands them the
armor, and drops them outside the HQ — so the very first test is fun to see. Kids
use Claude Code to change it (the HQ, the sign, stats, names, new pieces).
Includes `CLAUDE.md` and a `minecraft-modder` helper agent.

**This activity runs natively on Windows/PowerShell** (Minecraft needs Windows
to render): build with `.\gradlew.bat build`, then test either with
`.\gradlew.bat runClient` (no Minecraft account needed) or by dropping the built
jar into a real Minecraft + Forge install — see [`steve/TESTING.md`](steve/TESTING.md).

## Repo layout
```
drama-llama/
├── README.md
├── twilightsparkle/     Activity 1 (folder maze + cheatsheet)
├── gohan/               Activity 2 (cheatsheet; kids write the code)
├── steve/               Activity 3 (Forge mod template + guides)
├── teacher-prep/        Machine setup scripts + guide
└── docs/                Workshop plan and slides
```
