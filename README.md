# claude-team

Launch and manage Claude Code agent team sessions.

## What is this?

`claude-team` is a CLI tool that wraps Claude Code with the experimental agent teams feature enabled. It handles:

- Interactive teammate display mode selection (auto, in-process, tmux)
- Automatic tmux session management (including iTerm2 control mode)
- Orchestrator system prompt injection
- Session lifecycle hooks

## Installation

### Homebrew (recommended)

```bash
brew tap nsheaps/devsetup
brew install claude-team
```

### Manual install (clone + symlink)

```bash
git clone https://github.com/nsheaps/claude-team.git ~/.claude-team
ln -s ~/.claude-team/bin/claude-team /usr/local/bin/claude-team
ln -s ~/.claude-team/bin/ct /usr/local/bin/ct
```

### Manual install (PATH)

```bash
git clone https://github.com/nsheaps/claude-team.git ~/.claude-team
echo 'export PATH="$HOME/.claude-team/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc
```

## Usage

```bash
# Interactive mode picker
claude-team

# Shorthand
ct

# Specify mode directly
claude-team --mode tmux
claude-team --mode in-process
claude-team --mode auto

# Pass extra args to claude
claude-team --mode tmux -- --resume

# Non-interactive (for scripts)
claude-team --no-interactive
```

## Keyboard Controls

Once in a team session:

| Key | Action |
|-----|--------|
| Shift+Up/Down | Cycle through teammates |
| Enter | View selected teammate |
| Escape | Interrupt teammate's turn |
| Ctrl+T | Toggle task list |
| Shift+Tab | Toggle delegate mode |

## Dependencies

- [Claude Code](https://docs.anthropic.com/en/docs/claude-code) (`claude` CLI)
- [gum](https://github.com/charmbracelet/gum) (interactive mode picker)
- [tmux](https://github.com/tmux/tmux) (optional, for tmux teammate mode)

## Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `CLAUDE_TEAM_DEFAULT_MODE` | `auto` | Default mode for `--no-interactive` |
| `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS` | set to `1` | Enables agent teams (set automatically) |

## License

MIT
