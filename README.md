# claude-team

Launch and manage Claude Code agent team sessions.

## What is this?

`claude-team` is a CLI tool that wraps Claude Code with the experimental agent teams feature enabled. It handles:

- Interactive teammate display mode selection (auto, in-process, tmux)
- Automatic tmux session management (including iTerm2 `tmux -CC` control mode)
- Orchestrator system prompt injection for lead coordination
- Session lifecycle hooks (start/stop notifications)
- Automatic dependency installation via Homebrew (gum, tmux)

## Installation

### Homebrew

> **Note**: Homebrew formula is not yet published. Use manual installation for now.

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
# Interactive mode picker (prompts via gum)
claude-team

# Shorthand alias
ct

# Specify mode directly (skips interactive prompt)
claude-team -m tmux
claude-team --mode in-process
claude-team --mode auto

# Pass extra args to claude after --
claude-team --mode tmux -- --resume

# Non-interactive mode (uses CLAUDE_TEAM_DEFAULT_MODE or "auto")
claude-team --no-interactive

# Show help
claude-team --help
```

### Teammate Display Modes

| Mode | Description |
|:-----|:------------|
| `auto` | Auto-detect best backend (default) |
| `in-process` | Hidden sessions within the same process, navigate with Shift+Up/Down |
| `tmux` | Visible split panes; auto-launches `tmux -CC` if not already in a tmux session |

### What the Script Does

When launched, `claude-team`:

1. Prompts for teammate mode (or uses `--mode`/`--no-interactive`)
2. Auto-installs missing dependencies (gum, tmux) via Homebrew
3. If tmux mode is selected and you're not in a tmux session, auto-launches `tmux -CC` (iTerm2 control mode)
4. Launches `claude` with:
   - `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1`
   - `--teammate-mode <selected>`
   - `--permission-mode delegate`
   - `--continue` (resumes previous session)
   - `--dangerously-skip-permissions`
   - An orchestrator system prompt
   - Session start/stop lifecycle hooks

> **Security note**: The script uses `--dangerously-skip-permissions` by default, which allows Claude to execute any tool without confirmation. This is intended for orchestrator sessions where the lead needs uninterrupted coordination.

## Keyboard Controls

Once in a team session:

| Key | Action |
|:----|:-------|
| Shift+Up/Down | Cycle through teammates (in-process mode) |
| Enter | View selected teammate |
| Escape | Interrupt teammate's turn |
| Ctrl+T | Toggle task list |
| Ctrl+O | Toggle verbose transcript |
| Shift+Tab | Toggle delegate mode (lead coordination only) |

> **Tip:** When a teammate agent is unresponsive (stuck mid-turn and not processing messages), send the ESC key via tmux to interrupt its current turn and allow pending messages to propagate. Example: `tmux send-keys -t <pane-id> Escape`

## Dependencies

- [Claude Code](https://code.claude.com/) (`claude` CLI) -- required
- [gum](https://github.com/charmbracelet/gum) -- interactive mode picker (auto-installed via Homebrew if missing)
- [tmux](https://github.com/tmux/tmux) -- required for tmux mode (auto-installed via Homebrew if missing)
- [Homebrew](https://brew.sh/) -- used for auto-installing gum and tmux

## Environment Variables

| Variable | Default | Description |
|:---------|:--------|:------------|
| `CLAUDE_TEAM_DEFAULT_MODE` | `auto` | Default teammate mode when using `--no-interactive` |
| `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS` | set to `1` | Enables agent teams (set automatically by the script) |

## Development

```bash
# Lint shell scripts (syntax check)
mise run lint

# Format markdown with prettier
mise run fmt

# Check markdown formatting
mise run fmt-check
```

## Project Structure

```
bin/
  claude-team      # Main launcher script
  ct               # Shorthand alias (delegates to claude-team)
  lib/
    stdlib.sh      # Shared utilities (colors, logging, check_and_install)
mise.toml          # Task runner config (lint, fmt, test)
```

## Relationship to claude-utils

`claude-team` was extracted from [claude-utils](https://github.com/nsheaps/claude-utils). If you install claude-utils via Homebrew, claude-team is installed automatically as a dependency. You can also install claude-team standalone.

## License

MIT
