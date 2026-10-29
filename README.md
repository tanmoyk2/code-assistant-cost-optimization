# Code Assistant Agent: Multi-Agent Cost Optimization

Hands-on implementation for measuring and optimizing the per-query cost of a multi-agent **Code Assistant Agent** built with the **Google Agent Development Kit (ADK)**, **Vertex AI Search (Agent Search)**, and **ChromaDB**, while preserving answer quality (`>= 0.90`) as evaluated by an LLM-as-a-Judge autorater.

## Repository Structure

```text
├── assets/
│   ├── docs.jsonl                              # Official engineering documentation corpus (Agent Search)
│   ├── stackoverflow.jsonl                     # Community Q&A corpus (local ChromaDB vector store)
│   ├── eval_dataset.jsonl                      # 15-query evaluation dataset for Lever experiments (Parts 1-5)
│   └── eval_holdout.jsonl                      # 16-query held-out evaluation dataset for Final Challenge (Part 6)
├── code_assistant/
│   ├── __init__.py
│   ├── agents.py                               # ADK Coordinator, DocsAgent, and CommunityAgent wiring
│   ├── data.py                                 # JSONL dataset loader
│   ├── display.py                              # Scorecard & challenge verdict display helpers
│   ├── ledger.py                               # UsageLedger for token, embedding, and retrieval cost attribution
│   ├── quality.py                              # Vertex AI Gen AI Evaluation Service rubric & autorater
│   ├── retrieval.py                            # ChromaDB index builder and Gemini embedding lookup
│   └── vais.py                                 # Managed Vertex AI Search (Discovery Engine) provisioning & search
├── code_assistant_cost_optimization.ipynb      # Lab notebook with completed Final Challenge configuration
├── code_assistance_optimization_modified.ipynb # Modified notebook incorporating the optimized configuration
└── notebook_config.sh                          # Vertex AI Workbench startup script
```

## Optimization Levers & Final Challenge Configuration

| Parameter | Baseline (Part 1) | Optimized Final Challenge (Part 6) | Impact |
| :--- | :--- | :--- | :--- |
| `MY_MODELS["coordinator"]` | `gemini-3.1-pro-preview` | `gemini-3.5-flash` | **Lever 1 (Model Tiering)**: Reduces Coordinator token pricing while preserving multi-source synthesis quality. |
| `MY_MODELS["docs"]` | `gemini-3.5-flash` | `gemini-3.1-flash-lite` | **Sub-Agent Tiering**: Cuts `DocsAgent` LLM token costs by **6x** (`$0.25/$1.50` vs. `$1.50/$9.00` per 1M tokens). |
| `MY_MODELS["community"]` | `gemini-3.5-flash` | `gemini-3.1-flash-lite` | **Sub-Agent Tiering**: Cuts `CommunityAgent` LLM token costs by **6x**. |
| `MY_MODELS["embedding"]` | `gemini-embedding-001` | `gemini-embedding-001` | Embedding model for ChromaDB vector search (`$0.15` per 1M tokens). |
| `MY_THINKING` | `"HIGH"` | `"LOW"` | **Lever 3a (Reasoning Reduction)**: Minimizes Coordinator `thought_tokens` billed at the output rate. |
| `MY_TOPK` | `3` | `2` | **Lever 3b (Retrieval Breadth)**: Trims retrieved context snippets per lookup while covering multi-part queries. |
| `MY_MAXOUT` | `None` (`3072`) | `None` (`3072`) | Retains default ceiling to avoid truncating synthesized answers. |
