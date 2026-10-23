# Quota

A small Mac menu bar app that shows how much of your AI subscriptions you've used,
right next to the clock:

```
✳ 42% · 61%  |  ◎ 12%  |  ✦ 30%  |  ◆ 8%
```

- **Claude** (Pro/Max): 5-hour, 7-day and model weekly limits, with a pace marker
  that tells you if you'll run out early ("27% ahead · runs out ~Mon · 2 days early").
- **Codex** (ChatGPT Plus/Pro): your Codex limits and any free resets.
- **Antigravity** (Google): its two weekly allowances, one shared by the Gemini models and one by
  the Claude and GPT models you use inside Antigravity (separate from your Claude and ChatGPT plans).
- **Grok** (SuperGrok): your weekly credit usage, read from the Grok CLI.
- **History**: what you used over 7 days, 30 days or all time, by model, and what the
  same usage would have cost on the Claude and OpenAI APIs.

This repository only hosts the downloads.

## Before you install

- A Mac with macOS 13 or later.
- **Claude Code**, signed in with your Claude account. If you've never used it:
  install it from [claude.com/code](https://claude.com/code), open Terminal, type
  `claude`, then `/login`, and follow the browser.
- Optional: the **Codex** command-line tool or the **ChatGPT** desktop app, signed in,
  for the Codex section, and Google's **Antigravity** CLI (`agy`) for the Antigravity section.

## Install (one time)

**Easiest: paste this into Terminal** (Applications → Utilities → Terminal):

```
curl -fsSL https://raw.githubusercontent.com/DavidMolina001/quota-app/main/install.sh | sh
```

It downloads the latest version, checks it, puts Quota in Applications and opens it.

**Or by hand:**

1. Download `Quota-x.y.z.zip` from [Releases](https://github.com/DavidMolina001/quota-app/releases/latest) and open it.
2. Drag **Quota** into **Applications** and open it.
3. macOS will say it "could not verify" Quota (it's not from the App Store). Open
   **System Settings → Privacy & Security**, scroll down, click **Open Anyway**.
   You only do this once.

Then click Quota in the menu bar and turn on **Launch at login**.

## Updates

Nothing to do. Quota checks for new versions every hour, downloads them and
installs them quietly while its panel is closed. Every update is checked against its
checksum and must be signed with the same certificate as the copy you have, or it's
thrown away.

## Privacy

- Quota gets its numbers by asking Claude Code, Codex, Antigravity and Grok, already on your Mac and
  signed in as you, for their own usage reports.
- History comes from the logs those tools already keep on your Mac. Only token counts,
  model names and dates are read, never your conversations.
- Quota never reads your passwords, login tokens or cookies, never sends your usage
  anywhere, and needs no special macOS permissions. Its only network request is the
  update check.

## Uninstall

Click Quota → Quit Quota, then drag it from Applications to the Bin.
