import { definePluginEntry } from "openclaw/plugin-sdk/plugin-entry";
import { Type } from "@sinclair/typebox";

export default definePluginEntry({
  id: "mission-control",
  name: "Mission Control",
  description:
    "Multi-agent management dashboard — manage employees, email campaigns, and monitor your OpenClaw fleet from one place",
  register(api) {
    // ─── Tool 1: Fleet Status ────────────────────────────
    api.registerTool({
      name: "mission_control_status",
      description:
        "Get the status of all OpenClaw agents in your fleet — online/offline, recent activity, gateway health. Use when the user asks about their team, employees, or agent fleet status.",
      parameters: Type.Object({
        filter: Type.Optional(
          Type.String({
            description:
              "Optional filter: 'online', 'offline', or agent name",
          })
        ),
      }),
      async execute(_id, params) {
        try {
          const { fetchFleetStatus } = await import("./tools/fleet-status.js");
          const result = await fetchFleetStatus(params.filter);
          return {
            content: [{ type: "text" as const, text: JSON.stringify(result, null, 2) }],
          };
        } catch (err: any) {
          return {
            content: [{ type: "text" as const, text: `Error: ${err.message}` }],
          };
        }
      },
    });

    // ─── Tool 2: Campaign Send ───────────────────────────
    api.registerTool({
      name: "mission_control_campaign_send",
      description:
        "Send an email campaign to a list of recipients. Supports subject, body (plain or HTML), and recipient list. Use when the user wants to send bulk emails, outreach, or newsletters.",
      parameters: Type.Object({
        subject: Type.String({ description: "Email subject line" }),
        body: Type.String({ description: "Email body (plain text or HTML)" }),
        recipients: Type.Array(Type.String({ format: "email" }), {
          description: "List of recipient email addresses",
        }),
        fromName: Type.Optional(
          Type.String({ description: "Sender display name" })
        ),
        trackOpens: Type.Optional(
          Type.Boolean({
            description: "Track email opens (default: true)",
            default: true,
          })
        ),
      }),
      async execute(_id, params) {
        try {
          const { sendCampaign } = await import("./tools/campaign-send.js");
          const result = await sendCampaign(params);
          return {
            content: [{ type: "text" as const, text: JSON.stringify(result, null, 2) }],
          };
        } catch (err: any) {
          return {
            content: [{ type: "text" as const, text: `Error: ${err.message}` }],
          };
        }
      },
    });

    // ─── Tool 3: Employee List ──────────────────────────
    api.registerTool({
      name: "mission_control_employee_list",
      description:
        "List all employees/agents managed by Mission Control. Returns names, roles, status, and Telegram handles. Use when the user asks about their team or wants to manage employees.",
      parameters: Type.Object({
        includeOffline: Type.Optional(
          Type.Boolean({
            description: "Include offline agents (default: true)",
            default: true,
          })
        ),
      }),
      async execute(_id, params) {
        try {
          const { listEmployees } = await import("./tools/employee-list.js");
          const result = await listEmployees(params.includeOffline ?? true);
          return {
            content: [{ type: "text" as const, text: JSON.stringify(result, null, 2) }],
          };
        } catch (err: any) {
          return {
            content: [{ type: "text" as const, text: `Error: ${err.message}` }],
          };
        }
      },
    });

    // ─── Gateway Method: Dashboard Proxy ────────────────
    api.registerGatewayMethod(
      "mission-control.dashboard",
      async (_gatewayCtx, request) => {
        const dashboardUrl =
          (request.config as any)?.dashboardUrl || "http://localhost:3000";
        return {
          url: dashboardUrl,
          status: "ok",
          version: "1.0.0",
        };
      },
      { scope: "operator.read" }
    );
  },
});
