import { supabase } from "@/config/supabase";

export interface DashboardStats {
  totalReports: number;
  totalIssues: number;
  pendingReports: number;
  resolvedIssues: number;
}

export async function getDashboardStats(): Promise<DashboardStats> {
  const [
    reportsResult,
    issuesResult,
    pendingResult,
    resolvedResult,
  ] = await Promise.all([
    supabase.from("reports").select("*", { count: "exact", head: true }),

    supabase.from("issues").select("*", { count: "exact", head: true }),

    supabase
      .from("reports")
      .select("*", { count: "exact", head: true })
      .eq("status", "UNDER_REVIEW"),

    supabase
      .from("issues")
      .select("*", { count: "exact", head: true })
      .eq("status", "RESOLVED"),
  ]);

  if (
    reportsResult.error ||
    issuesResult.error ||
    pendingResult.error ||
    resolvedResult.error
  ) {
    throw new Error("Failed to fetch dashboard statistics.");
  }

  return {
    totalReports: reportsResult.count ?? 0,
    totalIssues: issuesResult.count ?? 0,
    pendingReports: pendingResult.count ?? 0,
    resolvedIssues: resolvedResult.count ?? 0,
  };
}