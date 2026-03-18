# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Architecture

This is a modular Neovim configuration using lazy.nvim as the plugin manager.

```
~/.config/nvim/
├── init.lua              # Entry: sets leader, loads options → autocmds → keymaps → plugins
├── lua/
│   ├── options.lua       # Editor settings (tabs, line numbers, etc.)
│   ├── autocmds.lua      # Autocommands (restore cursor, auto-save folds, etc.)
│   ├── keymaps.lua       # Global keybindings
│   └── plugins/          # Plugin specs (one file per category)
│       ├── init.lua      # Bootstraps lazy.nvim, loads all specs
│       ├── lsp.lua       # LSP + Mason configuration
│       ├── completion.lua
│       ├── telescope.lua
│       └── ...
```

**Load order:** `init.lua` → `options` → `autocmds` → `keymaps` → `plugins/init.lua` (bootstraps lazy.nvim, loads all plugin specs)

## Plugin Management

**Adding a plugin:** Create or edit a file in `lua/plugins/`, return a table with lazy.nvim spec:

```lua
return {
  {
    "author/plugin",
    dependencies = { "dep/one" },
    event = "VeryLazy",  -- lazy load trigger
    opts = {},           -- passed to plugin.setup()
  }
}
```

**Commands:**
- `:Lazy` - Open plugin manager UI
- `:Lazy sync` - Install/update plugins
- `:Mason` - Manage LSP servers, linters, formatters

## LSP Configuration

Uses Neovim 0.11+ native `vim.lsp.config()` in `lua/plugins/lsp.lua`. Servers are auto-installed via Mason.

**To add a new LSP server:**
1. Add server name to the `servers` table in `lsp.lua`
2. Optionally configure via `vim.lsp.config["server_name"] = { settings = {...} }`

## Key Bindings

Leader: `<space>`

| Key | Action |
|-----|--------|
| `<leader>ff` | Find files |
| `<leader>fg` | Live grep |
| `<leader>n` | Toggle file tree |
| `gd` | Go to definition |
| `gr` | References |
| `K` | Hover documentation |
| `<leader>rn` | Rename symbol |

## Custom Commands

- `:S` - Reload config
- `:Note` - Enable spell check + markdown mode
- `:DiffSaved` - Diff buffer vs saved file

## Claude Multi Integration

The config includes `claude-multi.nvim` (local dev at `~/Desktop/code/claude-multi.nvim`) for multi-session Claude Code management. Uses `<M-h>`/`<M-l>` for session navigation.

## Testing Changes

1. Make edits to config files
2. Run `:S` to reload, or restart Neovim
3. Check `:messages` for errors
4. Use `:checkhealth` for diagnostics

## Customization Pipeline

**Type `/customize` to start an autonomous pipeline for building new features.**

```
┌─────────────────────────────────────────────────────────────────┐
│  You → [Planner] → [Reviewer] → [Implementer] → [Tester] → You │
│            ↑            │              ↑            │          │
│            └────────────┘              └────────────┘          │
│              (iterate)                   (iterate)             │
└─────────────────────────────────────────────────────────────────┘
```

The pipeline runs autonomously - you provide the idea, agents collaborate, you review the result.

### Pipeline Agents

| Agent | Role | What It Does |
|-------|------|--------------|
| **Planner** | Brainstorm | Asks lots of questions, creates UI mockups, writes spec |
| **Reviewer** | Quality Gate | Checks UX, conflicts, edge cases |
| **Implementer** | Code | Writes clean Lua following your patterns |
| **Tester** | Verify | Tests via MCP, catches bugs |

### Quick Reference: Where Things Go

| Want to add... | Put it in... | Example |
|----------------|--------------|---------|
| External plugin | `lua/plugins/[category].lua` | telescope.lua |
| Global keymap | `lua/keymaps.lua` | |
| Plugin keymap | Inline `keys = {}` in spec | telescope.lua |
| Autocommand | `lua/autocmds.lua` | |
| Editor option | `lua/options.lua` | |
| New plugin (dev) | `~/Desktop/code/[name]/` | claude-multi.nvim |

## Custom Subagents

This config has specialized subagents in `.claude/agents/`:

### Neovim Planner
Brainstorms features through extensive questioning. Creates visual UI mockups and detailed specifications.

### Neovim Reviewer
Reviews specs for UX issues, conflicts with existing config, and edge cases. Quality gate before implementation.

### neovim-lua-expert
Writes/refactors Lua config code. Handles plugin configs, keybindings, autocommands, LSP setup.

### neovim-config-tester
Tests config changes in a live Neovim instance via MCP. Verifies plugins load, keybindings work, checks for errors.

**Starting a test Neovim instance:** If no Neovim is connected via MCP, start one in the background:

```bash
# Check if socket exists and is active
if ! nvim --server /tmp/nvim --remote-expr "1" 2>/dev/null; then
  # Start Neovim listening on socket
  nvim --listen /tmp/nvim &
fi
```

### Manual Workflow (Without Pipeline)

1. **Implement** with `neovim-lua-expert` - writes clean, modular Lua code
2. **Test** with `neovim-config-tester` - verifies changes work via MCP connection to Neovim
3. **Iterate** - fix any issues found during testing

The tester agent has access to MCP tools (`mcp__neovim__vim_*`) to directly interact with the running Neovim instance.
