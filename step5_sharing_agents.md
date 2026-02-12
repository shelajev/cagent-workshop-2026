<div class="nav-top">

[<- Back to Index](index.html)

</div>

# Step 5: Sharing Agents

One of cagent's superpowers is how easy it is to share agents. Agents are packaged as OCI artifacts -- the same format Docker images use -- so you can push them to any container registry.

## Push, Pull, Run

**Push an agent to a registry:**

```bash
cagent push my-agent.yaml your-dockerhub-username/my-agent
```

**Pull an agent:**

```bash
cagent pull your-dockerhub-username/my-agent
```

**Run directly from a registry (no pull needed):**

```bash
cagent run your-dockerhub-username/my-agent
```

That's it. Anyone with access to the registry can run your agent.

## Example: CFP Finder Agent

Here's a real agent we can push and share -- it connects to a remote MCP server for conference CFP data:

> Run it: `cagent run examples/5.1-cfp-finder.yaml`

```yaml
#!/usr/bin/env cagent run

agents:
  root:
    model: anthropic/claude-sonnet-4-5
    description: Agent to help with finding information about conference CFPs
    instruction: |
      You have access to developer.events -- a platform which knows about
      active conference CFPs, their deadlines, and locations.
      Help the user answer their queries.
    add_date: true
    toolsets:
      - type: mcp
        remote:
          transport_type: streamable
          url: https://developer-events-mcp-54127830651.europe-west2.run.app
```

Notice the shebang (`#!/usr/bin/env cagent run`) -- this lets you make the YAML file executable and run it directly:

```bash
chmod +x cfps.yaml
./cfps.yaml
```

## The Agent Catalog

cagent has a built-in agent catalog. You can run community agents directly:

```bash
cagent run agentcatalog/pirate
```

## Exercise: Share Your Agent

1. Take the developer agent you built in previous steps
2. Push it to Docker Hub:
   ```bash
   cagent push examples/3.4-developer-agent.yaml your-username/workshop-developer
   ```
3. Have a colleague pull and run it:
   ```bash
   cagent run your-username/workshop-developer
   ```

---

## Security Considerations

When sharing and running agents, keep in mind:

- **Review before running**: Always look at an agent's YAML before running it from an untrusted source. Agents with `shell` access can execute arbitrary commands.
- **Tool permissions**: cagent supports permission rules to restrict what tools can do:

```yaml
permissions:
  deny:
    - "shell:cmd=rm *"
    - "shell:cmd=sudo *"
    - "shell:cmd=git push --force*"
  allow:
    - "shell:cmd=ls *"
    - "shell:cmd=git status*"
    - "shell:cmd=go test*"
```

- **Sandboxed execution**: Use Docker sandboxes (covered in [Step 7](step7_docker_sandboxes.html)) to run untrusted agents safely.
- **Environment variables**: Be careful with API keys -- don't push agents that embed secrets. Use environment variables at runtime instead.
- **MCP server trust**: Docker MCP servers run in containers, providing isolation. But remote MCP servers can see the data you send them.

<div class="tip">

**Best practice:** Define explicit `permissions` in your agent YAML to lock down what tools are allowed to do, especially for agents you plan to share.

</div>

<div class="nav-bottom">

[<- Step 4: Systems of Agents](step4_systems_of_agents.html) | [Step 6: New Cool Things ->](step6_new_cool_things.html)

</div>
