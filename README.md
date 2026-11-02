# dotfiles

MacOS + AeroSpace
## Claude Code statusline

Copy `.claude/statusline.sh` to `~/.claude/statusline.sh` (needs `jq` and `python3`), then add this to `~/.claude/settings.json`:

```json
"statusLine": {
  "type": "command",
  "command": "~/.claude/statusline.sh"
}
```

It shows: model (effort) | dir (branch) | context used | 5-hour limit used → projected at reset | weekly limit used → projected at reset (business hours).
