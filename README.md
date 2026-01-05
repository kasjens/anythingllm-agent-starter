# AnythingLLM Agent Setup Guide

Complete setup and integration guide for running AI agent workflows locally using [AnythingLLM](https://anythingllm.com/) with agent blueprints from [ai-agent-blueprints](https://github.com/kasjens/ai-agent-blueprints).

## 🎯 What This Repository Provides

- **Installation Guide**: Step-by-step AnythingLLM setup (Docker, Desktop, Source)
- **Agent Integration**: How to use agent blueprints from ai-agent-blueprints
- **Mistral Configuration**: Setting up Mistral Le Chat API
- **Workflow Examples**: Single and multi-agent workflow templates
- **Custom Skills**: Building custom agent skills for AnythingLLM
- **Production Tips**: Best practices for local deployment

## 🚀 Quick Start (5 Minutes)

### 1. Install AnythingLLM

**Option A: Docker (Recommended)**
```bash
docker pull mintplexlabs/anythingllm
docker run -d -p 3001:3001 \
  --name anythingllm \
  -v ${PWD}/anythingllm-storage:/app/server/storage \
  mintplexlabs/anythingllm
```

**Option B: Desktop App**
- Download from [useanything.com](https://useanything.com/)
- Install for your platform (Windows, macOS, Linux)
- Launch the application

### 2. Initial Configuration

1. Open `http://localhost:3001` (or launch desktop app)
2. Complete the onboarding wizard
3. Configure your LLM provider (see [Mistral Setup](#mistral-setup))

### 3. Import Agent Blueprints

Clone the agent blueprints repository:
```bash
git clone https://github.com/kasjens/ai-agent-blueprints.git
```

See [Agent Integration Guide](#agent-integration) for usage instructions.

## 📋 Table of Contents

1. [Installation](#installation)
2. [Mistral Setup](#mistral-setup)
3. [Agent Integration](#agent-integration)
4. [Creating Workflows](#creating-workflows)
5. [Custom Skills](#custom-skills)
6. [Examples](#examples)
7. [Troubleshooting](#troubleshooting)

---

## Installation

### Docker Installation (Recommended)

**Why Docker?**
- Consistent environment across all platforms
- Easy updates and rollbacks
- Isolated from system dependencies
- Full MCP (Model Context Protocol) support

**Step-by-Step:**

```bash
# 1. Pull the latest image
docker pull mintplexlabs/anythingllm

# 2. Create storage directory
mkdir anythingllm-storage

# 3. Run container
docker run -d \
  -p 3001:3001 \
  --name anythingllm \
  -v ${PWD}/anythingllm-storage:/app/server/storage \
  -e STORAGE_DIR="/app/server/storage" \
  mintplexlabs/anythingllm

# 4. Verify installation
docker ps | grep anythingllm
```

**Access**: Open `http://localhost:3001` in your browser

**Docker Compose (Alternative):**

```yaml
# docker-compose.yml
version: '3.8'

services:
  anythingllm:
    image: mintplexlabs/anythingllm
    container_name: anythingllm
    ports:
      - "3001:3001"
    volumes:
      - ./anythingllm-storage:/app/server/storage
    environment:
      - STORAGE_DIR=/app/server/storage
      - SERVER_PORT=3001
    restart: unless-stopped
```

```bash
docker-compose up -d
```

### Desktop Installation

**Advantages:**
- Native OS integration
- Better performance for local models
- Direct file system access
- Simpler for non-technical users

**Download & Install:**

1. Visit [useanything.com](https://useanything.com/)
2. Download for your platform:
   - **Windows**: `AnythingLLM-Setup.exe`
   - **macOS**: `AnythingLLM.dmg` (Apple Silicon and Intel)
   - **Linux**: `AnythingLLM.AppImage`

3. Install and launch

**First Launch:**
- Creates local storage in:
  - Windows: `%APPDATA%/anythingllm`
  - macOS: `~/Library/Application Support/anythingllm`
  - Linux: `~/.config/anythingllm`

### Cloud Deployment (Optional)

For cloud deployment on Railway, Render, or similar platforms, see [docs/cloud-deployment.md](docs/cloud-deployment.md).

---

## Mistral Setup

AnythingLLM supports Mistral Le Chat API through its OpenAI-compatible endpoint configuration.

### Step 1: Get Mistral API Key

1. Go to [console.mistral.ai](https://console.mistral.ai/)
2. Sign up or log in
3. Navigate to "API Keys"
4. Create a new API key
5. Copy the key (starts with `mistral-`)

### Step 2: Configure in AnythingLLM

**Via Web Interface:**

1. Click **Settings** (gear icon)
2. Go to **LLM Preference**
3. Select **OpenAI** as the provider
4. Enter configuration:

```
Provider: OpenAI
Base URL: https://api.mistral.ai/v1
API Key: your-mistral-api-key-here
Model: mistral-large-latest
```

**Available Mistral Models:**
- `mistral-large-latest` - Most capable (recommended)
- `mistral-medium-latest` - Balanced performance
- `mistral-small-latest` - Fast and cost-efficient
- `codestral-latest` - Code generation specialist
- `open-mistral-nemo` - Open-source option

### Step 3: Test Connection

1. Create a new workspace
2. Send a test message: "Hello, are you working?"
3. Verify response from Mistral

**Troubleshooting:**
- Check API key is correct
- Verify base URL: `https://api.mistral.ai/v1`
- Ensure you have credits/billing enabled at Mistral

---

## Agent Integration

This section shows how to use agent blueprints from [ai-agent-blueprints](https://github.com/kasjens/ai-agent-blueprints) with AnythingLLM.

### Method 1: System Prompt Configuration

**For Single Agents (Easiest):**

1. Clone the blueprints repo:
   ```bash
   git clone https://github.com/kasjens/ai-agent-blueprints.git
   ```

2. Open any blueprint (e.g., `agents/core/default-agent.md`)

3. Copy the **System Prompt** section

4. In AnythingLLM:
   - Go to **Workspace Settings** → **Chat Settings**
   - Paste the system prompt in **System Prompt** field
   - Replace template variables:
     - `{{CURRENT_DATE}}` → Current date
     - `{{WORKING_DIR}}` → Your working directory
     - `{{TOOLS_LIST}}` → Available AnythingLLM tools

5. Save and start chatting with your configured agent

**Example:**

```markdown
# System Prompt for Default Agent in AnythingLLM

You are a helpful, knowledgeable, and professional AI assistant...

## Environment
- Current Date: January 5, 2025
- Working Directory: /workspace
- Available Tools: web-browsing, rag-search, web-scraping
- User Context: Technical user working on AI projects

[Rest of system prompt from blueprint...]
```

### Method 2: Agent Skills (Advanced)

**For Multi-Agent Workflows:**

AnythingLLM's Agent Skills system allows you to create specialized agents as callable functions.

**Create a Custom Agent Skill:**

1. In AnythingLLM, go to **Settings** → **Agent Configuration** → **Agent Skills**

2. Click **Create Custom Skill**

3. Use this template structure:

```javascript
module.exports = {
  name: "research_agent",
  description: "Specialized research agent from ai-agent-blueprints",
  
  // Input schema
  inputs: [
    {
      name: "research_topic",
      type: "string",
      required: true,
      description: "Topic to research"
    }
  ],
  
  // Agent execution
  execute: async function (topic) {
    // Load agent blueprint system prompt
    const systemPrompt = `
      You are a Senior Research Analyst specializing in...
      [Paste from agent blueprint]
    `;
    
    // Call LLM with agent personality
    const response = await this.llm({
      messages: [
        { role: "system", content: systemPrompt },
        { role: "user", content: `Research: ${topic}` }
      ]
    });
    
    return response;
  }
};
```

4. Save and use with `@agent research_agent` in chat

### Method 3: Agent Flows (Visual Workflows)

**For Complex Multi-Step Processes:**

1. Go to **Agent Flows** in AnythingLLM

2. Click **Create New Flow**

3. Build your workflow using nodes:

```
[Start] → [Research Agent] → [Analysis Agent] → [Writer Agent] → [End]
```

4. Configure each node with the appropriate agent system prompt from your blueprints

See [guides/agent-flows.md](guides/agent-flows.md) for detailed instructions.

---

## Creating Workflows

### Single-Agent Workflow

**Use Case**: Simple task execution with one specialized agent

**Setup:**
1. Choose appropriate blueprint from `ai-agent-blueprints/agents/`
2. Configure workspace with agent's system prompt
3. Add required tools (web search, RAG, etc.)

**Example: Code Review Agent**

```markdown
Workspace: code-reviewer
System Prompt: [From agents/domain-specific/code-reviewer.md]
Tools: rag-search (for documentation), web-browsing
```

Chat example:
```
You: @agent review this Python code for security issues
[paste code]

Agent: [Performs structured code review per blueprint instructions]
```

### Multi-Agent Workflow

**Use Case**: Complex tasks requiring multiple specialized agents

**Example: Research → Analysis → Report**

**Setup with Agent Flows:**

1. Create Flow: "Research Report Generator"

2. Add Nodes:
   ```
   Node 1: Research Agent
   - Blueprint: agents/core/research-agent.md
   - Tool: web-search
   - Output: research findings
   
   Node 2: Analysis Agent
   - Blueprint: agents/domain-specific/data-analyst.md
   - Input: research findings
   - Output: analyzed insights
   
   Node 3: Writer Agent
   - Blueprint: agents/domain-specific/content-writer.md
   - Input: analyzed insights
   - Output: final report
   ```

3. Connect nodes sequentially

4. Test the workflow

**Alternative: Agent Skills Approach**

```javascript
// In workspace, invoke multiple agents
@agent research_agent "AI trends in 2025"
// Wait for output, then:
@agent analysis_agent "Analyze these findings..."
// Then:
@agent writer_agent "Create a report from this analysis..."
```

See [examples/multi-agent/](examples/multi-agent/) for complete implementations.

---

## Custom Skills

Custom skills extend AnythingLLM's capabilities. Here's how to create skills that work with your agent blueprints.

### Skill Template for Agent Blueprints

```javascript
// agent-skill-template.js
module.exports = {
  name: "blueprint_agent",
  description: "Agent from ai-agent-blueprints repository",
  version: "1.0.0",
  
  inputs: [
    {
      name: "task",
      type: "string",
      required: true,
      description: "Task for the agent to perform"
    },
    {
      name: "context",
      type: "string",
      required: false,
      description: "Additional context"
    }
  ],
  
  execute: async function ({ task, context = "" }) {
    // Load agent system prompt from blueprint
    const agentSystemPrompt = this.loadBlueprintPrompt("default-agent");
    
    // Prepare the full prompt
    const messages = [
      {
        role: "system",
        content: agentSystemPrompt
      },
      {
        role: "user",
        content: context ? `Context: ${context}\n\nTask: ${task}` : task
      }
    ];
    
    // Execute with configured LLM
    try {
      const response = await this.llm({ messages });
      return response.content;
    } catch (error) {
      return `Error: ${error.message}`;
    }
  },
  
  // Helper to load blueprint prompts
  loadBlueprintPrompt: function(agentName) {
    // In production, load from file system or embed
    // For now, return placeholder
    return "Your agent system prompt here";
  }
};
```

### Installing Custom Skills

**Desktop Version:**
1. Navigate to `.anythingllm/plugins/agent-skills/`
2. Create a folder for your skill
3. Add `index.js` with your skill code
4. Restart AnythingLLM

**Docker Version:**
1. Mount skills directory:
   ```bash
   docker run -v ./custom-skills:/app/server/storage/plugins/agent-skills
   ```
2. Add your skill files to `./custom-skills/`
3. Restart container

See [guides/custom-skills.md](guides/custom-skills.md) for advanced examples.

---

## Examples

### Example 1: Research Assistant

Uses `agents/core/research-agent.md` blueprint

**Workspace Setup:**
```yaml
Name: Research Assistant
System Prompt: [From research-agent.md]
Tools:
  - web-search: enabled
  - rag-search: enabled
Model: mistral-large-latest
Temperature: 0.7
```

**Usage:**
```
You: Research the latest developments in quantum computing

Agent: I'll conduct comprehensive research on quantum computing...
[Performs structured research per blueprint]

Output:
## Quantum Computing Developments 2024-2025
[Organized findings with sources]
```

### Example 2: Multi-Agent Research Pipeline

See [examples/workflows/research-pipeline.md](examples/workflows/research-pipeline.md)

### Example 3: Code Review Workflow

See [examples/workflows/code-review.md](examples/workflows/code-review.md)

---

## Troubleshooting

### Common Issues

**Problem: "Cannot connect to LLM"**

**Solutions:**
- Check Mistral API key is valid
- Verify base URL: `https://api.mistral.ai/v1`
- Test API key with curl:
  ```bash
  curl https://api.mistral.ai/v1/models \
    -H "Authorization: Bearer your-api-key"
  ```

**Problem: "Agent not following blueprint instructions"**

**Solutions:**
- Verify system prompt was copied completely
- Check for template variables that need replacement
- Increase model temperature for more creative responses
- Use `mistral-large-latest` for best instruction-following

**Problem: "Docker container won't start"**

**Solutions:**
- Check port 3001 is not in use: `lsof -i :3001`
- Verify storage directory permissions
- Check logs: `docker logs anythingllm`

**Problem: "Custom skills not loading"**

**Solutions:**
- Verify file permissions on skill directory
- Check skill syntax with `node index.js`
- Restart AnythingLLM after adding skills
- Review logs in AnythingLLM settings

### Getting Help

- **AnythingLLM Discord**: [discord.gg/anythingllm](https://discord.gg/anythingllm)
- **GitHub Issues**: [github.com/Mintplex-Labs/anything-llm](https://github.com/Mintplex-Labs/anything-llm)
- **Documentation**: [docs.anythingllm.com](https://docs.anythingllm.com/)

For agent blueprint issues: [github.com/kasjens/ai-agent-blueprints/issues](https://github.com/kasjens/ai-agent-blueprints/issues)

---

## Repository Structure

```
anythingllm-agent-setup/
├── README.md                          # This file
├── docs/
│   ├── installation.md                # Detailed installation guide
│   ├── mistral-configuration.md       # Mistral setup and tips
│   ├── agent-integration.md           # Blueprint integration guide
│   ├── custom-skills.md               # Building custom skills
│   └── cloud-deployment.md            # Cloud hosting options
├── guides/
│   ├── quick-start.md                 # 10-minute getting started
│   ├── agent-flows.md                 # Visual workflow builder
│   ├── multi-agent-patterns.md        # Multi-agent design patterns
│   └── production-tips.md             # Best practices
├── examples/
│   ├── single-agent/
│   │   ├── research-assistant.md
│   │   ├── code-reviewer.md
│   │   └── content-writer.md
│   ├── multi-agent/
│   │   ├── research-pipeline.md
│   │   └── document-analysis.md
│   └── workflows/
│       ├── research-report-flow.json
│       └── code-review-flow.json
├── configs/
│   ├── docker-compose.yml             # Docker composition
│   ├── workspace-templates/           # Pre-configured workspaces
│   └── agent-skills/                  # Custom skill examples
└── scripts/
    ├── setup.sh                       # Automated setup script
    ├── import-blueprints.sh           # Import agent blueprints
    └── backup.sh                      # Backup configuration
```

---

## Next Steps

1. **Complete Installation**: Follow the [Installation](#installation) section
2. **Configure Mistral**: Set up your API key using [Mistral Setup](#mistral-setup)
3. **Try an Example**: Start with [Example 1: Research Assistant](#example-1-research-assistant)
4. **Build a Workflow**: Create your first multi-agent workflow
5. **Customize**: Adapt agent blueprints for your specific use cases

## Contributing

Improvements and additional examples welcome! Please see [CONTRIBUTING.md](CONTRIBUTING.md).

## License

MIT License - see [LICENSE](LICENSE)

## Acknowledgments

- **AnythingLLM**: [Mintplex Labs](https://github.com/Mintplex-Labs/anything-llm)
- **Agent Blueprints**: [kasjens/ai-agent-blueprints](https://github.com/kasjens/ai-agent-blueprints)
- **Mistral AI**: [mistral.ai](https://mistral.ai/)

---

**Questions?** Open an issue or check the [docs/](docs/) directory for detailed guides.
