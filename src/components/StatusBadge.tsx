import type { Priority, ReportStatus } from "@/types";
import { STATUS_LABELS, PRIORITY_LABELS } from "@/lib/mock-data";
import { cn } from "@/lib/utils";

const STATUS_CLASSES: Record<ReportStatus, string> = {
  pending: "bg-[var(--color-status-pending)] text-[var(--color-status-pending-foreground)]",
  under_review: "bg-[var(--color-status-review)] text-[var(--color-status-review-foreground)]",
  assigned: "bg-[var(--color-status-assigned)] text-[var(--color-status-assigned-foreground)]",
  in_progress: "bg-[var(--color-status-progress)] text-[var(--color-status-progress-foreground)]",
  resolved: "bg-[var(--color-status-resolved)] text-[var(--color-status-resolved-foreground)]",
  rejected: "bg-[var(--color-status-rejected)] text-[var(--color-status-rejected-foreground)]",
};

export function StatusBadge({
  status,
  className,
}: {
  status: string;
  className?: string;
}) {
  const normalizedStatus = (status ?? "").toLowerCase() as ReportStatus;
  return (
    <span
      className={cn(
        "inline-flex items-center gap-1.5 rounded-full px-2.5 py-0.5 text-xs font-medium",
        STATUS_CLASSES[normalizedStatus],
        className,
      )}
    >
      <span className="h-1.5 w-1.5 rounded-full bg-current opacity-70" />
      {STATUS_LABELS[normalizedStatus] ?? status}
    </span>
  );
}

const PRIORITY_CLASSES: Record<Priority, string> = {
  low: "bg-muted text-muted-foreground",
  medium: "bg-[var(--color-status-review)] text-[var(--color-status-review-foreground)]",
  high: "bg-[var(--color-status-pending)] text-[var(--color-status-pending-foreground)]",
  critical: "bg-[var(--color-status-rejected)] text-[var(--color-status-rejected-foreground)]",
};

export function PriorityBadge({
  priority,
  className,
}: {
  priority: string;
  className?: string;
}) {
  const normalizedPriority = (priority ?? "").toLowerCase() as Priority;
  return (
    <span
      className={cn(
        "inline-flex items-center rounded-md px-2 py-0.5 text-xs font-medium",
        PRIORITY_CLASSES[normalizedPriority],
        className,
      )}
    >
      {PRIORITY_LABELS[normalizedPriority] ?? priority}
    </span>
  );
}
