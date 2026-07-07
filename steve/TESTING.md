# 🎮 Testing the AgentArmor Mod — Two Ways

There are two ways to see the mod in Minecraft. **Way A is easiest** and is what
we recommend for the workshop. **Way B** lets kids play the mod in their own
real Minecraft. Both run on **Windows / PowerShell** (not WSL — Minecraft needs
Windows to render the game).

> Prereqs for both: a **Windows JDK 17** and this repo on the **Windows
> filesystem** (e.g. `C:\Users\<name>\drama-llama\steve`). See
> `teacher-prep/` for setup.

| | **Way A — `runClient`** | **Way B — real Minecraft + Forge** |
|---|---|---|
| Needs a paid Minecraft account? | **No** | **Yes** (Minecraft: Java Edition) |
| Needs the Forge installer? | No | Yes (Forge 1.20.1) |
| Speed to first launch | One command | A few setup steps, then fast |
| Best for | Quick testing during the workshop | Keeping/playing the mod for real |
| Each change | re-run `runClient` | rebuild + copy jar + relaunch |

---

## Way A — `runClient` (recommended, no Minecraft license)

`runClient` launches a **development copy** of Minecraft with the mod already
loaded. You do **not** need to own Minecraft, and you do **not** copy any files.

1. Open **PowerShell** and go to the mod:
   ```powershell
   cd $HOME\drama-llama\steve
   ```
2. Launch it:
   ```powershell
   .\gradlew.bat runClient
   ```
   - The **first time** downloads Minecraft + Forge (5–15 min). After that it's
     quick.
3. When Minecraft opens: **Singleplayer → Create New World → Create**.
4. As soon as you spawn you'll see:
   - the **Spy HQ** with the giant glowing **CAMP DRAMA LLAMA** sign,
   - the **welcome banner** and chat message,
   - your **Agent Armor** already in your inventory.
5. Your armor is also in the **Combat** tab of the creative inventory.

**To test a change:** close the game, run `.\gradlew.bat runClient` again.

> 💡 `runClient` uses a throwaway "dev" world stored under `steve\run\`. It's
> separate from your real Minecraft — nothing here affects your real saves.

---

## Way B — Your real Minecraft (needs Minecraft Java + Forge)

Use this to play the mod in your actual Minecraft. The mod file (a `.jar`) is
the same on every computer, so a jar you built works in real Minecraft too.

### One-time setup
1. Install **Minecraft: Java Edition** and run version **1.20.1** once (so the
   files exist).
2. Download the **Minecraft Forge 1.20.1** installer from
   <https://files.minecraftforge.net> (pick 1.20.1), run it, and choose
   **Install client**. This adds a **Forge 1.20.1** profile to the launcher.

### Every time you want to test
1. Build the jar in **PowerShell**:
   ```powershell
   cd $HOME\drama-llama\steve
   .\gradlew.bat build
   ```
   The mod is now at `build\libs\agentarmor-1.0.0.jar`.
2. Put the jar in the right **mods** folder for the launcher you are using:

   **Official Minecraft Launcher**
   - Press **Win + R**, paste `%APPDATA%\.minecraft\mods`, and press Enter.
   - Copy `build\libs\agentarmor-1.0.0.jar` into that folder.
   - Or from PowerShell: `steve install`

   **CurseForge**
   - In CurseForge, click your **Minecraft** section.
   - Create a **Custom Profile** with:
     - **Minecraft version:** `1.20.1`
     - **Modloader:** `Forge` (pick the latest `47.x` version)
   - Right-click the profile → **Open Folder**.
   - Copy `build\libs\agentarmor-1.0.0.jar` into the `mods` folder inside that profile.
   - Click **Play** on that profile.

3. Open the launcher, choose the **Forge 1.20.1** profile, click **Play**, then
   **Create New World**.
4. You'll spawn at the **Spy HQ** with your armor — just like Way A.

### To test a new change
Rebuild (`.\gradlew.bat build` or `steve build`), copy the new jar over the old
one, and relaunch Minecraft. Delete the old jar first if the filename changed.

> ⚠️ The mod is built for **Minecraft 1.20.1 + Forge only**. It won't load on
> other versions or on Fabric.

---

## Troubleshooting
- **`.\gradlew.bat` "not recognized":** make sure you're inside the `steve`
  folder (`cd $HOME\drama-llama\steve`).
- **Build fails the first time:** it's usually a slow/interrupted download —
  run it again. Still stuck? Paste the error to Claude Code.
- **Mod doesn't appear in real Minecraft (Way B):** check you launched the
  **Forge 1.20.1** profile (not vanilla) and the jar is in
  `%APPDATA%\.minecraft\mods`.
- **Wrong Java:** these need **JDK 17**. Check with `java -version`.
