import { createFileRoute, Link, notFound } from "@tanstack/react-router";
import { ArrowLeft, Image as ImageIcon, MapPin, Sparkles, User, GitMerge } from "lucide-react";
import { PageHeader } from "@/components/layout/PageHeader";
import { StatusBadge } from "@/components/StatusBadge";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Timeline } from "@/components/Timeline";
import { REPORTS, TIMELINE } from "@/lib/mock-data";
import { timeAgo } from "@/lib/format";

export const Route = createFileRoute("/_shell/reports/$reportId")({
  head: ({ params }) => ({ meta: [{ title: `${params.reportId} — Report — CivicTrust` }] }),
  component: ReportDetailsPage,
});

function ReportDetailsPage() {
  const { reportId } = Route.useParams();
  const report = REPORTS.find((r) => r.id === reportId);
  if (!report) throw notFound();

  return (
    <>
      <div>
        <Button asChild variant="ghost" size="sm" className="-ml-2 text-muted-foreground">
          <Link to="/reports"><ArrowLeft className="h-4 w-4" /> All reports</Link>
        </Button>
      </div>
      <PageHeader
        title={`${report.category} · ${report.id}`}
        description={`Reported by ${report.reporter} via ${report.source}`}
        actions={
          <>
            <StatusBadge status={report.status} />
            <Button size="sm" variant="outline">Reject</Button>
            <Button size="sm">Approve & merge</Button>
          </>
        }
      />

      <div className="grid grid-cols-1 gap-4 lg:grid-cols-3">
        <div className="space-y-4 lg:col-span-2">
          <Card>
            <CardHeader className="pb-3"><CardTitle className="text-base">Evidence</CardTitle></CardHeader>
            <CardContent>
              <div className="grid grid-cols-3 gap-3">
                {[1, 2, 3].map((i) => (
                  <div key={i} className="grid aspect-[4/3] place-items-center rounded-lg border border-dashed border-border bg-muted/50 text-muted-foreground">
                    <ImageIcon className="h-6 w-6" />
                  </div>
                ))}
              </div>
            </CardContent>
          </Card>

          <Card>
            <CardHeader className="pb-3"><CardTitle className="text-base">Description</CardTitle></CardHeader>
            <CardContent>
              <p className="text-sm leading-relaxed text-foreground">{report.description}</p>
            </CardContent>
          </Card>

          <Card>
            <CardHeader className="flex flex-row items-center gap-2 pb-3">
              <Sparkles className="h-4 w-4 text-primary" />
              <CardTitle className="text-base">AI summary</CardTitle>
              <span className="ml-auto rounded-full bg-muted px-2 py-0.5 text-[10px] font-medium uppercase tracking-wide text-muted-foreground">Placeholder</span>
            </CardHeader>
            <CardContent>
              <p className="text-sm leading-relaxed text-muted-foreground">
                AI will summarize key facts, severity hints and likely category here once the
                backend is connected.
              </p>
            </CardContent>
          </Card>

          <Card>
            <CardHeader className="flex flex-row items-center gap-2 pb-3">
              <GitMerge className="h-4 w-4 text-primary" />
              <CardTitle className="text-base">Duplicate suggestions</CardTitle>
              <span className="ml-auto rounded-full bg-muted px-2 py-0.5 text-[10px] font-medium uppercase tracking-wide text-muted-foreground">Placeholder</span>
            </CardHeader>
            <CardContent className="space-y-2">
              {REPORTS.slice(1, 4).map((r) => (
                <div key={r.id} className="flex items-center justify-between rounded-lg border border-border p-3">
                  <div className="min-w-0">
                    <p className="truncate text-sm font-medium text-foreground">{r.id} · {r.category}</p>
                    <p className="truncate text-xs text-muted-foreground">{r.ward} · {timeAgo(r.submittedAt)}</p>
                  </div>
                  <Button variant="outline" size="sm">Merge</Button>
                </div>
              ))}
            </CardContent>
          </Card>
        </div>

        <div className="space-y-4">
          <Card>
            <CardHeader className="pb-3"><CardTitle className="text-base">Details</CardTitle></CardHeader>
            <CardContent className="space-y-3 text-sm">
              <Row icon={User} label="Reporter" value={report.reporter} />
              <Row label="Source" value={report.source} />
              <Row label="Ward" value={report.ward} />
              <Row label="Category" value={report.category} />
              <Row icon={MapPin} label="Location" value={report.location} />
              <Row label="Submitted" value={timeAgo(report.submittedAt)} />
              {report.linkedIssueId && (
                <Row label="Linked issue" value={
                  <Link to="/issues/$issueId" params={{ issueId: report.linkedIssueId }} className="text-primary hover:underline">
                    {report.linkedIssueId}
                  </Link>
                } />
              )}
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
      <div className="flex items-center gap-2 text-muted-foreground">
        {Icon && <Icon className="h-3.5 w-3.5" />}<span>{label}</span>
      </div>
      <div className="text-right font-medium text-foreground">{value}</div>
    </div>
  );
}
