# ⛏️ Activity 3: Minecraft Mod — Cheatsheet

**Your mission:** You have a real Minecraft mod that adds a set of **Agent
Armor**. Use **Claude Code** to change it and make it your own!

---

## 1. Open the terminal and go to this folder

Open **Ubuntu** from the Start menu, then type:

```bash
cd ~/drama-llama/steve
```

This is the mod. Type `ls` to see the files.

---

## 2. What's already here

- **Agent Armor** — a helmet, chestplate, leggings, and boots.
- A **surprise welcome!** When you load a world, a big **"Camp Drama Llama"**
  banner pops up, you get a friendly message, a happy sound plays, and your
  Agent Armor lands right in your bag. 🦙 (See `WelcomeHandler.java` — try
  changing the words!)
- The code lives in `src/main/java/com/dramallama/agentarmor/`.
- The pictures (textures) live in `src/main/resources/assets/agentarmor/`.

---

## 3. Start Claude Code and explore

```bash
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
- **Change what repairs it:** "Make the Agent Armor repairable with gold
  instead of diamonds."
- **Rename it:** "Rename Agent Armor to Llama Armor everywhere."
- **Change the color:** "Change the armor texture color to purple."
- **Add a new piece or effect** — ask Claude what's possible!

After a change, ask Claude:

> Explain what you changed and why.

---

## 5. Build the mod

To turn your code into a real mod file Minecraft can load, type:

```bash
./gradlew build
```

- The **first** build downloads Minecraft and Forge, so it takes a while
  (5–15 minutes). That's normal — grab a snack! 🍎
- When it finishes, your mod file appears in `build/libs/agentarmor-1.0.0.jar`.

> Stuck on an error? Copy it and ask Claude Code: "I got this error when I ran
> ./gradlew build — how do I fix it?"

---

## 6. Test it in Minecraft (with your instructor)

```bash
./gradlew runClient
```

This launches a test copy of Minecraft with your mod loaded. As soon as you
enter a world you'll see the **Camp Drama Llama** welcome and get your armor.
You can also find it any time in the **Combat** tab of the creative inventory!

---

### 💡 Remember
- `./gradlew build` = build your mod
- `./gradlew runClient` = test it in Minecraft
- Ask Claude Code anything — it's your modding partner!
