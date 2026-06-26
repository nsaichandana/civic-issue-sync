import type { LucideIcon } from "lucide-react";
import { Card, CardContent } from "@/components/ui/card";
import { cn } from "@/lib/utils";

interface StatsCardProps {
  label: string;
  value: string | number;
  delta?: string;
  trend?: "up" | "down" | "flat";
  icon: LucideIcon;
  tone?: "default" | "primary" | "accent" | "warning" | "danger";
}

const TONE: Record<NonNullable<StatsCardProps["tone"]>, string> = {
  default: "bg-muted text-muted-foreground",
  primary: "bg-[var(--color-status-review)] text-[var(--color-status-review-foreground)]",
  accent: "bg-[var(--color-status-resolved)] text-[var(--color-status-resolved-foreground)]",
  warning: "bg-[var(--color-status-pending)] text-[var(--color-status-pending-foreground)]",
  danger: "bg-[var(--color-status-rejected)] text-[var(--color-status-rejected-foreground)]",
};

export function StatsCard({ label, value, delta, trend = "flat", icon: Icon, tone = "default" }: StatsCardProps) {
  return (
    <Card className="border-border/70 shadow-sm">
      <CardContent className="p-5">
        <div className="flex items-start justify-between gap-3">
          <div className="min-w-0">
            <p className="text-xs font-medium uppercase tracking-wide text-muted-foreground">{label}</p>
            <p className="mt-2 text-2xl font-semibold tracking-tight text-foreground">{value}</p>
            {delta && (
              <p
                className={cn(
                  "mt-1 text-xs font-medium",
                  trend === "up" && "text-[var(--color-status-resolved-foreground)]",
                  trend === "down" && "text-[var(--color-status-rejected-foreground)]",
                  trend === "flat" && "text-muted-foreground",
                )}
              >
                {delta}
              </p>
            )}
          </div>
          <div className={cn("grid h-10 w-10 shrink-0 place-items-center rounded-xl", TONE[tone])}>
            <Icon className="h-5 w-5" />
          </div>
        </div>
      </CardContent>
    </Card>
  );
}
