# Agent Integration Guide

Complete guide for using agent blueprints from [ai-agent-blueprints](https://github.com/kasjens/ai-agent-blueprints) with AnythingLLM.

## Overview

Agent blueprints are pre-designed system prompts and configurations that give your AI specific expertise and behaviors. This guide shows you three ways to integrate them with AnythingLLM:

1. **Workspace System Prompts** (Easiest) - For single-agent use
2. **Custom Agent Skills** (Intermediate) - For callable agent functions
3. **Agent Flows** (Advanced) - For visual multi-agent workflows

---

## Method 1: Workspace System Prompts

### When to Use

- Single specialized agent per workspace
- Simple conversational interactions
- Quick setup without coding

### Step-by-Step Integration

#### 1. Clone Agent Blueprints Repository

```bash
cd ~/projects
git clone https://github.com/kasjens/ai-agent-blueprints.git
cd ai-agent-blueprints
```

#### 2. Choose an Agent Blueprint

Browse available agents:

```bash
# General purpose agents
ls agents/core/
# default-agent.md
# research-agent.md
# task-executor.md

# Specialized agents
ls agents/domain-specific/
# code-reviewer.md
# data-analyst.md
# content-writer.md

# Meta-agents
ls agents/meta-agents/
# agent-creator.md
# agent-orchestrator.md
```

#### 3. Extract the System Prompt

Open your chosen blueprint (e.g., `agents/core/default-agent.md`) and locate the **System Prompt** section:

```markdown
## System Prompt

```markdown
# Role and Objective

You are a helpful, knowledgeable, and professional AI assistant...

## Environment

- Current Date: {{CURRENT_DATE}}
- Working Directory: {{WORKING_DIR}}
...
```
```

Copy everything inside the code block.

#### 4. Configure AnythingLLM Workspace

1. **Create a New Workspace**:
   - Click **"+ New Workspace"**
   - Name it based on the agent (e.g., "Code Reviewer")

2. **Open Workspace Settings**:
   - Click the **gear icon** next to your workspace name (in the left sidebar)
   - You'll see 3 tabs at the top: General Settings, Chat Settings, Vector Database
   - Click on the **Chat Settings** tab

3. **Set System Prompt**:
   - Scroll down to find the **Prompt** field (this is your system prompt)
   - Paste the blueprint content
   - Replace template variables:

     ```markdown
     # Original
     Current Date: {{CURRENT_DATE}}
     Working Directory: {{WORKING_DIR}}
     Available Tools: {{TOOLS_LIST}}
     
     # After replacement
     Current Date: January 5, 2025
     Working Directory: /home/user/projects
     Available Tools: web-search, rag-search, web-scraping
     ```

4. **Configure Tools**:
   - In **Agent Configuration**, enable tools mentioned in the blueprint
   - Common tools:
     - `web-search` for research agents
     - `rag-search` for document-based agents
     - `web-scraping` for data extraction
     - `save-file-to-browser` for report generation

5. **Save Settings**

#### 5. Test Your Agent

Start a conversation to verify the agent follows its blueprint:

```
You: [Test message based on agent's purpose]

Example for Code Reviewer:
You: Review this Python function for potential bugs:
def calculate_total(items):
    total = 0
    for item in items:
        total + item['price']
    return total

Agent: [Performs structured code review as defined in blueprint]
```

### Example: Setting Up Research Agent

**1. Copy from blueprint** (`agents/core/research-agent.md`):

```markdown
# Role and Objective

You are a Senior Research Analyst specializing in comprehensive information gathering and analysis. Your objective is to conduct thorough research on any topic, synthesize findings, and present actionable insights.

## Environment

- Current Date: January 5, 2025
- Working Directory: /workspace
- Available Tools: web-search, rag-search
- User Context: Professional researcher

## Core Instructions

### Research Process
1. Understand the research question and scope
2. Identify key search terms and concepts
3. Conduct systematic searches using available tools
4. Cross-reference information from multiple sources
5. Synthesize findings into coherent insights
6. Present results with citations

[... rest of system prompt ...]
```

**2. Configure workspace**:
- Name: "Research Assistant"
- System Prompt: [Paste above]
- Tools: Enable `web-search`
- Model: `mistral-large-latest`
- Temperature: 0.7

**3. Test**:
```
You: Research the current state of AI agent frameworks

Agent: I'll conduct comprehensive research on AI agent frameworks...
[Performs structured research following the blueprint]
```

---

## Method 2: Custom Agent Skills

### When to Use

- Multiple specialized agents in one workspace
- Agent-to-agent communication
- Programmatic agent invocation
- Complex workflows with conditional logic

### Creating an Agent Skill

#### 1. Navigate to Agent Skills

In AnythingLLM:
- Go to **Settings** → **Agent Configuration**
- Click **Agent Skills**
- Click **Create Custom Skill**

#### 2. Use This Template

```javascript
// research-agent-skill.js
module.exports = {
  // Skill metadata
  name: "research_agent",
  description: "Specialized research agent from ai-agent-blueprints/research-agent.md",
  version: "1.0.0",
  author: "Your Name",
  
  // Input parameters
  inputs: [
    {
      name: "topic",
      type: "string",
      required: true,
      description: "Research topic or question"
    },
    {
      name: "depth",
      type: "string",
      required: false,
      default: "comprehensive",
      description: "Research depth: quick, standard, comprehensive"
    }
  ],
  
  // Skill execution
  execute: async function ({ topic, depth = "comprehensive" }) {
    // System prompt from blueprint
    const systemPrompt = `
# Role and Objective

You are a Senior Research Analyst specializing in comprehensive information gathering and analysis.

## Research Instructions

Conduct ${depth} research on the given topic:
1. Identify key search terms
2. Use web-search tool to gather information
3. Cross-reference multiple sources
4. Synthesize findings
5. Present with citations

## Output Format

**Research Topic**: [Topic]

**Key Findings**:
- Finding 1 [Source]
- Finding 2 [Source]

**Analysis**:
[Synthesized insights]

**Recommendations**:
[Actionable recommendations]

**Sources**:
1. [Source 1 URL]
2. [Source 2 URL]
    `;
    
    // Prepare messages
    const messages = [
      {
        role: "system",
        content: systemPrompt
      },
      {
        role: "user",
        content: `Research topic: ${topic}\n\nDepth: ${depth}`
      }
    ];
    
    // Execute with LLM
    try {
      console.log(`[Research Agent] Starting research on: ${topic}`);
      
      const response = await this.llm({ 
        messages,
        temperature: 0.7,
        max_tokens: 4000
      });
      
      console.log(`[Research Agent] Research complete`);
      return response.content;
      
    } catch (error) {
      console.error(`[Research Agent] Error: ${error.message}`);
      return `Error conducting research: ${error.message}`;
    }
  }
};
```

#### 3. Install the Skill

**For Desktop App:**

1. Locate AnythingLLM data directory:
   - Windows: `%APPDATA%/anythingllm/plugins/agent-skills/`
   - macOS: `~/Library/Application Support/anythingllm/plugins/agent-skills/`
   - Linux: `~/.config/anythingllm/plugins/agent-skills/`

2. Create skill directory:
   ```bash
   mkdir -p "path-to-anythingllm/plugins/agent-skills/research-agent"
   ```

3. Save skill as `index.js` in that directory

4. Restart AnythingLLM

**For Docker:**

1. Create `custom-skills` directory:
   ```bash
   mkdir -p ./custom-skills/research-agent
   ```

2. Save skill as `./custom-skills/research-agent/index.js`

3. Mount the directory:
   ```bash
   docker run -d \
     -v ./custom-skills:/app/server/storage/plugins/agent-skills \
     -v ./anythingllm-storage:/app/server/storage \
     -p 3001:3001 \
     mintplexlabs/anythingllm
   ```

4. Restart container

#### 4. Use the Agent Skill

In any workspace:

```
You: @agent research_agent --topic "AI safety alignment" --depth "comprehensive"

Agent: [Executes research agent skill]
**Research Topic**: AI safety alignment

**Key Findings**:
- Research finding 1...
- Research finding 2...
[etc.]
```

### Multi-Agent Skill Example

Create multiple agent skills for complex workflows:

```javascript
// analysis-agent-skill.js
module.exports = {
  name: "analysis_agent",
  description: "Analyzes research findings",
  
  inputs: [
    {
      name: "research_data",
      type: "string",
      required: true,
      description: "Research data to analyze"
    }
  ],
  
  execute: async function ({ research_data }) {
    const systemPrompt = `
You are a Data Analyst specializing in extracting insights from research data.

Analyze the provided research and identify:
1. Key patterns and trends
2. Gaps in information
3. Actionable insights
4. Recommendations
    `;
    
    const messages = [
      { role: "system", content: systemPrompt },
      { role: "user", content: `Analyze this research:\n\n${research_data}` }
    ];
    
    const response = await this.llm({ messages });
    return response.content;
  }
};
```

**Workflow:**
```
You: @agent research_agent --topic "quantum computing"
[Save output as OUTPUT1]

You: @agent analysis_agent --research_data "[OUTPUT1]"
[Get analysis]
```

---

## Method 3: Agent Flows (Visual Workflows)

### When to Use

- Complex multi-step workflows
- Visual process design
- Non-coders building agent systems
- Production deployment

### Creating an Agent Flow

#### 1. Open Agent Flows

In AnythingLLM:
- Go to **Agent Flows** (in main navigation)
- Click **Create New Flow**

#### 2. Design Your Workflow

**Example: Research → Analysis → Report Flow**

**Add Nodes:**

1. **Start Node** (automatically created)

2. **Research Agent Node**:
   - Type: LLM Node
   - Name: "Research Agent"
   - System Prompt: [From research-agent blueprint]
   - Input: `{{ input.topic }}`
   - Tools: web-search enabled

3. **Analysis Agent Node**:
   - Type: LLM Node
   - Name: "Analysis Agent"
   - System Prompt: [From data-analyst blueprint]
   - Input: `{{ research_agent.output }}`
   - Tools: none

4. **Writer Agent Node**:
   - Type: LLM Node
   - Name: "Report Writer"
   - System Prompt: [From content-writer blueprint]
   - Input: `{{ analysis_agent.output }}`
   - Tools: save-file-to-browser

5. **End Node** (automatically created)

**Connect Nodes:**
```
Start → Research Agent → Analysis Agent → Writer Agent → End
```

#### 3. Configure Node System Prompts

For each agent node, click **Configure** and paste the system prompt from the corresponding blueprint:

**Research Agent Node:**
```markdown
# Role and Objective
You are a Senior Research Analyst...
[Complete system prompt from research-agent.md]
```

**Analysis Agent Node:**
```markdown
# Role and Objective
You are a Data Analyst...
[Complete system prompt from data-analyst.md]
```

**Writer Agent Node:**
```markdown
# Role and Objective
You are a Report Writer...
[Complete system prompt from content-writer.md]
```

#### 4. Set Flow Parameters

Define input parameters for the flow:

- `topic` (string, required): Research topic
- `report_format` (string, optional): "markdown" | "pdf" | "html"

#### 5. Test the Flow

1. Click **Test Flow**
2. Provide inputs:
   ```json
   {
     "topic": "AI agent frameworks comparison",
     "report_format": "markdown"
   }
   ```
3. Watch execution through each node
4. Review final output

#### 6. Save and Deploy

- Click **Save Flow**
- Name it (e.g., "Research Report Generator")
- Now available to invoke from any workspace:
  ```
  @flow research_report_generator --topic "quantum computing trends"
  ```

### Advanced: Conditional Flows

Add decision nodes for complex logic:

```
Start 
  → Research Agent
  → [Decision: Is research complete?]
      ├─ Yes → Analysis Agent → Report Writer → End
      └─ No → Additional Research → [Loop back to Decision]
```

**Decision Node Example:**

```javascript
// In decision node
function evaluate(researchOutput) {
  const wordCount = researchOutput.split(' ').length;
  const hasSourcesCitation = researchOutput.includes('Sources:');
  
  if (wordCount >= 500 && hasSourcesCitation) {
    return "complete";  // Go to Analysis
  } else {
    return "incomplete";  // Do more research
  }
}
```

---

## Best Practices

### 1. Agent Blueprint Selection

| Use Case | Recommended Blueprint |
|----------|---------------------|
| General Q&A | `agents/core/default-agent.md` |
| Research tasks | `agents/core/research-agent.md` |
| Code analysis | `agents/domain-specific/code-reviewer.md` |
| Data analysis | `agents/domain-specific/data-analyst.md` |
| Content creation | `agents/domain-specific/content-writer.md` |
| Creating new agents | `agents/meta-agents/agent-creator.md` |

### 2. System Prompt Optimization

**Template Variable Replacement:**

Always replace these variables:
- `{{CURRENT_DATE}}` → Actual date
- `{{WORKING_DIR}}` → Real path
- `{{TOOLS_LIST}}` → Enabled tool names
- `{{USER_CONTEXT}}` → User information

**Tool Configuration:**

Match tools to agent needs:
```markdown
# In blueprint
Required Tools: web-search, rag-search

# In AnythingLLM workspace
Enable: ✅ web-search
Enable: ✅ rag-search
Disable: ❌ sql-agent (not needed)
```

### 3. Testing Checklist

For each integrated agent:

- [ ] System prompt fully copied
- [ ] All template variables replaced
- [ ] Required tools enabled
- [ ] Test with happy path scenario
- [ ] Test with edge case
- [ ] Test with invalid input
- [ ] Verify output format matches blueprint
- [ ] Check error handling

### 4. Version Control

Track your customizations:

```bash
# Save workspace configuration
./scripts/export-workspace.sh "Code Reviewer" > configs/code-reviewer-workspace.json

# Commit to git
git add configs/code-reviewer-workspace.json
git commit -m "Add code reviewer workspace configuration"
```

### 5. Multi-Agent Communication

When chaining agents:

1. **Define clear interfaces**: Each agent outputs structured data
2. **Use JSON for passing data**: Easier to parse between agents
3. **Validate outputs**: Check format before passing to next agent
4. **Handle errors gracefully**: Agent should report failures, not crash

**Example Output Format:**

```json
{
  "agent": "research_agent",
  "status": "success",
  "data": {
    "findings": ["...", "..."],
    "sources": ["...", "..."]
  },
  "metadata": {
    "tokens_used": 1500,
    "execution_time": "3.2s"
  }
}
```

---

## Troubleshooting

### Agent Not Following Instructions

**Symptoms:**
- Responses don't match blueprint behavior
- Agent ignores constraints
- Output format is wrong

**Solutions:**

1. **Verify system prompt completeness**:
   ```bash
   # Check character count
   wc -c < your-system-prompt.txt
   
   # Original blueprint
   wc -c < agents/core/default-agent.md
   
   # Should be similar lengths
   ```

2. **Check for prompt truncation**:
   - AnythingLLM may truncate very long system prompts
   - If >8000 characters, consider simplifying
   - Remove unnecessary examples, keep core instructions

3. **Increase model capability**:
   - Switch from `mistral-small` to `mistral-large-latest`
   - Larger models follow complex instructions better

4. **Add explicit reminders**:
   ```markdown
   ## Final Reminder
   CRITICAL: You MUST follow the output format specified above.
   CRITICAL: Always perform [specific behavior] before responding.
   ```

### Agent Skills Not Loading

**Symptoms:**
- `@agent skill_name` doesn't work
- Skill not listed in agent skills menu

**Solutions:**

1. **Check file location**:
   ```bash
   # Desktop app
   ls ~/Library/Application\ Support/anythingllm/plugins/agent-skills/
   
   # Docker
   docker exec anythingllm ls /app/server/storage/plugins/agent-skills/
   ```

2. **Verify file structure**:
   ```
   agent-skills/
   └── my-skill/
       └── index.js  ← Must be named "index.js"
   ```

3. **Check JavaScript syntax**:
   ```bash
   node index.js  # Should not throw errors
   ```

4. **Review logs**:
   - In AnythingLLM: Settings → System → View Logs
   - Look for skill loading errors

5. **Restart AnythingLLM**:
   - Desktop: Quit and restart
   - Docker: `docker restart anythingllm`

### Agent Flow Execution Failures

**Symptoms:**
- Flow stops mid-execution
- Nodes show error status
- No output generated

**Solutions:**

1. **Check node connections**:
   - Ensure all nodes properly connected
   - Verify data is passed between nodes: `{{ previous_node.output }}`

2. **Validate input/output format**:
   - Each node expects specific input format
   - Use transformation nodes if needed

3. **Test nodes individually**:
   - Run each node separately
   - Verify output before connecting to next node

4. **Check tool availability**:
   - If node uses tools, ensure they're enabled workspace-wide

5. **Review execution logs**:
   - Flow execution panel shows each step
   - Look for error messages in red

---

## Next Steps

- **Create your first workspace**: [Quick Start Guide](../guides/quick-start.md)
- **Build a multi-agent flow**: [Agent Flows Guide](../guides/agent-flows.md)
- **Explore examples**: [Examples Directory](../examples/)
- **Join community**: [AnythingLLM Discord](https://discord.gg/anythingllm)

---

**Need help?** Open an issue in the [agent-blueprints repository](https://github.com/kasjens/ai-agent-blueprints/issues).
