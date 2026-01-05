# Quick Start Guide

Get up and running with AnythingLLM and agent blueprints in 10 minutes.

## Prerequisites

- Docker installed (or willingness to install it)
- Mistral API key from [console.mistral.ai](https://console.mistral.ai/)
- 5GB+ free disk space
- Basic command line familiarity

---

## Option 1: Automated Setup (Recommended)

### 1. Run the Setup Script

```bash
# Clone this repository
git clone https://github.com/your-username/anythingllm-agent-setup.git
cd anythingllm-agent-setup

# Run automated setup
./scripts/setup.sh
```

The script will:
- Check system requirements
- Install Docker (if needed)
- Pull and run AnythingLLM
- Clone agent blueprints repository
- Guide you through configuration

### 2. Complete Onboarding

1. Open http://localhost:3001
2. Create admin account
3. Complete the onboarding wizard

### 3. Configure Mistral

1. Go to **Settings** (gear icon)
2. Click **LLM Preference**
3. Select **OpenAI** as provider
4. Enter:
   - Base URL: `https://api.mistral.ai/v1`
   - API Key: `your-mistral-api-key`
   - Model: `mistral-large-latest`
5. Click **Save**

### 4. Try Your First Agent

1. Create a new workspace: **"+ New Workspace"**
2. Name it "My First Agent"
3. Click the **gear icon** next to "My First Agent" (in left sidebar)
4. Click the **Chat Settings** tab (at top of settings)
5. Scroll down to find the **Prompt** field
6. Open `ai-agent-blueprints/agents/core/default-agent.md`
7. Copy the **System Prompt** section
8. Paste into the Prompt field
9. Click **Update workspace** at the bottom
10. Start chatting!

**Example:**
```
You: What is machine learning?

Agent: [Provides clear explanation following the agent blueprint...]
```

---

## Option 2: Manual Setup

### 1. Install AnythingLLM with Docker

```bash
# Pull image
docker pull mintplexlabs/anythingllm

# Create storage directory
mkdir anythingllm-storage

# Run container
docker run -d \
  -p 3001:3001 \
  --name anythingllm \
  -v ${PWD}/anythingllm-storage:/app/server/storage \
  mintplexlabs/anythingllm
```

### 2. Clone Agent Blueprints

```bash
git clone https://github.com/kasjens/ai-agent-blueprints.git
```

### 3. Configure (same as automated setup step 2-4)

---

## Option 3: Docker Compose

### 1. Create .env File

```bash
cp .env.example .env
# Edit .env and add your Mistral API key
```

### 2. Start Services

```bash
docker-compose up -d
```

### 3. Configure (same as automated setup step 2-4)

---

## Testing Your Setup

### Test 1: Simple Conversation

```
You: Hello! Can you tell me about yourself?

Expected: Agent introduces itself based on its role definition
```

### Test 2: Complex Task

```
You: Explain how neural networks work, using an analogy

Expected: Clear explanation with analogy, structured formatting
```

### Test 3: Tool Usage (if web search enabled)

```
You: What are the latest developments in AI? Please search the web.

Expected: Uses web search tool, synthesizes recent information
```

---

## What to Do Next

### Beginner Track (First Hour)

1. ✅ Complete this quick start
2. 📖 Read [Agent Integration Guide](../docs/agent-integration.md)
3. 🎯 Try 3 different agent blueprints:
   - `agents/core/default-agent.md`
   - `agents/core/research-agent.md`
   - Choose any from `agents/domain-specific/`
4. 🛠️ Customize one agent for your use case

### Intermediate Track (First Day)

1. ✅ Complete beginner track
2. 🔧 Create your first custom agent skill
3. 🔀 Build a simple multi-agent workflow
4. 📊 Try the [Research Pipeline Example](../examples/workflows/research-pipeline.md)
5. 🎨 Explore Agent Flows visual builder

### Advanced Track (First Week)

1. ✅ Complete intermediate track
2. 🏗️ Build a complex multi-agent system
3. 🔌 Integrate with your existing tools
4. 📈 Set up monitoring and logging
5. 🚀 Deploy to production

---

## Common First-Time Issues

### "Cannot connect to http://localhost:3001"

**Solution:**
```bash
# Check if container is running
docker ps | grep anythingllm

# Check logs
docker logs anythingllm

# Restart container
docker restart anythingllm
```

### "LLM connection failed"

**Solutions:**
- Verify Mistral API key is correct
- Check base URL: `https://api.mistral.ai/v1`
- Test API key separately:
  ```bash
  curl https://api.mistral.ai/v1/models \
    -H "Authorization: Bearer your-api-key"
  ```

### "Agent not following instructions"

**Solutions:**
- Ensure you copied the ENTIRE system prompt
- Check for copy/paste errors
- Verify template variables are replaced:
  - `{{CURRENT_DATE}}` → actual date
  - `{{TOOLS_LIST}}` → actual tools
- Use `mistral-large-latest` not `mistral-small`

### "Docker command not found"

**Solution:**
```bash
# Install Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh

# Or download Docker Desktop
# https://www.docker.com/products/docker-desktop
```

---

## Quick Reference Commands

```bash
# Start AnythingLLM
docker start anythingllm

# Stop AnythingLLM
docker stop anythingllm

# Restart AnythingLLM
docker restart anythingllm

# View logs
docker logs anythingllm

# View real-time logs
docker logs -f anythingllm

# Check if running
docker ps | grep anythingllm

# Access shell (for debugging)
docker exec -it anythingllm bash

# Backup data
cp -r anythingllm-storage anythingllm-storage-backup

# Update to latest version
docker pull mintplexlabs/anythingllm:latest
docker stop anythingllm
docker rm anythingllm
# Then run the docker run command again
```

---

## Quick Tips

### 💡 Tip 1: Start Simple

Don't try to build complex multi-agent systems immediately. Start with:
1. One workspace
2. One agent blueprint
3. Basic conversation
4. Then gradually add complexity

### 💡 Tip 2: Read the Agent Blueprint

Before using an agent, read its entire blueprint file to understand:
- What it's designed for
- What tools it needs
- How it should behave
- What examples look like

### 💡 Tip 3: Template Variables Matter

Always replace template variables:
```markdown
# Don't leave this:
Current Date: {{CURRENT_DATE}}

# Replace with:
Current Date: January 5, 2025
```

### 💡 Tip 4: Use the Right Model

For best results:
- **mistral-large-latest**: Complex instructions, best quality
- **mistral-medium-latest**: Balanced performance
- **mistral-small-latest**: Simple tasks, fast responses

### 💡 Tip 5: Enable Relevant Tools

Match tools to agent needs:
- Research agent → enable web-search
- Document agent → enable rag-search
- Code agent → enable code-interpreter

---

## Getting Help

1. **Check documentation**: Most questions answered in [docs/](../docs/)
2. **Review examples**: See [examples/](../examples/) for working code
3. **Search issues**: [GitHub Issues](https://github.com/your-username/anythingllm-agent-setup/issues)
4. **Ask community**:
   - [AnythingLLM Discord](https://discord.gg/anythingllm)
   - [Agent Blueprints Issues](https://github.com/kasjens/ai-agent-blueprints/issues)

---

## Next Steps

After completing this quick start:

1. **Read** the [full Agent Integration Guide](../docs/agent-integration.md)
2. **Try** the [Research Pipeline Example](../examples/workflows/research-pipeline.md)
3. **Build** your own custom agent
4. **Share** your experience and improvements

---

**Estimated time to complete**: 10 minutes

**Questions?** Open an issue or check the [README](../README.md)!

Happy agent building! 🚀
