<div class="nav-top">

[<- Back to Index](index.html)

</div>

# Step 6: New Cool Things

cagent is evolving fast. Here are some of the newest and most interesting features.

## Memory System

The memory tool gives agents persistent memory across sessions. Your agent can remember your preferences, project context, and past conversations -- even after you close and reopen cagent.

> Run it: `cagent run examples/6.1-memory-assistant.yaml`

```yaml
agents:
  root:
    model: anthropic/claude-sonnet-4-5
    instruction: |
      You are a personal assistant. Remember the user's preferences
      and context from previous conversations.
      Always check your memory before asking questions the user
      may have already answered.
    toolsets:
      - type: memory
        path: ./assistant_memory.db
```

### How It Works

- The agent stores information in a local SQLite database
- On subsequent sessions, it can recall stored information
- Memory persists across `cagent run` invocations -- close and reopen, and it still remembers
- The `path` field controls where the database is stored
- To reset memory, simply delete the `.db` file

### Try It

1. Run the memory assistant: `cagent run examples/6.1-memory-assistant.yaml`
2. Tell it your name and what programming language you prefer
3. Exit and run it again
4. Ask "What's my name?" -- it should remember!

### Shared Memory Across Agents

In multi-agent setups, agents can share the same memory database. This means findings from one agent are available to others:

> Run it: `cagent run examples/6.2-shared-memory.yaml`

```yaml
agents:
  root:
    model: anthropic/claude-sonnet-4-5
    instruction: You are a team lead
    sub_agents: [researcher]
    toolsets:
      - type: memory
        path: ./team_memory.db

  researcher:
    model: openai/gpt-4o
    description: Research specialist
    instruction: Research topics and remember findings
    toolsets:
      - type: memory
        path: ./team_memory.db
      - type: mcp
        ref: docker:duckduckgo
```

Both agents read from and write to the same memory, so the researcher's findings are automatically available to the team lead.

---

## Speech to Text

cagent supports voice input -- you can talk to your agents instead of typing. In the TUI, press `Ctrl+K` to toggle voice mode. cagent will listen through your microphone, transcribe your speech, and send it as a message.

This is especially useful for:

- Hands-free coding assistance while looking at code
- Giving longer, more natural instructions without typing
- Accessibility

<div class="tip">

**Note:** Speech-to-text uses your system's audio input. Make sure your microphone is working and permissions are granted. Check `cagent run --help` for voice-related flags.

</div>

---

## Script Tools

Define custom shell commands as tools -- no MCP server needed:

> Run it: `cagent run examples/6.3-script-tools.yaml`

```yaml
agents:
  root:
    model: openai/gpt-4o
    instruction: You are a DevOps assistant
    toolsets:
      - type: script
        shell:
          get_ip:
            cmd: "curl -s https://ipinfo.io | jq -r .ip"
            description: "Get my public IP address"
          docker_ps:
            cmd: "docker ps --format 'table {{.Names}}\t{{.Status}}\t{{.Ports}}'"
            description: "List running Docker containers"
          disk_usage:
            cmd: "df -h / | tail -1"
            description: "Check disk usage"
```

### API Tools

Expose HTTP endpoints as tools:

> Run it: `cagent run examples/6.4-api-tool.yaml`

```yaml
agents:
  root:
    model: openai/gpt-4o
    instruction: You are an assistant that can look up puzzles
    toolsets:
      - type: api
        api_config:
          name: daily-puzzle
          instruction: Get the daily chess puzzle
          endpoint: https://api.chess.com/pub/puzzle
          method: GET
```

---

## Commands (Agent Shortcuts)

Define named commands that expand into full prompts. Type `/status` in the TUI and it sends the full instruction:

> Run it: `cagent run examples/6.5-commands.yaml`

```yaml
agents:
  root:
    model: anthropic/claude-sonnet-4-5
    instruction: You are a developer assistant
    commands:
      status: "Show me the git status and recent commits"
      review: "Review the current git diff and suggest improvements"
      test: "Run the tests and fix any failures"
    toolsets:
      - type: shell
      - type: filesystem
```

<div class="nav-bottom">

[<- Step 5: Sharing Agents](step5_sharing_agents.html) | [Step 7: Docker Sandboxes ->](step7_docker_sandboxes.html)

</div>
