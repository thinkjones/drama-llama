# 🕵️ Activity 1: Files & Folders — Cheatsheet

**Your mission:** Somewhere deep inside the `twilightsparkle` folder is a file
called **`activity2.txt`**. Use the terminal to hunt it down!

---

## 1. Open the terminal (Windows)

We use a Linux terminal on Windows called **WSL (Ubuntu)**.

1. Click the **Start** menu (the Windows logo, bottom-left).
2. Type the word **`Ubuntu`**.
3. Click the orange **Ubuntu** icon that appears.
4. A black window opens with some text and a blinking cursor. That's the terminal! 🎉

> If you don't see Ubuntu, ask your instructor — it may need to be turned on.

Username: rainbow
Password: dash


---

## 2. Go to the workshop folder

Everything for camp lives in a folder called `drama-llama` inside your **home**
folder. Home is where you always start.

Type each command and press **Enter**:

```bash
cd ~/drama-llama
```

- `cd` means **"change directory"** (move into a folder).
- `~` is a shortcut that means **"my home folder"**.

Now move into today's first activity:

```bash
cd twilightsparkle
```

---

## 3. Look around and move through folders

| I want to...                        | Type this      | What it does                          |
|-------------------------------------|----------------|---------------------------------------|
| See what's inside this folder       | `ls`           | **L**i**s**ts files and folders       |
| Go **into** a folder                | `cd foldername`| Moves into that folder                |
| Go **back up** one folder           | `cd ..`        | `..` means "the folder above me"      |
| See where I am right now            | `pwd`          | **P**rint **W**orking **D**irectory   |
| Jump all the way home               | `cd ~`         | Back to your home folder              |

### 💡 Super tip: Tab completion
Start typing a folder name, then press the **Tab** key — the terminal finishes
it for you! Type `cd ra` then press **Tab** and it becomes `cd rarity/`.

---

## 4. The hunt

The folders are nested **5 levels deep** and named after ponies, Barbie
characters, and Dragon Ball Z fighters. Most trails end in a file called
`dead-end`. Only **one** trail has `activity2.txt`.

Try this loop:
1. `ls` — see what folders are here.
2. `cd` into one that looks interesting.
3. `ls` again.
4. Hit a `dead-end`? Type `cd ..` and try another folder.
5. Keep going until you find `activity2.txt`!

---

## 5. Read a file in the terminal

Found `activity2.txt`? Open it with:

```bash
cat activity2.txt
```

- `cat` prints a file's contents right in the terminal.

It has a secret code word for the next activity. Tell your instructor! 🦙

---

### 🚀 Bonus challenge
Can you find the file **without** clicking around, using just one command?
Ask your instructor about the `find` command:

```bash
find . -name activity2.txt
```
