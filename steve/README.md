# 🦙 Steve — Camp Drama Llama Minecraft Mod

Welcome to **Steve**, the Minecraft mod activity for Camp Drama Llama!  
You will use **Claude Code** to change a real Minecraft 1.20.1 Forge mod that adds **Agent Armor** and builds a giant **Spy Headquarters**.

> 💻 **Windows + PowerShell required.** Minecraft needs Windows to show the game, so use PowerShell (not WSL).

---

## 1. One-line setup

1. Click **Start**, type **`PowerShell`**, and press **Enter**.
2. Copy–paste this one line and press **Enter**:

```powershell
irm https://raw.githubusercontent.com/thinkjones/drama-llama/main/steve/get-drama-llama.ps1 | iex
```

That single command will:
- install **Git** if you don't have it,
- install **Java 17** (the version Minecraft 1.20.1 needs),
- download this folder to **`C:\Users\<you>\drama-llama\steve`**,
- download the Minecraft + Forge gradle files,
- and install a helper command called **`steve`** you can run from any PowerShell window.

> If PowerShell says scripts are blocked, first run:  
> `Set-ExecutionPolicy -Scope Process Bypass`  
> then paste the line above again.

---

## 2. Get help anytime with `steve`

Once setup finishes, open a **new** PowerShell window (so the new `steve` command is ready) and type:

```powershell
steve
```

It prints everything you need:
- how to **build** the mod,
- how to **change** the mod with Claude Code,
- how to **test** it in Minecraft.

You can also run:

| Command | What it does |
|---|---|
| `steve build` | Build the mod jar (`build\libs\agentarmor-1.0.0.jar`) |
| `steve run` | Launch the practice copy of Minecraft with your mod |
| `steve install` | Copy the mod jar into your real Minecraft `mods` folder |
| `steve forge` | Download and install Forge 1.20.1 for the official launcher |

---

## 3. Open the folder in Claude Code

```powershell
cd $HOME\drama-llama\steve
claude
```

Then ask Claude to explain the mod:

> Explain what this Minecraft mod does and what I can change.

Claude reads [`CLAUDE.md`](CLAUDE.md) automatically, so it already knows how the mod works.

---

## 4. What's already here

- **Agent Armor** — helmet, chestplate, leggings, and boots.
- A **surprise welcome!** When you load a world, a big **"Camp Drama Llama"** banner pops up, you get a friendly message, a happy sound plays, and your Agent Armor lands right in your bag. (See `WelcomeHandler.java` — try changing the words!)
- A **giant Spy Headquarters** builds itself near spawn, with **CAMP DRAMA LLAMA** glowing in huge letters — and you spawn right outside the front doors! (See `HeadquartersBuilder.java` — try changing the blocks or the sign text!)

The code lives in `src\main\java\com\dramallama\agentarmor\`.  
The pictures (textures) live in `src\main\resources\assets\agentarmor\`.

---

## 5. Make an alteration 🎨

Pick something to change and ask Claude Code to do it. Ideas:

- **Make the armor super strong:** "Make the Agent Armor protect more than diamond armor."
- **Rename it:** "Rename Agent Armor to Llama Armor everywhere."
- **Change the HQ:** "Build the Spy HQ out of gold blocks."
- **Change the giant sign:** "Make the sign say AGENT ZONE instead."
- **Add a new piece or effect** — ask Claude what's possible!

After a change, ask Claude:

> Explain what you changed and why.

---

## 6. Build the mod

```powershell
steve build
```

(Or run `.\gradlew.bat build` directly.)

- The **first** build downloads Minecraft and Forge, so it takes a while (5–15 minutes). That's normal — grab a snack! 🍎
- When it finishes, your mod file appears in `build\libs\agentarmor-1.0.0.jar`.

> Stuck on an error? Copy it and ask Claude Code: "I got this error when I ran steve build — how do I fix it?"

---

## 7. Test it in Minecraft

### Easiest way — practice Minecraft (no account needed)

```powershell
steve run
```

(Or `.\gradlew.bat runClient`.)

This launches a **practice copy of Minecraft** with your mod already loaded. As soon as you enter a world you'll see the Spy HQ, the giant sign, the welcome banner, and get your armor.

### Real Minecraft (needs Minecraft Java + Forge)

1. Build the mod: `steve build`
2. Install **Forge 1.20.1**: `steve forge`
3. Put the mod jar in your mods folder: `steve install`
4. Launch Minecraft with the **Forge 1.20.1** profile and make a new world.

See [`TESTING.md`](TESTING.md) for full step-by-step details.

---

## Installing Forge 1.20.1

Forge is what lets Minecraft load your mod jar.

1. Go to <https://files.minecraftforge.net/net/minecraftforge/forge/>.
2. Click **1.20.1** on the left side.
3. Download the **Installer**.
   - If you see an ad page first, wait a few seconds and click **Skip** in the top right.
4. Run the downloaded file. If double-clicking doesn't work, open PowerShell and run:
   ```powershell
   java -jar "$HOME\Downloads\forge-1.20.1-47.x.x-installer.jar"
   ```
   Replace `47.x.x` with the actual numbers in the file you downloaded.
5. Make sure **Install client** is selected, then click **OK**.
6. Wait for it to finish. It adds a **Forge 1.20.1** profile to your Minecraft Launcher.
7. Open the Minecraft Launcher, pick the **Forge 1.20.1** profile, and click **Play**.

> ⚠️ **CRITICAL:** This mod is built for **Minecraft 1.20.1 + Forge 47.2.0 only**.  
> Launching with **Minecraft 1.20.2, 1.20.3, 1.20.4, 1.20.5, 1.20.6, 1.21, etc.** will crash with an error like `IncompatibleClassChangeError: ...ArmorMaterial is not an interface`.  
> If you see that crash, you picked the wrong Forge profile. Use **Forge 1.20.1**.

---

## Quick reminder

- `steve` — show help
- `steve build` — build your mod
- `steve run` — test it in practice Minecraft
- `steve forge` — install Forge 1.20.1
- `steve install` — put the mod in your real Minecraft `mods` folder
- Ask Claude Code anything — it's your modding partner!
