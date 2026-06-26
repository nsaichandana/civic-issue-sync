export type ReportStatus =
  | "pending"
  | "under_review"
  | "assigned"
  | "in_progress"
  | "resolved"
  | "rejected";

export type IssueStatus = ReportStatus;

export type Priority = "low" | "medium" | "high" | "critical";

export type ReportSource = "Citizen" | "Ward Office" | "Municipality" | "Verified News";

export type Category =
  | "Pothole"
  | "Garbage Overflow"
  | "Water Leakage"
  | "Broken Streetlight"
  | "Drainage Blockage";

export type Department = "Roads" | "Sanitation" | "Water Supply" | "Electrical";

export interface Report {
  id: string;
  source: ReportSource;
  category: Category;
  ward: string;
  submittedAt: string;
  status: ReportStatus;
  reporter: string;
  description: string;
  location: string;
  linkedIssueId?: string;
}

export interface Issue {
  id: string;
  title: string;
  category: Category;
  ward: string;
  department: Department;
  priority: Priority;
  status: IssueStatus;
  reportsCount: number;
  lastUpdated: string;
  description: string;
  reportIds: string[];
}

export interface TimelineEvent {
  id: string;
  at: string;
  actor: string;
  action: string;
  note?: string;
}

export interface FieldWork {
  id: string;
  issueId: string;
  title: string;
  ward: string;
  category: Category;
  priority: Priority;
  due: string;
  status: "assigned" | "in_progress" | "completed";
}
