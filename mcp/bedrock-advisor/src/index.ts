#!/usr/bin/env node
import { Server } from "@modelcontextprotocol/sdk/server/index.js";
import { StdioServerTransport } from "@modelcontextprotocol/sdk/server/stdio.js";
import {
  CallToolRequestSchema,
  ListToolsRequestSchema,
} from "@modelcontextprotocol/sdk/types.js";
import { BedrockRuntimeClient, InvokeModelCommand } from "@aws-sdk/client-bedrock-runtime";

const AWS_REGION = process.env.AWS_REGION || "us-west-2";
const MODEL_ID = "global.anthropic.claude-haiku-4-5-20251001-v1:0";

const bedrock = new BedrockRuntimeClient({ region: AWS_REGION });

// Error attempt tracker (errorKey -> { count, attempts })
const attemptTracker = new Map<string, { count: number; attempts: string[] }>();

const server = new Server(
  {
    name: "bedrock-advisor",
    version: "1.1.0",
  },
  {
    capabilities: {
      tools: {},
    },
  }
);

server.setRequestHandler(ListToolsRequestSchema, async () => {
  return {
    tools: [
      {
        name: "ask_advisor",
        description: "Ask AI advisor when stuck on a problem. Use this when you need help solving issues, debugging, or getting unstuck.",
        inputSchema: {
          type: "object",
          properties: {
            question: {
              type: "string",
              description: "Your question or problem description",
            },
            context: {
              type: "string",
              description: "Additional context like error messages, code snippets, or relevant information (optional)",
            },
          },
          required: ["question"],
        },
      },
      {
        name: "record_attempt",
        description: "Record a fix attempt for an error. Call this BEFORE every error fix attempt. Automatically escalates to AI advisor if the same error occurs 2+ times.",
        inputSchema: {
          type: "object",
          properties: {
            error_key: {
              type: "string",
              description: "Short identifier for the error (e.g. 'TypeError: cannot read properties of undefined')",
            },
            what_i_tried: {
              type: "string",
              description: "What fix you are about to try",
            },
            code_context: {
              type: "string",
              description: "Relevant code snippet or file context (optional)",
            },
          },
          required: ["error_key", "what_i_tried"],
        },
      },
    ],
  };
});

async function callAdvisor(question: string, context?: string): Promise<string> {
  const prompt = context
    ? `Context:\n${context}\n\nQuestion:\n${question}`
    : `Question:\n${question}`;

  const response = await bedrock.send(
    new InvokeModelCommand({
      modelId: MODEL_ID,
      body: JSON.stringify({
        anthropic_version: "bedrock-2023-05-31",
        max_tokens: 4096,
        messages: [{ role: "user", content: prompt }],
      }),
    })
  );

  const responseBody = JSON.parse(new TextDecoder().decode(response.body));
  return responseBody.content[0].text;
}

server.setRequestHandler(CallToolRequestSchema, async (request) => {
  // ── ask_advisor ──────────────────────────────────────────────
  if (request.params.name === "ask_advisor") {
    const { question, context } = request.params.arguments as {
      question: string;
      context?: string;
    };

    try {
      const answer = await callAdvisor(question, context);
      return { content: [{ type: "text", text: answer }] };
    } catch (error) {
      const errorMessage = error instanceof Error ? error.message : String(error);
      return {
        content: [{ type: "text", text: `Error calling Bedrock: ${errorMessage}` }],
        isError: true,
      };
    }
  }

  // ── record_attempt ───────────────────────────────────────────
  if (request.params.name === "record_attempt") {
    const { error_key, what_i_tried, code_context } = request.params.arguments as {
      error_key: string;
      what_i_tried: string;
      code_context?: string;
    };

    // Update counter
    const existing = attemptTracker.get(error_key) ?? { count: 0, attempts: [] };
    existing.count += 1;
    existing.attempts.push(what_i_tried);
    attemptTracker.set(error_key, existing);

    const { count, attempts } = existing;

    // First attempt: just record
    if (count < 2) {
      return {
        content: [
          {
            type: "text",
            text: `[Attempt ${count}/2] Recorded. Try your fix. If it fails again, I will escalate automatically.`,
          },
        ],
      };
    }

    // 2+ attempts: auto-escalate to advisor
    const question = `I've tried ${count} times to fix this error but haven't succeeded. Please help me solve it.\n\nError: ${error_key}`;
    const context = [
      `## Previous attempts (${count} times)`,
      attempts.map((a, i) => `${i + 1}. ${a}`).join("\n"),
      code_context ? `\n## Code\n${code_context}` : "",
    ]
      .filter(Boolean)
      .join("\n");

    try {
      const answer = await callAdvisor(question, context);
      // Reset counter after successful escalation
      attemptTracker.delete(error_key);
      return {
        content: [
          {
            type: "text",
            text: `[Auto-escalated after ${count} attempts]\n\n${answer}`,
          },
        ],
      };
    } catch (error) {
      const errorMessage = error instanceof Error ? error.message : String(error);
      return {
        content: [{ type: "text", text: `Error calling Bedrock: ${errorMessage}` }],
        isError: true,
      };
    }
  }

  throw new Error(`Unknown tool: ${request.params.name}`);
});

async function main() {
  const transport = new StdioServerTransport();
  await server.connect(transport);
  console.error("MCP Bedrock Advisor server running on stdio");
}

main().catch((error) => {
  console.error("Fatal error:", error);
  process.exit(1);
});
