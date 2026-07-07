# AGENTS.md

This mod is part of **Camp Drama Llama**, a kids' workshop. If you are an AI
coding agent working in this folder, the authoritative guidance lives in
[`CLAUDE.md`](./CLAUDE.md) — read it first.

Quick summary:
- **Minecraft 1.20.1 / Forge 47.2.0 / Java 17**, built with `./gradlew`.
- Adds an **Agent Armor** set (helmet, chestplate, leggings, boots).
- Users are **children making their first code change** — explain simply, keep
  changes small, and always say what command to run next.
- A specialized helper agent is defined in
  [`.claude/agents/minecraft-modder.md`](./.claude/agents/minecraft-modder.md).

Build: `./gradlew build` · Test in-game: `./gradlew runClient`
