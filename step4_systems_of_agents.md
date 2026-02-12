<div class="nav-top">

[<- Back to Index](index.html)

</div>

# Step 4: Systems of Agents & Local AI

Adding tools to a single agent is powerful, but LLMs tend to perform worse when they have too many tools. The solution? **Sub-agents** -- specialized agents that each focus on a specific task.

## Sub-Agents

Define multiple agents in a single YAML file and wire them together with `sub_agents`:

> Run it: `cagent run examples/4.1-pirate-poet-subagents.yaml`

```yaml
agents:
  root:
    model: openai/gpt-4o
    instruction: Answer the user's query. Delegate to specialists when needed.
    sub_agents: [pirate, poet]

  pirate:
    model: openai/gpt-4o
    description: An agent that talks like a pirate
    instruction: Talk like a pirate

  poet:
    model: openai/gpt-4o
    description: An agent that responds in verse
    instruction: Always respond in rhyming poetry
```

<div class="tip">

**Key concept:** Sub-agents **must** have a `description`. The root agent reads the description to decide which sub-agent to delegate to -- it's how it knows who does what.

</div>

### How It Works

1. The user talks to the **root** agent
2. Root reads the `description` of each sub-agent
3. Root decides if a sub-agent can handle the request better
4. Root delegates to the sub-agent
5. The sub-agent does its work and returns the result to root
6. Root presents the answer to the user

### A More Practical Example

Here's a developer team where each agent has different tools:

> Run it: `cagent run examples/4.2-dev-team.yaml`

```yaml
agents:
  root:
    model: anthropic/claude-sonnet-4-5
    instruction: |
      You are a tech lead. Break down tasks and delegate to your team.
      Use the researcher for information gathering and the coder for implementation.
    sub_agents: [researcher, coder]
    toolsets:
      - type: todo
        shared: true
      - type: think

  researcher:
    model: openai/gpt-4o
    description: Researches topics, reads docs, searches the web
    instruction: Find accurate, up-to-date information. Cite your sources.
    toolsets:
      - type: mcp
        ref: docker:duckduckgo
      - type: mcp
        ref: docker:context7
      - type: todo
        shared: true

  coder:
    model: anthropic/claude-sonnet-4-5
    description: Writes, reviews, and tests code
    instruction: Write clean, well-tested code. Run tests after changes.
    toolsets:
      - type: shell
      - type: filesystem
      - type: todo
        shared: true
```

Notice the `shared: true` on the todo tool -- this gives all agents the same task list, so the tech lead can create tasks and the coder/researcher can pick them up. It's how agents coordinate.

---

## Local AI with Docker Model Runner

Not everything needs a cloud API. **Docker Model Runner (DMR)** lets you run LLMs locally -- no API key, no data leaving your machine.

### Enabling Docker Model Runner

DMR needs to be enabled in Docker Desktop:

1. Open **Docker Desktop** -> **Settings** -> **Features in development**
2. Enable **Docker Model Runner**
3. Restart Docker Desktop

See the [Docker Model Runner docs](https://docs.docker.com/ai/model-runner/) for details.

### Using a Local Model

Pull a model first:

```bash
docker model pull ai/llama3.1
```

Then reference it with the `dmr/` prefix:

> Run it: `cagent run examples/4.3-local-model.yaml`

```yaml
agents:
  root:
    model: dmr/ai/llama3.1
    instruction: You are a helpful assistant
```

### The Unslopper Pattern

AI-generated text can sound generic and robotic -- a phenomenon sometimes called "slop." The **unslopper** is a specialized local model fine-tuned to rewrite text to sound more natural and human.

The neat pattern: use a smart cloud model for reasoning and user interaction, but delegate text rewriting to a local model -- keeping that data on your machine:

> Run it: `cagent run examples/4.4-unslopper.yaml`

```yaml
agents:
  root:
    model: anthropic/claude-sonnet-4-5
    instruction: |
      Use the unslopper agent to rewrite text.
      It's a simple agent -- it only ingests text and returns text.
    sub_agents: [unslopper]
    add_date: true

  unslopper:
    model: dmr/hf.co/n8programs/unslopper-gguf:Q8_0
    description: Rewrites text to sound more natural and less AI-generated
    instruction: Rewrite this text
```

<div class="tip">

**Tip:** Pull the unslopper model first: `docker model pull hf.co/n8programs/unslopper-gguf:Q8_0`

</div>

### Docker Model Runner Models

Browse available models on Docker Hub under the `ai/` namespace:

| Model | Pull Command |
|---|---|
| Llama 3.1 | `docker model pull ai/llama3.1` |
| SmolLM2 | `docker model pull ai/smollm2` |
| Mistral | `docker model pull ai/mistral` |

---

## Docker Offload

> **Note:** Docker Offload lets you run agent workloads on remote Docker cloud infrastructure -- no local compute needed. Great for long-running or resource-heavy agents. We won't demo this today, but it's worth knowing about.

## Exercise: Build a Multi-Agent System

Create a YAML file with:

1. A **root** agent that coordinates
2. At least one sub-agent with **cloud** model + tools
3. A sub-agent using a **local** model via DMR (if you have Docker Model Runner set up)

Try giving the root agent a complex task that requires delegation!

<div class="nav-bottom">

[<- Step 3: Tools](step3_tools.html) | [Step 5: Sharing Agents ->](step5_sharing_agents.html)

</div>
