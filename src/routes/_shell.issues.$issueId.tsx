import { createFileRoute, Link, notFound } from "@tanstack/react-router";
import { ArrowLeft, Image as ImageIcon, Sparkles, Building2, MapPin, AlertTriangle } from "lucide-react";
import { PageHeader } from "@/components/layout/PageHeader";
import { StatusBadge, PriorityBadge } from "@/components/StatusBadge";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Timeline } from "@/components/Timeline";
import { ISSUES, REPORTS, TIMELINE } from "@/lib/mock-data";
import { timeAgo } from "@/lib/format";

export const Route = createFileRoute("/_shell/issues/$issueId")({
  head: ({ params }) => ({ meta: [{ title: `${params.issueId} — Issue — CivicTrust` }] }),
  component: IssueDetailsPage,
});

function IssueDetailsPage() {
  const { issueId } = Route.useParams();
  const issue = ISSUES.find((i) => i.id === issueId);
  if (!issue) throw notFound();
  const linked = REPORTS.filter((r) => r.linkedIssueId === issue.id).slice(0, 6);

  return (
    <>
      <div>
        <Button asChild variant="ghost" size="sm" className="-ml-2 text-muted-foreground">
          <Link to="/issues"><ArrowLeft className="h-4 w-4" /> All issues</Link>
        </Button>
      </div>
      <PageHeader
        title={issue.title}
        description={`${issue.id} · ${issue.reportsCount} grouped reports · last updated ${timeAgo(issue.lastUpdated)}`}
        actions={
          <>
            <StatusBadge status={issue.status} />
            <PriorityBadge priority={issue.priority} />
            <Button asChild size="sm"><Link to="/assignments">Assign</Link></Button>
          </>
        }
      />

      <div className="grid grid-cols-1 gap-4 lg:grid-cols-3">
        <div className="space-y-4 lg:col-span-2">
          <Card>
            <CardHeader className="pb-3"><CardTitle className="text-base">Summary</CardTitle></CardHeader>
            <CardContent>
              <p className="text-sm leading-relaxed text-foreground">{issue.description}</p>
            </CardContent>
          </Card>

          <Card>
            <CardHeader className="flex flex-row items-center gap-2 pb-3">
              <Sparkles className="h-4 w-4 text-primary" />
              <CardTitle className="text-base">AI recommendation</CardTitle>
              <span className="ml-auto rounded-full bg-muted px-2 py-0.5 text-[10px] font-medium uppercase tracking-wide text-muted-foreground">Placeholder</span>
            </CardHeader>
            <CardContent>
              <p className="text-sm leading-relaxed text-muted-foreground">
                Recommended department, severity, SLA window and similar resolved cases will appear
                here. Officers always make the final decision.
              </p>
            </CardContent>
          </Card>

          <Card>
            <CardHeader className="pb-3"><CardTitle className="text-base">Linked reports ({linked.length || issue.reportsCount})</CardTitle></CardHeader>
            <CardContent className="space-y-2">
              {(linked.length ? linked : REPORTS.slice(0, 4)).map((r) => (
                <Link
                  key={r.id}
                  to="/reports/$reportId"
                  params={{ reportId: r.id }}
                  className="flex items-center justify-between rounded-lg border border-border p-3 hover:bg-muted/40"
                >
                  <div className="min-w-0">
                    <p className="truncate text-sm font-medium text-foreground">{r.id} · {r.source}</p>
                    <p className="truncate text-xs text-muted-foreground">{r.reporter} · {timeAgo(r.submittedAt)}</p>
                  </div>
                  <StatusBadge status={r.status} />
                </Link>
              ))}
            </CardContent>
          </Card>

          <Card>
            <CardHeader className="pb-3"><CardTitle className="text-base">Evidence gallery</CardTitle></CardHeader>
            <CardContent>
              <div className="grid grid-cols-4 gap-3">
                {Array.from({ length: 8 }).map((_, i) => (
                  <div key={i} className="grid aspect-square place-items-center rounded-lg border border-dashed border-border bg-muted/50 text-muted-foreground">
                    <ImageIcon className="h-5 w-5" />
                  </div>
                ))}
              </div>
            </CardContent>
          </Card>

          <Card>
            <CardHeader className="pb-3"><CardTitle className="text-base">Resolution</CardTitle></CardHeader>
            <CardContent className="space-y-3">
              <textarea
                className="min-h-[100px] w-full resize-none rounded-lg border border-border bg-background p-3 text-sm focus:outline-none focus:ring-2 focus:ring-ring"
                placeholder="Add a resolution note before closing this issue…"
              />
              <div className="flex justify-end gap-2">
                <Button variant="outline" size="sm">Save draft</Button>
                <Button size="sm">Mark resolved</Button>
              </div>
            </CardContent>
          </Card>
        </div>

        <div className="space-y-4">
          <Card>
            <CardHeader className="pb-3"><CardTitle className="text-base">Overview</CardTitle></CardHeader>
            <CardContent className="space-y-3 text-sm">
              <Row icon={Building2} label="Department" value={issue.department} />
              <Row label="Category" value={issue.category} />
              <Row icon={MapPin} label="Ward" value={issue.ward} />
              <Row icon={AlertTriangle} label="Priority" value={<PriorityBadge priority={issue.priority} />} />
              <Row label="Status" value={<StatusBadge status={issue.status} />} />
              <Row label="Reports" value={String(issue.reportsCount)} />
            </CardContent>
          </Card>

          <Card>
            <CardHeader className="pb-3"><CardTitle className="text-base">Timeline</CardTitle></CardHeader>
            <CardContent><Timeline events={TIMELINE} /></CardContent>
          </Card>
        </div>
      </div>
    </>
  );
}

function Row({ icon: Icon, label, value }: { icon?: React.ComponentType<{ className?: string }>; label: string; value: React.ReactNode }) {
  return (
    <div className="flex items-start justify-between gap-3">
      <div className="flex items-center gap-2 text-muted-foreground">{Icon && <Icon className="h-3.5 w-3.5" />}<span>{label}</span></div>
      <div className="text-right font-medium text-foreground">{value}</div>
    </div>
  );
}
