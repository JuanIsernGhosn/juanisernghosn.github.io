---
layout: project
title: "ALIA Patrimonio de Andalucía – AI-powered heritage exploration"
description: "A conversational AI platform that lets users explore, search, and generate personalized routes across 134,000+ Andalusian cultural heritage assets using RAG and LLMs."
image: "/assets/img/2026-04-10-alia-patrimonio-andalucia/02-home.png"
image_description: "Home page of ALIA Patrimonio de Andalucía showing the hero image of Andalusian heritage with semantic search and virtual routes access."
date: 2026-04-10 10:00:00 +0200
read_time: 12
repo: https://github.com/sinai-uja/ALIA-demo-patrimonio
---

**ALIA Patrimonio de Andalucía** is a conversational AI platform built for the Instituto Andaluz de Patrimonio Histórico (IAPH). It makes over 134,000 cultural heritage records — buildings, artworks, intangible traditions, and landscapes — accessible through natural language. Users can search semantically, generate personalized virtual routes, and interact with an AI guide, all powered by a custom RAG (Retrieval-Augmented Generation) pipeline.

I developed this platform as part of the ALIA initiative, a national project funded by the Spanish government and the EU's NextGenerationEU program. The system is designed to serve researchers, heritage professionals, and the general public.

---

## Architecture

The platform runs as four containerized services orchestrated with Docker Compose:

```text
┌─────────────┐     ┌──────────────┐
│   Frontend   │────▶│   Backend    │
│  (Next.js)   │     │  (FastAPI)   │
└─────────────┘     └──────┬───────┘
                           │
                    ┌──────┴───────┐
                    │              │
              ┌─────▼─────┐ ┌─────▼─────┐
              │ Embedding  │ │    LLM    │
              │  Service   │ │  Service  │
              │  (FastAPI) │ │  (vLLM)   │
              └─────┬─────┘ └─────┬─────┘
                    │              │
                    └──────┬───────┘
                           │
                    ┌──────▼───────┐
                    │ PostgreSQL   │
                    │ + pgvector   │
                    └──────────────┘
```

The backend follows a strict **hexagonal architecture** with 10 bounded contexts (documents, RAG, chat, routes, heritage, search, accessibility, auth, feedback, shared), each implementing the same four-layer pattern: domain → application → infrastructure → API.

---

## RAG pipeline

The core intelligence is a hybrid RAG pipeline that retrieves relevant heritage information and generates grounded answers:

1. **Query reformulation** — rewrites multi-turn chat queries into standalone questions using conversation history
2. **Embedding** — encodes the query with MrBERT (308M parameters, 768-dim vectors) or Qwen3-Embedding
3. **Hybrid search** — runs vector search (pgvector cosine similarity) and full-text search (PostgreSQL tsvector with Spanish stemming) in parallel, retrieving 20 candidates each
4. **Reciprocal Rank Fusion** — merges both result sets with a 1.5× weight on text matches
5. **Reranking** — applies neural reranking (Qwen3-Reranker) and heuristic signals (title match, coverage, position)
6. **Generation** — assembles the top-k chunks into a prompt for Salamandra-7b (BSC) or Gemini, generating an answer with source citations

The pipeline includes an abstention mechanism: if all retrieved chunks fall below the relevance threshold, the system responds with an "insufficient information" message instead of hallucinating.

---

## Semantic search

The search interface lets users query the full heritage catalog in natural language. The system automatically detects entities in the query — provinces, municipalities, heritage types — and offers to apply them as filters.

<p class="text-center">
  <img src="/assets/img/2026-04-10-alia-patrimonio-andalucia/04-search-results.png" width="100%" title="Search results with entity detection and faceted filtering">
</p>
<p class="text-center"><i>Search results showing entity detection, relevance scores, and the detail panel with images and map</i></p>

Results display as cards color-coded by heritage type (green for buildings, purple for artworks, teal for intangible heritage, blue for landscapes). Clicking a result opens a detail panel with an image gallery, interactive Leaflet map, and structured metadata.

---

## Virtual routes

Users can describe a route in natural language — "Renaissance monuments in Úbeda and Baeza" or "Cave paintings in Jaén" — and the system generates a personalized itinerary with AI-written narrative connecting the stops.

<p class="text-center">
  <img src="/assets/img/2026-04-10-alia-patrimonio-andalucia/05-routes.png" width="100%" title="Route generator with smart input and saved routes">
</p>
<p class="text-center"><i>Route generator with entity-aware input and grid of previously generated routes</i></p>

Each route includes a cover image, metadata (province, number of stops, estimated duration), and an interleaved layout of narrative sections and stop cards:

<p class="text-center">
  <img src="/assets/img/2026-04-10-alia-patrimonio-andalucia/06-route-detail.png" width="100%" title="Route detail page with interleaved narrative and stops">
</p>
<p class="text-center"><i>Route detail showing the header, AI-generated introduction, and the first stop with its narrative</i></p>

A floating chat button opens an **interactive guide** — a chatbot contextualized to the current route that can answer questions about any of the heritage assets along the way.

---

## Accessibility

The platform includes a **Lectura Fácil** (Easy Reading) module that simplifies heritage texts following ILSMH guidelines, making content accessible to people with cognitive disabilities. Users can choose between basic and intermediate simplification levels.

---

## Tech stack

| Layer | Technologies |
| ----- | ------------ |
| Backend | Python 3.11, FastAPI, SQLAlchemy 2.0, Alembic, asyncpg, pgvector |
| Frontend | Next.js 16, React 19, TypeScript, Tailwind CSS v4, Zustand, react-leaflet |
| AI/ML | MrBERT, Qwen3-Embedding, Qwen3-Reranker, Salamandra-7b, ALIA-40b, vLLM |
| Infrastructure | Docker Compose, PostgreSQL 16, Google Cloud Run, GitLab CI/CD |

---

## Key numbers

| Metric | Value |
| ------ | ----- |
| Heritage records indexed | 134,000+ |
| Bounded contexts | 10 |
| API endpoints | 40+ |
| Test functions | 307+ |
| Embedding dimensions | 768 (MrBERT) / 1,024 (Qwen3) |
| Supported LLM backends | 3 (Salamandra, ALIA-40b, Gemini) |

---

> ALIA Patrimonio de Andalucía is developed within the framework of the ALIA initiative, funded by the Spanish Ministry of Digital Transformation and the EU's NextGenerationEU program, in collaboration with the Barcelona Supercomputing Center (BSC) and the University of Jaén (SINAI research group).
