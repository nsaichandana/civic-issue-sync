import { createFileRoute, Link } from "@tanstack/react-router";
import { Camera, CheckCircle2, ExternalLink, MapPin } from "lucide-react";
import { PageHeader } from "@/components/layout/PageHeader";
import { PriorityBadge } from "@/components/StatusBadge";
import { Card, CardContent } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { FIELD_WORK } from "@/lib/mock-data";
import { timeAgo } from "@/lib/format";

export const Route = createFileRoute("/_shell/field-workers")({
  head: () => ({ meta: [{ title: "Field Workers — CivicTrust" }] }),
  component: FieldWorkerPortal,
});

const STATUS_STYLE: Record<string, string> = {
  assigned: "bg-[var(--color-status-assigned)] text-[var(--color-status-assigned-foreground)]",
  in_progress: "bg-[var(--color-status-progress)] text-[var(--color-status-progress-foreground)]",
  completed: "bg-[var(--color-status-resolved)] text-[var(--color-status-resolved-foreground)]",
};

function FieldWorkerPortal() {
  return (
    <>
      <PageHeader
        title="Field worker portal"
        description="Work assigned to you and your team. Upload progress and completion evidence from the field."
      />

      <div className="grid grid-cols-1 gap-4 md:grid-cols-2 xl:grid-cols-3">
        {FIELD_WORK.map((w) => (
          <Card key={w.id} className="overflow-hidden">
            <div className="grid aspect-[16/9] place-items-center bg-muted/50 text-muted-foreground">
              <MapPin className="h-6 w-6" />
            </div>
            <CardContent className="space-y-3 p-4">
              <div className="flex items-start justify-between gap-2">
                <div className="min-w-0">
                  <p className="text-xs text-muted-foreground">{w.id} · {w.category}</p>
                  <h3 className="mt-0.5 line-clamp-2 text-sm font-semibold text-foreground">{w.title}</h3>
                </div>
                <span className={`shrink-0 rounded-full px-2 py-0.5 text-[10px] font-medium uppercase tracking-wide ${STATUS_STYLE[w.status]}`}>
                  {w.status.replace("_", " ")}
                </span>
              </div>
              <div className="flex items-center justify-between text-xs text-muted-foreground">
                <span>{w.ward}</span>
                <PriorityBadge priority={w.priority} />
              </div>
              <p className="text-xs text-muted-foreground">Due {timeAgo(w.due)}</p>
              <div className="flex flex-wrap gap-2 pt-1">
                <Button size="sm" variant="outline" className="gap-1.5"><Camera className="h-3.5 w-3.5" /> Progress</Button>
                <Button size="sm" className="gap-1.5"><CheckCircle2 className="h-3.5 w-3.5" /> Completion</Button>
                <Button asChild size="sm" variant="ghost" className="ml-auto gap-1.5">
                  <Link to="/issues/$issueId" params={{ issueId: w.issueId }}>Details <ExternalLink className="h-3.5 w-3.5" /></Link>
                </Button>
              </div>
            </CardContent>
          </Card>
        ))}
      </div>
    </>
  );
}
