/**
 * Employee List — returns all employees/agents managed by Mission Control
 */

interface Employee {
  id: string;
  name: string;
  role: string;
  email: string;
  telegram?: string;
  status: "active" | "inactive";
  openClawVersion: string;
  model: string;
}

export async function listEmployees(includeOffline = true): Promise<{
  total: number;
  employees: Employee[];
}> {
  // In production, this reads from Mission Control's database
  const allEmployees: Employee[] = [
    { id: "emp-1", name: "Prasad Veera", role: "SDE", email: "prasadveera369@gmail.com", telegram: "@prasad", status: "active", openClawVersion: "2026.4.15", model: "ollama/glm-5.1:cloud" },
    { id: "emp-2", name: "Ravi Kumar", role: "SDE", email: "ravi@company.com", telegram: "@ravi", status: "inactive", openClawVersion: "2026.4.15", model: "ollama/glm-5.1:cloud" },
    { id: "emp-3", name: "Lakshmi Priya", role: "QA Lead", email: "lakshmi@company.com", telegram: "@lakshmi", status: "active", openClawVersion: "2026.4.15", model: "ollama/glm-5.1:cloud" },
    { id: "emp-4", name: "Suresh Babu", role: "DevOps", email: "suresh@company.com", status: "inactive", openClawVersion: "2026.4.15", model: "ollama/glm-5.1:cloud" },
    { id: "emp-5", name: "Priya Sharma", role: "SDE", email: "priya@company.com", telegram: "@priya", status: "active", openClawVersion: "2026.4.15", model: "ollama/glm-5.1:cloud" },
    { id: "emp-6", name: "Arun Reddy", role: "SDE", email: "arun@company.com", status: "inactive", openClawVersion: "2026.4.15", model: "ollama/glm-5.1:cloud" },
    { id: "emp-7", name: "Divya Sri", role: "PM", email: "divya@company.com", telegram: "@divya", status: "active", openClawVersion: "2026.4.15", model: "ollama/glm-5.1:cloud" },
    { id: "emp-8", name: "Kumar Swamy", role: "SDE", email: "kumar@company.com", telegram: "@kumar", status: "active", openClawVersion: "2026.4.15", model: "ollama/glm-5.1:cloud" },
  ];

  const employees = includeOffline ? allEmployees : allEmployees.filter((e) => e.status === "active");

  return {
    total: employees.length,
    employees,
  };
}
