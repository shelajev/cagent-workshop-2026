<div class="nav-top">

[<- Back to Index](index.html)

</div>

# Step 3: Tools -- Builtin, MCP & Skills

An agent without tools is just a chatbot. **Tools** are what make agents useful -- they let agents take actions in the real world.

cagent provides three ways to give agents tools:

1. **Builtin tools** -- ready to use, no setup
2. **MCP servers** -- the Docker MCP Toolkit ecosystem
3. **Skills** -- auto-loading task-specific abilities (new!)

## Builtin Tools

cagent ships with several builtin tools. Add them to your agent's `toolsets`:

### Think

Lets the model pause and reason step-by-step before responding. This improves accuracy on complex tasks like math, logic, and multi-step planning.

> Run it: `cagent run examples/3.1-think.yaml`

```yaml
agents:
  root:
    model: openai/gpt-4o
    instruction: You are a problem solver
    toolsets:
      - type: think
```

### Todo

Task management -- the agent can break complex work into smaller steps and track progress. Essential for any agent doing multi-step tasks.

> Run it: `cagent run examples/3.3-todo.yaml`

```yaml
agents:
  root:
    model: openai/gpt-4o
    instruction: You are a project manager
    toolsets:
      - type: todo
```

### Shell & Filesystem

The power tools -- let your agent run commands and work with files.

> Run it: `cagent run examples/3.4-developer-agent.yaml`

```yaml
agents:
  root:
    model: openai/gpt-4o
    instruction: You are a developer assistant
    add_environment_info: true
    add_date: true
    toolsets:
      - type: shell
      - type: filesystem
      - type: todo
      - type: think
```

<div class="tip">

**Tip:** Combine tools strategically. A developer agent with `shell`, `filesystem`, `todo`, and `think` is a powerful combination -- it can plan work, read code, make changes, and run tests.

</div>

There's also a **memory** tool for persistent recall across sessions -- we'll cover that in depth in [Step 6](step6_new_cool_things.html).

---

## MCP (Model Context Protocol)

MCP is an open standard for connecting AI agents to external tools and services. The **Docker MCP Toolkit** makes it trivially easy to use MCP servers -- they run in containers, so there's nothing to install.

### Docker Toolkit MCP Servers

The simplest way to add MCP tools. Just reference them with `docker:`:

> Run it: `cagent run examples/3.5-mcp-fetch.yaml`

```yaml
agents:
  root:
    model: openai/gpt-4o
    instruction: Summarize URLs for users
    toolsets:
      - type: mcp
        ref: docker:fetch
```

Some popular Docker MCP servers:

| Server | What it does |
|---|---|
| `docker:fetch` | Fetch and parse web content |
| `docker:duckduckgo` | Web search |
| `docker:context7` | Up-to-date library documentation |
| `docker:brave` | Brave web search |
| `docker:github` | GitHub integration |

### Docker MCP Gateway

The MCP Gateway gives your agent access to all MCP servers you've configured in Docker Desktop. Instead of listing them one by one, you get everything at once:

> Run it: `cagent run examples/3.6-mcp-gateway.yaml`

```yaml
agents:
  root:
    model: openai/gpt-4o
    instruction: You are a helpful assistant
    toolsets:
      - type: mcp
        command: docker
        args: ["mcp", "gateway", "run"]
```

### Remote MCP Servers

Connect to any remote MCP server over the network:

> Run it: `cagent run examples/3.7-mcp-remote-cfp.yaml`

```yaml
agents:
  root:
    model: anthropic/claude-sonnet-4-5
    description: Conference CFP finder
    instruction: |
      You have access to developer.events -- a platform which knows about
      active conference CFPs, their deadlines, and locations.
      Help the user find relevant CFPs.
    add_date: true
    toolsets:
      - type: mcp
        remote:
          transport_type: streamable
          url: https://developer-events-mcp-54127830651.europe-west2.run.app
```

### Local MCP Servers (Docker containers)

Run any MCP server packaged as a Docker image. This is great for custom or third-party MCP servers:

> Run it: `cagent run examples/3.8-mcp-docker-container.yaml`

```yaml
agents:
  root:
    model: anthropic/claude-sonnet-4-5
    instruction: You help users with chess. You can analyze positions, explain moves, and play games.
    add_date: true
    toolsets:
      - type: mcp
        command: docker
        args:
          - run
          - -i
          - --rm
          - olegselajev241/mcp-chess
```

The `-i` and `--rm` flags are important: `-i` keeps stdin open for the MCP protocol, and `--rm` cleans up the container when done.

### Exercise: Add MCP to Your Agent

Take your agent from Step 2 and add one of these MCP toolsets:

- `docker:duckduckgo` -- let it search the web
- `docker:fetch` -- let it read web pages
- `docker:context7` -- let it look up library documentation

Try asking it something it couldn't answer before!

---

## Skills (Auto-Loading)

Skills are a newer cagent feature that lets you define reusable, auto-loading capabilities for your agents. Instead of writing detailed instructions in every agent YAML, you place skill definitions in your project and cagent discovers them automatically.

How it works:

1. Create a `.agents/skills/` directory in your project
2. Add subdirectories, each containing a `SKILL.md` file
3. Enable skills on your agent with `skills: true`
4. cagent auto-discovers and loads the skills at runtime

This is great for team-wide conventions -- define skills once in your repo (e.g. "how to run tests", "code review checklist", "deployment process") and every agent picks them up.

<div class="tip">

**Note:** Skills is a very recent addition to cagent. Check the [cagent docs](https://github.com/docker/cagent) for the latest on this feature.

</div>

## What's Next

Now that our agents have tools, let's make them work *together*. In the next step, we'll build systems of agents with sub-agents and local AI.

<div class="nav-bottom">

[<- Step 2: Your First Agent](step2_mini_example.html) | [Step 4: Systems of Agents ->](step4_systems_of_agents.html)

</div>
