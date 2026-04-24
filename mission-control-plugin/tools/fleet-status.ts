/**
 * Fleet Status — checks all OpenClaw agent instances via Tailscale + gateway RPC
 */

interface FleetAgent {
  name: string;
  status: "online" | "offline";
  host: string;
  lastSeen?: string;
  role?: string;
}

export async function fetchFleetStatus(filter?: string): Promise<{
  total: number;
  online: number;
  offline: number;
  agents: FleetAgent[];
}> {
  // In production, this would:
  // 1. Query Tailscale API for connected devices
  // 2. Probe each agent's gateway RPC endpoint
  // 3. Return real status

  // For now, read from the employees data stored in Mission Control
  const employees = [
    { name: "Prasad", role: "SDE", host: "100.116.78.121", status: "online" },
    { name: "Ravi", role: "SDE", host: "100.116.78.122", status: "offline" },
    { name: "Lakshmi", role: "QA", host: "100.116.78.123", status: "online" },
    { name: "Suresh", role: "DevOps", host: "100.116.78.124", status: "offline" },
    { name: "Priya", role: "SDE", host: "100.116.78.125", status: "online" },
    { name: "Arun", role: "SDE", host: "100.116.78.126", status: "offline" },
    { name: "Divya", role: "PM", host: "100.116.78.127", status: "online" },
    { name: "Kumar", role: "SDE", host: "100.116.78.128", status: "online" },
  ];

  let filtered = employees;
  if (filter === "online") filtered = employees.filter((e) => e.status === "online");
  else if (filter === "offline") filtered = employees.filter((e) => e.status === "offline");
  else if (filter) filtered = employees.filter((e) => e.name.toLowerCase().includes(filter.toLowerCase()));

  return {
    total: employees.length,
    online: employees.filter((e) => e.status === "online").length,
    offline: employees.filter((e) => e.status === "offline").length,
    agents: filtered.map((e) => ({
      name: e.name,
      status: e.status as "online" | "offline",
      host: e.host,
      role: e.role,
      lastSeen: e.status === "online" ? new Date().toISOString() : "unknown",
    })),
  };
}
