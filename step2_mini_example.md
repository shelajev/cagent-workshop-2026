<div class="nav-top">

[<- Back to Index](index.html)

</div>

# Step 2: Your First Agent

Let's create your first agent and understand the two fundamental building blocks: **models** and **instructions**.

## The Simplest Agent

> Run it: `cagent run examples/2.1-pirate-hello.yaml`

```yaml
agents:
  root:
    model: openai/gpt-4o
    instruction: You talk like a pirate
```

You should see the cagent TUI (terminal UI). Type a message and your agent will respond in pirate speak!

## Models

The `model` field tells cagent which LLM to use. The format is `provider/model-name`:

| Provider | Example | API Key |
|---|---|---|
| OpenAI | `openai/gpt-4o` | `OPENAI_API_KEY` |
| Anthropic | `anthropic/claude-sonnet-4-5` | `ANTHROPIC_API_KEY` |
| Google | `google/gemini-2.5-flash` | `GOOGLE_API_KEY` |
| Docker Model Runner | `dmr/ai/llama3.1` | None (local!) |

<div class="tip">

**Tip:** Don't have an API key? Use Docker Model Runner for local models -- no key required!

</div>

### Named Models

For larger configs with multiple agents, define models once and reference them by name:

> Run it: `cagent run examples/2.2-named-models.yaml`

```yaml
models:
  smart:
    provider: anthropic
    model: claude-sonnet-4-5
  fast:
    provider: openai
    model: gpt-4o-mini

agents:
  root:
    model: smart
    instruction: You are a helpful assistant
    sub_agents: [quick]

  quick:
    model: fast
    description: A fast responder for simple questions
    instruction: Answer briefly and concisely
```

Here `smart` and `fast` are aliases -- each agent picks the model that fits its role.

## Instructions

The `instruction` field is the system prompt -- it tells the agent who it is and how to behave.

Simple one-liner:

```yaml
instruction: You are a helpful assistant that speaks concisely.
```

Multi-line with YAML's `|` syntax:

```yaml
instruction: |
  You are a knowledgeable assistant that helps users with various tasks.
  Always be helpful, accurate, and concise in your responses.
  When you don't know something, say so rather than guessing.
```

### Enriching Context

cagent can automatically inject useful context into the agent's prompt:

> Run it: `cagent run examples/2.3-context-enrichment.yaml`

```yaml
agents:
  root:
    model: openai/gpt-4o
    instruction: You are a developer assistant
    add_date: true               # Injects current date
    add_environment_info: true   # Injects OS, working directory, git status
```

This is especially useful for developer agents that need to know about the current project.

## Exercise: Build Your Own

Create an agent that:

1. Uses whatever model provider you have access to
2. Has a custom personality (a chef, a detective, a poet -- your choice!)
3. Includes `add_date: true` so it knows what day it is

Run it and have a conversation!

## What's Next

Our agent can talk, but it can't *do* anything yet. In the next step, we'll give it superpowers with **tools**.

<div class="nav-bottom">

[<- Step 1: Introduction](step1_intro.html) | [Step 3: Tools ->](step3_tools.html)

</div>
