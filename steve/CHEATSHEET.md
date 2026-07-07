# ⛏️ Activity 3: Minecraft Mod — Cheatsheet

**Your mission:** You have a real Minecraft mod that adds a set of **Agent
Armor** and builds a **Spy Headquarters**. Use **Claude Code** to change it and
make it your own!

> 💻 **This activity runs on Windows, not Ubuntu.** Minecraft needs Windows to
> show the game, so we use **PowerShell** here instead of the WSL terminal you
> used in Activities 1 and 2.

> 📥 **Don't have the files yet?** Do **[GET-STARTED.md](GET-STARTED.md)** first
> — one line in PowerShell installs Git and downloads everything to your home
> folder.

---

## 1. Open PowerShell and go to this folder

1. Click the **Start** menu.
2. Type **`PowerShell`** and press **Enter** (a blue window opens).
3. Type this and press **Enter**:

```powershell
cd $HOME\drama-llama\steve
```

`cd` means "change folder" and `$HOME` is your Windows home folder. Type `ls`
(or `dir`) to see the files.

---

## 2. What's already here

- **Agent Armor** — a helmet, chestplate, leggings, and boots.
- A **surprise welcome!** When you load a world, a big **"Camp Drama Llama"**
  banner pops up, you get a friendly message, a happy sound plays, and your
  Agent Armor lands right in your bag. 🦙 (See `WelcomeHandler.java` — try
  changing the words!)
- A **giant Spy Headquarters** builds itself near spawn, with **CAMP DRAMA
  LLAMA** glowing in huge letters — and you spawn right outside the front
  doors! (See `HeadquartersBuilder.java` — try changing the blocks or the
  sign text!)
- The code lives in `src\main\java\com\dramallama\agentarmor\`.
- The pictures (textures) live in `src\main\resources\assets\agentarmor\`.

---

## 3. Start Claude Code and explore

```powershell
claude
```

Then ask Claude to explain the mod to you:

> Explain what this Minecraft mod does and what I can change.

Claude has a guide (`CLAUDE.md`) in this folder, so it already knows how the
mod works!

---

## 4. Make an alteration 🎨

Pick something to change and ask Claude Code to do it. Ideas:

- **Make the armor super strong:** "Make the Agent Armor protect more than
  diamond armor."
- **Rename it:** "Rename Agent Armor to Llama Armor everywhere."
- **Change the HQ:** "Build the Spy HQ out of gold blocks."
- **Change the giant sign:** "Make the sign say AGENT ZONE instead."
- **Add a new piece or effect** — ask Claude what's possible!

After a change, ask Claude:

> Explain what you changed and why.

---

## 5. Build the mod

To turn your code into a real mod file, type:

```powershell
.\gradlew.bat build
```

- The **first** build downloads Minecraft and Forge, so it takes a while
  (5–15 minutes). That's normal — grab a snack! 🍎
- When it finishes, your mod file appears in `build\libs\agentarmor-1.0.0.jar`.

> Stuck on an error? Copy it and ask Claude Code: "I got this error when I ran
> .\gradlew.bat build — how do I fix it?"

---

## 6. Test it in Minecraft — two ways

There are **two ways** to see your mod in the game. Full step-by-step for both
is in **[`TESTING.md`](TESTING.md)** — here's the quick version:

### Way A — Test Minecraft (easiest, no Minecraft account needed)

```powershell
.\gradlew.bat runClient
```

This launches a **practice copy of Minecraft** with your mod already loaded.
As soon as you enter a world you'll see the **Spy HQ**, the giant sign, the
welcome banner, and get your armor. Great for quick testing!

### Way B — Your real Minecraft (needs Minecraft Java + Forge installed)

1. Build the mod: `.\gradlew.bat build`
2. Copy `build\libs\agentarmor-1.0.0.jar` into your Minecraft **mods** folder.
3. Launch Minecraft with the **Forge 1.20.1** profile and make a new world.

Use this if you want to play your mod in your own Minecraft with your friends.
See [`TESTING.md`](TESTING.md) for the exact steps.

---

### 💡 Remember
- `.\gradlew.bat build` = build your mod
- `.\gradlew.bat runClient` = test it in practice Minecraft
- Ask Claude Code anything — it's your modding partner!
