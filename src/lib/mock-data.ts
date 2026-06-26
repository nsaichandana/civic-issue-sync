import type {
  Category,
  Department,
  FieldWork,
  Issue,
  Priority,
  Report,
  ReportSource,
  ReportStatus,
  TimelineEvent,
} from "@/types";

export const CATEGORIES: Category[] = [
  "Pothole",
  "Garbage Overflow",
  "Water Leakage",
  "Broken Streetlight",
  "Drainage Blockage",
];

export const SOURCES: ReportSource[] = ["Citizen", "Ward Office", "Municipality", "Verified News"];
export const DEPARTMENTS: Department[] = ["Roads", "Sanitation", "Water Supply", "Electrical"];
export const PRIORITIES: Priority[] = ["low", "medium", "high", "critical"];
export const STATUSES: ReportStatus[] = [
  "pending",
  "under_review",
  "assigned",
  "in_progress",
  "resolved",
  "rejected",
];

export const WARDS = ["Ward 12", "Ward 03", "Ward 21", "Ward 07", "Ward 18", "Ward 09", "Ward 25"];

const REPORTERS = [
  "A. Nair",
  "S. Iyer",
  "Ward 07 Office",
  "Times Civic Desk",
  "Municipality Inspector",
  "R. Banerjee",
  "K. Mehta",
  "Sanitation Audit",
];

const LOCATIONS = [
  "MG Road, near junction",
  "Sector 14, Block C",
  "Lake View Avenue",
  "Old Market Street",
  "Civic Center Roundabout",
  "Greenwood Layout",
  "Riverside Lane",
];

function pick<T>(arr: T[], i: number): T {
  return arr[i % arr.length]!;
}

function hoursAgo(h: number) {
  return new Date(Date.now() - h * 60 * 60 * 1000).toISOString();
}

export const REPORTS: Report[] = Array.from({ length: 42 }).map((_, i) => {
  const cat = pick(CATEGORIES, i);
  const status = pick(STATUSES, i * 3 + 1);
  return {
    id: `RPT-${(1024 + i).toString()}`,
    source: pick(SOURCES, i + 2),
    category: cat,
    ward: pick(WARDS, i + 1),
    submittedAt: hoursAgo(i * 3 + 1),
    status,
    reporter: pick(REPORTERS, i),
    description: `${cat} reported near ${pick(LOCATIONS, i)}. Affecting daily commute and local residents.`,
    location: pick(LOCATIONS, i),
    linkedIssueId: i % 2 === 0 ? `ISS-${2000 + Math.floor(i / 2)}` : undefined,
  };
});

const ISSUE_TITLES: Record<Category, string> = {
  Pothole: "Deep pothole disrupting traffic",
  "Garbage Overflow": "Overflowing community bins",
  "Water Leakage": "Persistent water main leak",
  "Broken Streetlight": "Streetlight outage stretch",
  "Drainage Blockage": "Blocked drainage causing waterlogging",
};

export const ISSUES: Issue[] = Array.from({ length: 24 }).map((_, i) => {
  const cat = pick(CATEGORIES, i);
  const status = pick(STATUSES, i + 2);
  return {
    id: `ISS-${2000 + i}`,
    title: `${ISSUE_TITLES[cat]} — ${pick(WARDS, i)}`,
    category: cat,
    ward: pick(WARDS, i),
    department: pick(DEPARTMENTS, i),
    priority: pick(PRIORITIES, i + 1),
    status,
    reportsCount: 2 + ((i * 3) % 9),
    lastUpdated: hoursAgo(i * 5 + 2),
    description: `Multiple trusted reports identify a recurring ${cat.toLowerCase()} in ${pick(WARDS, i)}. AI grouped ${2 + ((i * 3) % 9)} sources referring to the same real-world incident.`,
    reportIds: REPORTS.filter((r) => r.linkedIssueId === `ISS-${2000 + i}`).map((r) => r.id),
  };
});

export const TIMELINE: TimelineEvent[] = [
  { id: "t1", at: hoursAgo(1), actor: "AI Assistant", action: "Grouped 3 new reports into issue", note: "Confidence 92%" },
  { id: "t2", at: hoursAgo(4), actor: "Officer M. Rao", action: "Marked under review" },
  { id: "t3", at: hoursAgo(12), actor: "Citizen", action: "Submitted new report" },
  { id: "t4", at: hoursAgo(30), actor: "Field Worker", action: "Uploaded progress evidence" },
  { id: "t5", at: hoursAgo(72), actor: "Department Head", action: "Assigned to Roads dept." },
];

export const FIELD_WORK: FieldWork[] = ISSUES.slice(0, 6).map((iss, i) => ({
  id: `FW-${500 + i}`,
  issueId: iss.id,
  title: iss.title,
  ward: iss.ward,
  category: iss.category,
  priority: iss.priority,
  due: hoursAgo(-((i + 1) * 24)),
  status: i % 3 === 0 ? "completed" : i % 3 === 1 ? "in_progress" : "assigned",
}));

export const STATUS_LABELS: Record<ReportStatus, string> = {
  pending: "Pending",
  under_review: "Under Review",
  assigned: "Assigned",
  in_progress: "In Progress",
  resolved: "Resolved",
  rejected: "Rejected",
};

export const PRIORITY_LABELS: Record<Priority, string> = {
  low: "Low",
  medium: "Medium",
  high: "High",
  critical: "Critical",
};
