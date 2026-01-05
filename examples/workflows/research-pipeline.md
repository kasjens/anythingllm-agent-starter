# Multi-Agent Research Pipeline

A complete example of a multi-agent workflow that researches a topic, analyzes findings, and generates a comprehensive report.

## Overview

This workflow chains three specialized agents from the [ai-agent-blueprints](https://github.com/kasjens/ai-agent-blueprints) repository:

1. **Research Agent**: Gathers information on a topic
2. **Analysis Agent**: Analyzes and synthesizes findings  
3. **Writer Agent**: Creates a structured report

**Estimated Time**: 5-10 minutes per research topic

**Cost**: ~$0.20-0.50 per complete pipeline (using Mistral)

---

## Prerequisites

- AnythingLLM installed and running
- Mistral API configured
- Agent blueprints repository cloned
- Web search tool enabled

---

## Implementation Methods

### Method 1: Agent Flow (Recommended)

**Visual, no-code workflow builder**

#### Step 1: Create Agent Flow

1. In AnythingLLM, go to **Agent Flows**
2. Click **Create New Flow**
3. Name it "Research Pipeline"

#### Step 2: Add Nodes

**Node 1: Research Agent**

```markdown
Name: Research Agent
Type: LLM Node
System Prompt:

# Role and Objective

You are a Senior Research Analyst specializing in comprehensive information gathering. Your objective is to conduct thorough research using web search and synthesize findings.

## Environment
- Current Date: January 5, 2025
- Available Tools: web-search
- Output Format: Structured research report

## Core Instructions

### Research Process
1. Break down the research topic into key search queries
2. Execute web searches using the web-search tool
3. Collect information from multiple authoritative sources
4. Cross-reference facts across sources
5. Organize findings by theme/category
6. Include source URLs for all claims

### Output Format

**Research Topic**: {{topic}}

**Key Findings**:
1. [Finding 1] - [Source URL]
2. [Finding 2] - [Source URL]
3. [Finding 3] - [Source URL]

**Themes Identified**:
- Theme 1: [Description]
- Theme 2: [Description]

**Notable Sources**:
- [Source 1 Name and URL]
- [Source 2 Name and URL]

**Raw Data**: [All collected information for further analysis]
```

**Configuration**:
- Input: `{{ input.topic }}`
- Tools: ✅ web-search
- Temperature: 0.7
- Max Tokens: 4000

---

**Node 2: Analysis Agent**

```markdown
Name: Analysis Agent
Type: LLM Node
System Prompt:

# Role and Objective

You are a Data Analyst specializing in extracting insights from research data. Your objective is to analyze research findings, identify patterns, and generate actionable insights.

## Environment
- Input: Research findings from previous agent
- Output Format: Structured analysis

## Core Instructions

### Analysis Process
1. Review all research findings
2. Identify patterns, trends, and relationships
3. Assess credibility of sources
4. Highlight contradictions or gaps
5. Generate insights and implications
6. Formulate recommendations

### Output Format

**Analysis Summary**:

**Key Patterns**:
1. [Pattern 1]: [Evidence]
2. [Pattern 2]: [Evidence]

**Insights**:
- [Insight 1]: [Explanation and significance]
- [Insight 2]: [Explanation and significance]

**Data Quality Assessment**:
- Source reliability: [Assessment]
- Information gaps: [List any missing information]
- Confidence level: [High/Medium/Low with reasoning]

**Recommendations**:
1. [Recommendation 1] based on [Finding X]
2. [Recommendation 2] based on [Finding Y]

**Next Steps**:
- [Suggested follow-up action 1]
- [Suggested follow-up action 2]
```

**Configuration**:
- Input: `{{ research_agent.output }}`
- Tools: None
- Temperature: 0.5
- Max Tokens: 3000

---

**Node 3: Writer Agent**

```markdown
Name: Report Writer
Type: LLM Node
System Prompt:

# Role and Objective

You are a Professional Report Writer specializing in creating clear, comprehensive reports from research and analysis data. Your objective is to transform complex information into accessible, well-structured documents.

## Environment
- Input: Research and analysis from previous agents
- Output Format: Markdown report

## Core Instructions

### Report Structure
Create a report with these sections:
1. Executive Summary (3-5 key points)
2. Background/Context
3. Key Findings (organized by theme)
4. Analysis and Insights
5. Recommendations
6. Methodology (how research was conducted)
7. Sources/References

### Writing Guidelines
- Use clear, professional language
- Include subheadings for scannability
- Use bullet points for lists
- Include quotes or statistics from sources
- Maintain objective tone
- Provide context for technical terms

### Output Format

# Research Report: {{topic}}

*Generated on {{date}}*

---

## Executive Summary

[3-5 bullet points highlighting the most critical findings and recommendations]

---

## Background

[Context and scope of the research]

---

## Key Findings

### [Theme 1]
[Detailed findings with evidence]

### [Theme 2]
[Detailed findings with evidence]

---

## Analysis and Insights

[Synthesized insights from the analysis]

---

## Recommendations

1. [Recommendation with supporting evidence]
2. [Recommendation with supporting evidence]

---

## Methodology

[How the research was conducted, tools used, date ranges]

---

## Sources

1. [Source 1 with URL]
2. [Source 2 with URL]
```

**Configuration**:
- Input: `{{ analysis_agent.output }}`
- Tools: ✅ save-file-to-browser
- Temperature: 0.7
- Max Tokens: 5000

#### Step 3: Connect Nodes

```
Start 
  → Research Agent 
  → Analysis Agent 
  → Writer Agent 
  → End
```

#### Step 4: Define Flow Parameters

In Flow Settings:

```json
{
  "parameters": {
    "topic": {
      "type": "string",
      "required": true,
      "description": "Research topic to investigate"
    },
    "depth": {
      "type": "string",
      "required": false,
      "default": "comprehensive",
      "enum": ["quick", "standard", "comprehensive"]
    }
  }
}
```

#### Step 5: Test the Flow

```
Invoke with:
@flow research_pipeline --topic "AI agent orchestration frameworks" --depth "comprehensive"

Expected output:
[Complete markdown report saved to browser downloads]
```

---

### Method 2: Sequential Agent Skills

**For more control and customization**

#### Step 1: Create Agent Skills

Create three separate skill files (see [Agent Integration Guide](../docs/agent-integration.md) for detailed skill creation):

- `research-agent.js`
- `analysis-agent.js`
- `writer-agent.js`

#### Step 2: Execute Pipeline Manually

In any workspace:

```
You: @agent research_agent --topic "quantum computing applications"
[Wait for research to complete, copy output]

You: @agent analysis_agent --data "[paste research output]"
[Wait for analysis to complete, copy output]

You: @agent writer_agent --research "[research output]" --analysis "[analysis output]"
[Get final report]
```

#### Step 3: Automate with Wrapper Skill

Create a pipeline orchestrator:

```javascript
// research-pipeline-skill.js
module.exports = {
  name: "research_pipeline",
  description: "Complete research pipeline: research → analysis → report",
  
  inputs: [
    {
      name: "topic",
      type: "string",
      required: true
    },
    {
      name: "depth",
      type: "string",
      required: false,
      default: "comprehensive"
    }
  ],
  
  execute: async function ({ topic, depth = "comprehensive" }) {
    console.log(`[Pipeline] Starting research pipeline for: ${topic}`);
    
    // Step 1: Research
    console.log(`[Pipeline] Step 1: Research phase`);
    const researchResult = await this.invokeSkill("research_agent", {
      topic: topic,
      depth: depth
    });
    
    if (!researchResult) {
      return "Error: Research phase failed";
    }
    
    // Step 2: Analysis
    console.log(`[Pipeline] Step 2: Analysis phase`);
    const analysisResult = await this.invokeSkill("analysis_agent", {
      research_data: researchResult
    });
    
    if (!analysisResult) {
      return "Error: Analysis phase failed";
    }
    
    // Step 3: Report Writing
    console.log(`[Pipeline] Step 3: Report writing phase`);
    const reportResult = await this.invokeSkill("writer_agent", {
      research: researchResult,
      analysis: analysisResult,
      topic: topic
    });
    
    console.log(`[Pipeline] Pipeline complete`);
    return reportResult;
  }
};
```

**Usage:**
```
@agent research_pipeline --topic "AI safety" --depth "comprehensive"
```

---

## Example Output

### Research Agent Output

```markdown
**Research Topic**: AI Agent Orchestration Frameworks

**Key Findings**:
1. CrewAI leads in multi-agent prototyping with 30,500+ GitHub stars and role-based architecture - https://github.com/crewai/crewai
2. LangGraph provides graph-based orchestration with 4.2M+ monthly downloads, best for complex stateful workflows - https://langchain.com/langgraph
3. Microsoft's AutoGen specializes in conversational multi-agent systems with actor model - https://microsoft.github.io/autogen/

**Themes Identified**:
- Role-based vs Graph-based architectures
- OpenAI API compatibility
- Production deployment patterns
- Memory and state management

**Notable Sources**:
- CrewAI Documentation - https://docs.crewai.com/
- LangChain Blog - https://blog.langchain.dev/
- Microsoft Research - https://www.microsoft.com/en-us/research/

**Raw Data**: [Detailed information from each source...]
```

### Analysis Agent Output

```markdown
**Analysis Summary**:

The AI agent orchestration landscape has consolidated around three primary frameworks in 2024-2025, each optimized for different use cases.

**Key Patterns**:
1. **Architectural Divergence**: Role-based systems (CrewAI) optimize for team dynamics; graph-based systems (LangGraph) optimize for complex control flow
2. **Unified API Standards**: All major frameworks now support OpenAI-compatible APIs, enabling provider flexibility

**Insights**:
- **Rapid Adoption**: CrewAI's growth from 0 to 30K+ stars in 18 months indicates strong developer demand for intuitive multi-agent tools
- **Enterprise Validation**: Production deployments at BMW, AWS (CrewAI) and Klarna, Replit (LangGraph) validate production-readiness
- **Framework Consolidation**: Microsoft merging AutoGen + Semantic Kernel signals industry maturation

**Data Quality Assessment**:
- Source reliability: High (official documentation, peer-reviewed sources)
- Information gaps: Limited data on comparative performance benchmarks
- Confidence level: High - information cross-referenced across 5+ authoritative sources

**Recommendations**:
1. Choose CrewAI for rapid multi-agent prototyping and team-based workflows
2. Choose LangGraph for complex stateful applications requiring cycles and branching
3. Implement provider abstraction (e.g., LiteLLM) for flexibility across Mistral, OpenAI, Claude

**Next Steps**:
- Benchmark frameworks on specific use case
- Review enterprise case studies for production patterns
- Test integration with existing infrastructure
```

### Writer Agent Output

```markdown
# Research Report: AI Agent Orchestration Frameworks

*Generated on January 5, 2025*

---

## Executive Summary

- Three frameworks dominate the AI agent orchestration space in 2025: CrewAI (role-based), LangGraph (graph-based), and AutoGen (conversational)
- All major frameworks now support OpenAI-compatible APIs, enabling seamless integration with Mistral, Claude, and other providers
- Enterprise adoption validates production-readiness, with deployments at BMW, AWS, Klarna, and Replit
- Framework choice should be driven by use case: CrewAI for team dynamics, LangGraph for complex workflows, AutoGen for conversational systems
- Provider abstraction layers like LiteLLM are emerging as best practice for multi-LLM flexibility

---

## Background

AI agent orchestration frameworks enable developers to build systems where multiple specialized AI agents collaborate to solve complex problems. The landscape has evolved rapidly from experimental tools in 2023 to production-ready platforms in 2024-2025.

This research examines the current state of AI agent frameworks, their architectural approaches, and practical deployment patterns based on official documentation and enterprise case studies.

---

## Key Findings

### Framework Landscape

**CrewAI** leads in developer adoption with 30,500+ GitHub stars and 1M+ monthly PyPI downloads. Its role-based architecture maps naturally to team structures: agents have roles, goals, and backstories; tasks define specific assignments; crews coordinate execution. Enterprise deployments at BMW and AWS report 70% faster execution in code modernization pilots.

**LangGraph** provides the most sophisticated control over complex workflows through graph-based orchestration. With 4.2M+ monthly downloads, it excels for stateful applications requiring cycles, branching, and human-in-the-loop patterns. Production use at Klarna, Replit, and Elastic demonstrates enterprise viability.

**AutoGen** (Microsoft) specializes in conversational multi-agent systems using an actor model for event-driven orchestration. The January 2025 v0.4 release introduced a layered architecture with Core API, AgentChat API, and Extensions API. Microsoft is consolidating AutoGen with Semantic Kernel into a unified "Microsoft Agent Framework."

### Technical Architecture

[Continue with detailed technical findings...]

---

## Analysis and Insights

The rapid consolidation around three primary frameworks indicates the AI agent orchestration space is maturing beyond experimentation...

[Continue with insights from analysis agent...]

---

## Recommendations

1. **For Rapid Prototyping**: Start with CrewAI for its intuitive role-based model and gentle learning curve
2. **For Complex Workflows**: Choose LangGraph when requirements include cycles, parallel execution, or sophisticated state management
3. **For Microsoft Ecosystems**: Leverage Semantic Kernel for deep Azure integration
4. **For Provider Flexibility**: Implement LiteLLM as an abstraction layer to switch between Mistral, OpenAI, Claude without code changes

---

## Methodology

This research was conducted on January 5, 2025, using web search to gather information from:
- Official framework documentation
- GitHub repositories and statistics
- Enterprise case studies and blog posts
- Industry analysis and technical reviews

Information was cross-referenced across multiple authoritative sources to ensure accuracy. Focus was placed on frameworks with active development in 2024-2025.

---

## Sources

1. CrewAI Documentation - https://docs.crewai.com/
2. CrewAI GitHub Repository - https://github.com/crewai/crewai
3. LangGraph Documentation - https://langchain.com/langgraph
4. LangChain Blog - https://blog.langchain.dev/
5. Microsoft AutoGen - https://microsoft.github.io/autogen/
6. [Additional sources...]
```

---

## Customization Options

### Adjust Research Depth

Modify the research agent prompt:

```markdown
### Research Depth: {{depth}}

For "quick": 
- 5-10 minute research
- Top 3-5 sources
- High-level overview only

For "standard":
- 15-20 minute research  
- 5-10 sources
- Balanced depth and breadth

For "comprehensive":
- 30+ minute research
- 10+ sources
- Deep dive with multiple perspectives
```

### Add Domain Specialization

Customize agent expertise:

```markdown
## Domain Specialization

You specialize in {{domain}} research:
- Technology: Focus on technical accuracy, industry standards
- Business: Focus on market analysis, ROI, strategic implications  
- Academic: Focus on peer-reviewed sources, theoretical frameworks
- Medical: Focus on clinical studies, evidence-based findings
```

### Enable Multi-Language Support

Add language parameter:

```markdown
## Language Requirements

Output language: {{output_language}}
- Translate all findings to {{output_language}}
- Preserve technical terms in original language with translation
- Include sources in original language
```

---

## Performance Optimization

### Parallel Research

For faster execution, parallelize research queries:

```javascript
// In research agent skill
const searchPromises = queries.map(q => 
  this.invokeToolSearch("web-search", { query: q })
);

const results = await Promise.all(searchPromises);
```

### Caching Strategy

Cache research results to avoid redundant searches:

```javascript
// Check cache before research
const cacheKey = `research_${topic}`;
const cachedResult = await this.getCache(cacheKey);

if (cachedResult && !forceRefresh) {
  return cachedResult;
}

// Otherwise conduct research and cache
const result = await performResearch(topic);
await this.setCache(cacheKey, result, { ttl: 3600 }); // 1 hour TTL
```

### Streaming Output

For better UX, stream results as they're generated:

```javascript
execute: async function ({ topic }) {
  // Stream research updates
  this.stream("Starting research phase...");
  const research = await this.research(topic);
  
  this.stream("Research complete. Analyzing findings...");
  const analysis = await this.analyze(research);
  
  this.stream("Generating final report...");
  const report = await this.write(analysis);
  
  return report;
}
```

---

## Troubleshooting

### Research Returns Poor Quality Results

**Problem**: Research agent finds irrelevant or low-quality sources

**Solutions**:
1. Improve search query formulation in system prompt
2. Add source filtering instructions
3. Increase search result count
4. Add domain-specific search guidance

### Analysis Misses Key Insights

**Problem**: Analysis agent doesn't identify important patterns

**Solutions**:
1. Provide more explicit analysis framework
2. Add specific questions to answer
3. Include example analyses in system prompt
4. Increase temperature for more creative insights

### Report Lacks Structure

**Problem**: Final report is disorganized or incomplete

**Solutions**:
1. Provide stricter output format template
2. Add section length guidelines
3. Include report examples in system prompt
4. Use markdown headers for enforcing structure

---

## Next Steps

1. **Test the pipeline**: Run with a sample topic
2. **Customize agents**: Modify system prompts for your domain
3. **Add tools**: Enable additional tools like SQL, code execution
4. **Build variants**: Create specialized pipelines (code analysis, market research, etc.)
5. **Productionize**: Add error handling, logging, monitoring

---

**Complete code examples**: See [examples/workflows/](../) for downloadable Agent Flow JSON files.

**Questions?** Open an issue in the [repository](https://github.com/kasjens/anythingllm-agent-setup/issues).
