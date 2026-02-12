<div class="nav-top">

[<- Back to Index](index.html)

</div>

# Building Agents with cagent -- Workshop

> Build, run, and share AI agents with a declarative YAML config, rich tool ecosystem, and multi-agent orchestration.

**cagent** is Docker's open-source framework for creating AI agents. You define agents in YAML -- give them a model, instructions, and tools -- and `cagent` handles the rest. No code required.

In this workshop you will go from zero to building multi-agent systems, connecting to MCP servers, running local models, and sharing agents via Docker registries.

## Prerequisites

- **cagent** installed (see below)
- **Docker Desktop 4.49+** (for MCP and sandbox steps)
- A **Docker Hub** account (for sharing agents)
- At least one **API key** from a supported LLM provider

## Installing cagent

**Docker Desktop** (4.49+) -- cagent comes pre-installed. Just run `cagent` in your terminal.

**Homebrew:**

```
brew install cagent
```

**Binary releases** -- download from [GitHub Releases](https://github.com/docker/cagent/releases).

## API Key Setup

Set at least one of these environment variables:

```bash
export OPENAI_API_KEY=sk-...
export ANTHROPIC_API_KEY=sk-ant-...
export GOOGLE_API_KEY=AI...
```

All keys are optional -- you just need at least one provider configured.

<div class="tip">

**Tip:** If you don't have any API keys, you can use local models via [Docker Model Runner](https://docs.docker.com/ai/model-runner/) with the `dmr/` provider prefix -- no API key needed!

</div>

## What You'll Learn

1. What cagent is and why it's different
2. Creating your first agent with models and instructions
3. Extending agents with builtin tools, MCP servers, and skills
4. Building multi-agent systems with sub-agents
5. Running local AI models with Docker Model Runner
6. Sharing agents through OCI registries
7. Memory, speech-to-text, and other new features
8. Running agents in Docker sandboxes

Let's get started!

<div class="nav-bottom">

[Step 1: Introduction to cagent ->](step1_intro.html)

</div>
