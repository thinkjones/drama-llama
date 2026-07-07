# 🚀 Get Started (Windows) — download the workshop files

The Minecraft mod activity runs on **Windows in PowerShell**. Before you can use
it, you need the workshop files on your computer. This one script installs
**Git** and downloads everything to your home folder.

---

## The easy way — one line

1. Click **Start**, type **`PowerShell`**, and press **Enter**.
2. Copy–paste this line and press **Enter**:

```powershell
irm https://raw.githubusercontent.com/thinkjones/drama-llama/main/steve/get-drama-llama.ps1 | iex
```

That's it! It will:
- install **Git** if you don't have it, and
- download the repo to **`C:\Users\<you>\drama-llama`** (your home folder).

> If PowerShell says scripts are blocked, first run:
> `Set-ExecutionPolicy -Scope Process Bypass` and try again.

---

## Already have the file?

If you already downloaded `get-drama-llama.ps1`, just run it from PowerShell:

```powershell
.\get-drama-llama.ps1
```

## No winget / it didn't work?

Install Git by hand from <https://git-scm.com/download/win>, then run:

```powershell
git clone https://github.com/thinkjones/drama-llama.git $HOME\drama-llama
```

---

## What's next?

Once the download finishes, head into the mod folder and follow the cheatsheet:

```powershell
cd $HOME\drama-llama\steve
```

- **[CHEATSHEET.md](CHEATSHEET.md)** — build and change the mod with Claude Code.
- **[TESTING.md](TESTING.md)** — two ways to see your mod in Minecraft.
