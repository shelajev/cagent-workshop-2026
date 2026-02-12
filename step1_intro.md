<div class="nav-top">

[<- Back to Index](index.html)

</div>

# Step 1: Introduction to cagent

## What is cagent?

**cagent** is Docker's open-source framework for building and running AI agents. It lets you define intelligent agents in a simple YAML file -- give them a model, instructions, and tools -- and run them from your terminal.

```
cagent run agent.yaml
```

That's it. No boilerplate code, no SDKs to learn, no framework lock-in.

## Motivation

AI agents are programs that can take actions on your behalf -- they can read and write files, run commands, call APIs, search the web, and reason about complex problems.

But building agents today typically means:

- Writing lots of glue code to connect an LLM to tools
- Managing prompt engineering, tool calling, and error handling
- Dealing with different provider APIs
- Building infrastructure for multi-agent coordination

**cagent eliminates all of that.** You declare what you want in YAML, and cagent handles the orchestration.

## How cagent is Different

| Traditional Agent Frameworks | cagent |
|---|---|
| Write code (Python, JS, etc.) | Declare in YAML |
| Single-provider SDKs | Provider-agnostic (OpenAI, Anthropic, Google, local models) |
| Build your own tool system | Rich ecosystem of builtin tools + MCP |
| Complex multi-agent code | Sub-agents defined declaratively |
| Hard to share | Push/pull agents like Docker images |
| Local-only execution | Run anywhere -- local, containers, sandboxes |

Key differentiators:

- **Declarative**: YAML-first, no application code needed
- **Docker-native**: Comes with Docker Desktop 4.49+, runs MCP servers in containers, shares via OCI registries
- **Multi-agent**: Build teams of specialized agents that delegate to each other
- **Tool-rich**: Builtin tools + any MCP server + custom scripts + APIs
- **Provider-agnostic**: Swap models with one line -- `openai/gpt-4o`, `anthropic/claude-sonnet-4-5`, `dmr/ai/llama3.1` (local!)

## A Quick Taste

Here's the simplest possible agent:

```yaml
agents:
  root:
    model: openai/gpt-4o
    instruction: You are a helpful assistant
```

And here's a multi-agent team with tools and MCP -- still just YAML:

```yaml
agents:
  root:
    model: anthropic/claude-sonnet-4-5
    instruction: You lead a team of specialized agents
    sub_agents: [researcher, coder]

  researcher:
    model: openai/gpt-4o
    description: Researches topics using the web
    instruction: Search the web and summarize findings
    toolsets:
      - type: mcp
        ref: docker:duckduckgo

  coder:
    model: anthropic/claude-sonnet-4-5
    description: Writes and runs code
    instruction: Write clean, tested code
    toolsets:
      - type: filesystem
      - type: shell
```

We'll build up to this step by step. In the next section, we'll create your first agent.

<div class="nav-bottom">

[<- Workshop Overview](README.html) | [Step 2: Your First Agent ->](step2_mini_example.html)

</div>
