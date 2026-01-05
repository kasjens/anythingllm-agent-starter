# AnythingLLM UI Navigation Guide

Visual guide to finding settings and features in AnythingLLM.

## Interface Overview

```
┌─────────────────────────────────────────────────────────────┐
│  AnythingLLM                                    [Settings ⚙️]│
├──────────────┬──────────────────────────────────────────────┤
│              │                                              │
│  Workspaces  │         Chat Area                           │
│              │                                              │
│  📁 Work     │  💬 Your conversation appears here          │
│  📁 Personal │                                              │
│  📁 Research │                                              │
│  ⚙️ (gear)   │                                              │
│              │                                              │
│  + New       │  ┌────────────────────────────────────┐     │
│  Workspace   │  │ Type your message here...          │     │
│              │  └────────────────────────────────────┘     │
└──────────────┴──────────────────────────────────────────────┘
```

---

## Finding Workspace Settings

### Step 1: Locate the Gear Icon

In the **left sidebar**, next to your workspace name, you'll see a gear icon (⚙️):

```
Workspaces Panel:
┌─────────────────┐
│ My Workspace ⚙️ │  ← Click this gear icon
├─────────────────┤
│ Research     ⚙️ │
├─────────────────┤
│ Code Review  ⚙️ │
└─────────────────┘
```

### Step 2: Navigate to Chat Settings Tab

After clicking the gear icon, you'll see **3 tabs** at the top:

```
┌─────────────────────────────────────────────────────┐
│ ⬅️ Back                                              │
├─────────────────────────────────────────────────────┤
│ [General Settings] [Chat Settings] [Vector Database]│ ← Click "Chat Settings"
│                                                      │
│  Settings content appears here...                   │
│                                                      │
└─────────────────────────────────────────────────────┘
```

### Step 3: Find the Prompt Field

In the **Chat Settings** tab, scroll down to find the **Prompt** field:

```
Chat Settings Tab:
┌──────────────────────────────────────────────┐
│                                               │
│  Chat Mode: [Chat ▼]                         │
│                                               │
│  Temperature: [0.7] ─────────                │
│                                               │
│  ↓ Scroll down...                            │
│                                               │
│  Prompt:                                      │
│  ┌──────────────────────────────────────┐   │
│  │ Enter your system prompt here...      │   │ ← Paste your agent blueprint here
│  │                                       │   │
│  │                                       │   │
│  │                                       │   │
│  └──────────────────────────────────────┘   │
│                                               │
│  [Update workspace]                          │
│                                               │
└──────────────────────────────────────────────┘
```

---

## Complete Step-by-Step Visual

### 1️⃣ Click Workspace Gear Icon

```
Left Sidebar:
┌─────────────────┐
│ Workspaces      │
│                 │
│ Research     ⚙️ │ ← CLICK HERE
│ Personal     ⚙️ │
│ Code Review  ⚙️ │
│                 │
│ + New Workspace │
└─────────────────┘
```

### 2️⃣ Click "Chat Settings" Tab

```
Settings Window:
┌──────────────────────────────────────────────┐
│ ⬅️ Back to Workspace                          │
├──────────────────────────────────────────────┤
│                                               │
│  General Settings | Chat Settings | Vector DB│
│                     ↑                         │
│                   CLICK HERE                  │
│                                               │
└──────────────────────────────────────────────┘
```

### 3️⃣ Scroll Down to "Prompt" Field

```
Chat Settings Content:
┌──────────────────────────────────────────────┐
│  Chat Mode:     [Chat ▼]                     │
│                                               │
│  Temperature:   [0.7] ─────────              │
│                                               │
│  Max History:   [20] ─────────               │
│                                               │
│  ⬇️ Scroll down to see...                     │
│                                               │
│  Prompt:                                      │
│  ┌──────────────────────────────────────┐   │
│  │ You are a helpful assistant.          │   │
│  │                                       │   │
│  │ [Your agent system prompt goes here] │   │
│  │                                       │   │
│  └──────────────────────────────────────┘   │
│                                               │
│  [Update workspace] ← Click to save          │
└──────────────────────────────────────────────┘
```

---

## Other Important Settings Locations

### System-Wide LLM Settings

For configuring Mistral API (applies to all workspaces by default):

```
Main Interface:
┌─────────────────────────────────────────┐
│  AnythingLLM              [Settings ⚙️] │ ← Click this gear (top right)
├─────────────────────────────────────────┤
│                                          │
│  Opens Settings Menu:                   │
│                                          │
│  → LLM Preference                       │ ← Click here for Mistral setup
│  → Embedding Preference                 │
│  → Vector Database                      │
│  → Appearance                           │
│  → Audio Preference                     │
│  → Agent Skills                         │
│  → Workspace Chat                       │
│                                          │
└─────────────────────────────────────────┘
```

### Configuring Mistral API

```
Settings → LLM Preference:
┌──────────────────────────────────────────────┐
│  LLM Provider: [OpenAI ▼]                    │
│                                               │
│  Base URL:                                    │
│  ┌──────────────────────────────────────┐   │
│  │ https://api.mistral.ai/v1             │   │
│  └──────────────────────────────────────┘   │
│                                               │
│  API Key:                                     │
│  ┌──────────────────────────────────────┐   │
│  │ your-mistral-api-key                  │   │
│  └──────────────────────────────────────┘   │
│                                               │
│  Model:                                       │
│  ┌──────────────────────────────────────┐   │
│  │ mistral-large-latest                  │   │
│  └──────────────────────────────────────┘   │
│                                               │
│  [Save]                                      │
└──────────────────────────────────────────────┘
```

### Agent Skills

For custom agent skills (advanced):

```
Settings → Agent Skills:
┌──────────────────────────────────────────────┐
│  Available Skills:                            │
│                                               │
│  ✅ web-search                                │
│  ✅ web-scraping                              │
│  ✅ rag-search                                │
│  ✅ save-file-to-browser                      │
│                                               │
│  Custom Skills:                               │
│  ┌────────────────────────────────────────┐ │
│  │ + Create Custom Skill                   │ │
│  └────────────────────────────────────────┘ │
│                                               │
└──────────────────────────────────────────────┘
```

---

## Quick Reference: Where is...?

| What You Need | Where to Find It |
|---------------|------------------|
| **System Prompt for a workspace** | Workspace Gear ⚙️ → Chat Settings tab → Scroll to "Prompt" field |
| **Mistral API Configuration** | Top-right Settings ⚙️ → LLM Preference |
| **Enable web search** | Top-right Settings ⚙️ → Agent Skills |
| **Chat mode (Chat vs Query)** | Workspace Gear ⚙️ → Chat Settings → Chat Mode dropdown |
| **Temperature setting** | Workspace Gear ⚙️ → Chat Settings → Temperature slider |
| **Upload documents** | In chat area, click the paperclip icon or drag-and-drop |
| **View workspace documents** | Workspace Gear ⚙️ → General Settings → Documents section |
| **Agent Flows** | Main menu → Agent Flows (if available in your version) |

---

## Common UI Confusion Points

### ❓ "I can't find System Prompt"

**Answer**: It's called "**Prompt**" (not "System Prompt") and it's in:
- Workspace gear icon → Chat Settings tab → Scroll down

### ❓ "Where do I configure Mistral?"

**Answer**: Two different places depending on scope:
- **For all workspaces**: Top-right Settings ⚙️ → LLM Preference
- **For one workspace only**: Workspace gear ⚙️ → General Settings → LLM Override

### ❓ "My agent isn't using tools"

**Answer**: Check two places:
1. System-wide: Top-right Settings ⚙️ → Agent Skills → Enable tools
2. In your prompt: Mention that tools are available

### ❓ "Chat mode vs Query mode?"

**Answer**: Located in Workspace gear ⚙️ → Chat Settings → Chat Mode
- **Chat**: Conversational, maintains context
- **Query**: Focuses only on RAG documents, more precise

---

## Version Differences

**Note**: UI may vary slightly between versions:

- **Desktop App**: Full featured, includes Agent Flows
- **Docker/Web**: Same interface as desktop
- **Cloud Version**: May have additional features or restrictions

If your interface looks different:
1. Check you're using the latest version
2. Try updating: `docker pull mintplexlabs/anythingllm:latest`
3. Check the [official docs](https://docs.anythingllm.com/)

---

## Troubleshooting UI Issues

### Can't See Tabs in Workspace Settings

**Problem**: No tabs visible when clicking workspace gear

**Solution**: 
- Make sure you clicked the gear icon NEXT to workspace name, not elsewhere
- Try refreshing the page
- Check browser console for errors (F12)

### Settings Not Saving

**Problem**: Click "Update workspace" but changes don't apply

**Solution**:
- Scroll to bottom and click the actual "Update workspace" button
- Check for error messages
- Try refreshing and re-entering

### Missing Features

**Problem**: Can't find Agent Flows, certain tools, etc.

**Solution**:
- Feature may not be in your version
- Update to latest version
- Check if feature is Docker-only or Desktop-only
- Verify your deployment method (Cloud, Docker, Desktop)

---

## Still Can't Find It?

1. **Use Ctrl+F (or Cmd+F)** to search within settings pages
2. **Check version**: Settings → About (at bottom of settings menu)
3. **Consult docs**: [docs.anythingllm.com](https://docs.anythingllm.com/)
4. **Ask community**: [Discord](https://discord.gg/anythingllm)

---

**Last Updated**: January 2025 (based on AnythingLLM v1.x)

**Note**: If screenshots differ from your interface, you may be using a different version. The general locations should be similar.
