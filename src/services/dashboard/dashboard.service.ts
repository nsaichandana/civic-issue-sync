import { supabase } from "@/config/supabase";

export async function getDashboardStats() {
  const [
    reportsResult,
    issuesResult,
    assignmentsResult,
    auditLogsResult,
  ] = await Promise.all([
    supabase
      .from("reports")
      .select("*", { count: "exact", head: true }),

    supabase
      .from("issues")
      .select("*", { count: "exact", head: true }),

    supabase
      .from("assignments")
      .select("*", { count: "exact", head: true }),

    supabase
      .from("audit_logs")
      .select("*", { count: "exact", head: true }),
  ]);

  return {
    reports: reportsResult.count ?? 0,
    issues: issuesResult.count ?? 0,
    assignments: assignmentsResult.count ?? 0,
    auditLogs: auditLogsResult.count ?? 0,
  };
}