<div class="nav-top">

[<- Back to Index](index.html)

</div>

# Step 7: Docker Sandboxes

When agents have shell access, they can execute arbitrary commands on your machine. That's powerful -- but risky. **Docker sandboxes** solve this by running your agent in an isolated container environment.

## Running cagent in a Sandbox

The simplest way to sandbox an agent:

```bash
docker sandbox run cagent .
```

This runs cagent inside a Docker sandbox with your current directory mounted. The agent can read and modify your project files, but it's isolated from the rest of your system.

## Why Sandboxes?

- **Safety**: The agent can't accidentally delete system files, install malware, or mess with your environment
- **Reproducibility**: The sandbox provides a clean, consistent environment
- **Confidence**: You can let the agent use `shell` freely without worrying about damage

## How It Works

When you run `docker sandbox run cagent .`:

1. Docker creates an isolated container environment
2. Your current directory (`.`) is mounted into the sandbox
3. cagent starts inside the container with full shell access
4. The agent can read/write your project files but nothing else on your system

The last argument is the **workspace directory** to mount (defaults to `.`):

```bash
# Sandbox with current directory
docker sandbox run cagent .

# Sandbox with a specific project directory
docker sandbox run cagent ~/projects/my-app
```

Everything after `--` gets passed as arguments to cagent. This is how you run a specific agent file in a sandbox:

```bash
# Run the default cagent agent in a sandbox
docker sandbox run cagent .

# Run a specific agent YAML in a sandbox
docker sandbox run cagent . -- examples/3.4-developer-agent.yaml

# Continue a previous session
docker sandbox run cagent . -- --continue
```

Since the workspace directory is mounted into the sandbox, cagent can see all your files -- including your agent YAML files.

## Exercise

1. Try running one of the workshop agents in a sandbox:
   ```bash
   docker sandbox run cagent . -- examples/3.4-developer-agent.yaml
   ```
2. Ask it to create files, run commands, and verify they're contained within the sandbox.

<div class="nav-bottom">

[<- Step 6: New Cool Things](step6_new_cool_things.html) | [Thank You! ->](step8_thankyou.html)

</div>
