# CLAUDE.md — AgentArmor Mod

Guidance for Claude Code when helping a **kid at Camp Drama Llama** modify this
Minecraft mod. Read this fully before making changes.

## Audience & tone
- The user is a **child (roughly 8–14)** in a 3-hour workshop, often making
  their first-ever code change. They may not know programming terms.
- Explain what you're doing in **plain, friendly language**. Avoid jargon; when
  you must use a term (like "durability"), define it in one short sentence.
- Keep changes **small and reversible**. Prefer one clear change at a time.
- After each edit, tell them what to run next and what they should see.
- Be encouraging. Celebrate their ideas. 🦙

## What this mod is
- **Minecraft 1.20.1**, **Forge** (`forge_version=47.2.0` in `gradle.properties`).
- Adds an **Agent Armor** set: helmet, chestplate, leggings, boots.
- Language: **Java 17**. Build tool: **Gradle** (via `./gradlew`).

## Project map
```
steve/
├── build.gradle                 # build configuration (rarely edited)
├── gradle.properties            # mod id/name/version + MC/Forge versions
└── src/main/
    ├── java/com/dramallama/agentarmor/
    │   ├── AgentArmorMod.java       # main class; adds armor to creative menu
    │   ├── ModItems.java            # registers the 4 armor pieces
    │   └── ModArmorMaterials.java   # HOW STRONG the armor is (tweak numbers here)
    └── resources/
        ├── META-INF/mods.toml       # mod metadata Forge reads
        └── assets/agentarmor/
            ├── lang/en_us.json           # display names ("Agent Helmet", etc.)
            ├── models/item/*.json        # links each item to its icon
            └── textures/
                ├── item/*.png                 # inventory icons (16x16)
                └── models/armor/agent_layer_*.png  # armor worn on the body
```

## Common changes (and exactly where to make them)
| Kid asks to...                    | Change this                                              |
|-----------------------------------|---------------------------------------------------------|
| Make armor stronger/weaker        | protection `Map` values in `ModArmorMaterials.java`      |
| Change durability (how long it lasts) | `durabilityMultiplier` (the `37`) in `ModArmorMaterials.java` |
| Change what repairs it            | `Ingredient.of(Items.DIAMOND)` in `ModArmorMaterials.java` |
| Change the equip sound            | `SoundEvents.ARMOR_EQUIP_NETHERITE` in `ModArmorMaterials.java` |
| Rename the armor (display)        | `assets/agentarmor/lang/en_us.json`                     |
| Rename the mod id (advanced)      | `mod_id` in `gradle.properties` + folder/asset names + `mods.toml` — do this carefully and explain the ripple effects |
| Change icon/armor color           | the `.png` files under `textures/` (regenerate placeholders) |

## Build & test commands
- Build the mod jar: `./gradlew build`  → output in `build/libs/`.
- Launch test Minecraft: `./gradlew runClient` (creative → Combat tab).
- **First run downloads Minecraft + Forge (~minutes).** Warn the kid it's slow
  the first time, not broken.

## Guardrails
- Do **not** rename packages, `mod_id`, or asset folders unless the kid clearly
  asks to rename the mod — and if so, change **every** matching place so it
  still builds, then explain what you touched.
- Keep `mods.toml` `modId`, `gradle.properties` `mod_id`, and the
  `assets/agentarmor/` folder name **in sync** — they must all match.
- If a build error appears, read it, explain the cause simply, and fix the
  root cause. Don't guess repeatedly — see `.claude/agents/minecraft-modder.md`.
- Never delete the kid's work without asking.
