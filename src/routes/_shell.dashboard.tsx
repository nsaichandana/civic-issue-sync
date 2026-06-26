import { createFileRoute, Link } from "@tanstack/react-router";
import {
  AlertOctagon,
  Clock,
  UserCheck,
  Loader2,
  CheckCircle2,
  Calendar,
  ArrowUpRight,
  Plus,
  FileText,
  ClipboardCheck,
  BarChart3,
} from "lucide-react";
import { PageHeader } from "@/components/layout/PageHeader";
import { StatsCard } from "@/components/StatsCard";
import { StatusBadge } from "@/components/StatusBadge";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Timeline } from "@/components/Timeline";
import { REPORTS, TIMELINE } from "@/lib/mock-data";
import { timeAgo } from "@/lib/format";

export const Route = createFileRoute("/_shell/dashboard")({
  head: () => ({
    meta: [{ title: "Dashboard — CivicTrust" }],
  }),
  component: DashboardPage,
});

function DashboardPage() {
  const recent = REPORTS.slice(0, 6);
  return (
    <>
      <PageHeader
        title="Good morning, Officer Rao"
        description="Here's what's happening across your wards today."
        actions={
          <>
            <Button variant="outline" size="sm">
              <Calendar className="h-4 w-4" /> Last 7 days
            </Button>
            <Button size="sm">
              <Plus className="h-4 w-4" /> New report
            </Button>
          </>
        }
      />

      <div className="grid grid-cols-1 gap-4 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-6">
        <StatsCard label="Total Issues" value="1,284" delta="+4.2%" trend="up" icon={AlertOctagon} tone="primary" />
        <StatsCard label="Pending Review" value="86" delta="+12 today" trend="up" icon={Clock} tone="warning" />
        <StatsCard label="Assigned" value="142" delta="−3 vs yesterday" trend="down" icon={UserCheck} tone="primary" />
        <StatsCard label="In Progress" value="97" delta="Stable" icon={Loader2} tone="default" />
        <StatsCard label="Resolved Today" value="38" delta="+8%" trend="up" icon={CheckCircle2} tone="accent" />
        <StatsCard label="Closed This Month" value="612" delta="+22%" trend="up" icon={CheckCircle2} tone="accent" />
      </div>

      <div className="grid grid-cols-1 gap-4 lg:grid-cols-3">
        <Card className="lg:col-span-2">
          <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-3">
            <CardTitle className="text-base">Resolution trends</CardTitle>
            <Button variant="ghost" size="sm" className="text-xs text-muted-foreground">
              Last 30 days <ArrowUpRight className="h-3.5 w-3.5" />
            </Button>
          </CardHeader>
          <CardContent>
            <ChartPlaceholder />
          </CardContent>
        </Card>

        <Card>
          <CardHeader className="pb-3">
            <CardTitle className="text-base">Quick actions</CardTitle>
          </CardHeader>
          <CardContent className="space-y-2">
            <QuickAction to="/reports" icon={FileText} label="Review new reports" sub="86 pending" />
            <QuickAction to="/assignments" icon={ClipboardCheck} label="Assign issues" sub="14 unassigned" />
            <QuickAction to="/analytics" icon={BarChart3} label="View ward analytics" sub="24 wards" />
          </CardContent>
        </Card>
      </div>

      <div className="grid grid-cols-1 gap-4 lg:grid-cols-3">
        <Card className="lg:col-span-2">
          <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-3">
            <CardTitle className="text-base">Recent reports</CardTitle>
            <Button asChild variant="ghost" size="sm" className="text-xs">
              <Link to="/reports">View all</Link>
            </Button>
          </CardHeader>
          <CardContent className="px-0">
            <div className="overflow-x-auto">
              <table className="w-full text-sm">
                <thead>
                  <tr className="border-b border-border text-left text-xs uppercase tracking-wide text-muted-foreground">
                    <th className="px-6 py-2.5 font-medium">ID</th>
                    <th className="px-6 py-2.5 font-medium">Category</th>
                    <th className="px-6 py-2.5 font-medium">Ward</th>
                    <th className="px-6 py-2.5 font-medium">Status</th>
                    <th className="px-6 py-2.5 font-medium">Submitted</th>
                  </tr>
                </thead>
                <tbody>
                  {recent.map((r) => (
                    <tr key={r.id} className="border-b border-border/60 last:border-0 hover:bg-muted/40">
                      <td className="px-6 py-3 font-medium text-foreground">{r.id}</td>
                      <td className="px-6 py-3 text-muted-foreground">{r.category}</td>
                      <td className="px-6 py-3 text-muted-foreground">{r.ward}</td>
                      <td className="px-6 py-3"><StatusBadge status={r.status} /></td>
                      <td className="px-6 py-3 text-muted-foreground">{timeAgo(r.submittedAt)}</td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          </CardContent>
        </Card>

        <Card>
          <CardHeader className="pb-3">
            <CardTitle className="text-base">Activity</CardTitle>
          </CardHeader>
          <CardContent>
            <Timeline events={TIMELINE} />
          </CardContent>
        </Card>
      </div>
    </>
  );
}

function QuickAction({
  to,
  icon: Icon,
  label,
  sub,
}: {
  to: string;
  icon: React.ComponentType<{ className?: string }>;
  label: string;
  sub: string;
}) {
  return (
    <Link
      to={to}
      className="group flex items-center justify-between rounded-lg border border-border bg-card p-3 transition-colors hover:bg-muted/60"
    >
      <div className="flex min-w-0 items-center gap-3">
        <div className="grid h-9 w-9 shrink-0 place-items-center rounded-lg bg-muted text-foreground">
          <Icon className="h-4 w-4" />
        </div>
        <div className="min-w-0">
          <p className="truncate text-sm font-medium text-foreground">{label}</p>
          <p className="truncate text-xs text-muted-foreground">{sub}</p>
        </div>
      </div>
      <ArrowUpRight className="h-4 w-4 text-muted-foreground transition group-hover:text-foreground" />
    </Link>
  );
}

function ChartPlaceholder() {
  const bars = [42, 58, 49, 71, 64, 80, 73, 88, 76, 92, 84, 95];
  return (
    <div className="flex h-56 items-end gap-2 px-1">
      {bars.map((h, i) => (
        <div key={i} className="flex flex-1 flex-col items-center gap-1.5">
          <div
            className="w-full rounded-md bg-gradient-to-t from-primary/70 to-primary/30"
            style={{ height: `${h}%` }}
          />
          <span className="text-[10px] text-muted-foreground">{`W${i + 1}`}</span>
        </div>
      ))}
    </div>
  );
}
