import { createFileRoute, Link } from "@tanstack/react-router";
import { useMemo, useState } from "react";
import { Search, Filter, Plus } from "lucide-react";
import { PageHeader } from "@/components/layout/PageHeader";
import { StatusBadge, PriorityBadge } from "@/components/StatusBadge";
import { Card, CardContent } from "@/components/ui/card";
import { Input } from "@/components/ui/input";
import { Button } from "@/components/ui/button";
import {
  Select, SelectContent, SelectItem, SelectTrigger, SelectValue,
} from "@/components/ui/select";
import { DEPARTMENTS, ISSUES, STATUSES, STATUS_LABELS } from "@/lib/mock-data";
import { timeAgo } from "@/lib/format";

export const Route = createFileRoute("/_shell/issues/")({
  head: () => ({ meta: [{ title: "Issues — CivicTrust" }] }),
  component: IssuesPage,
});

function IssuesPage() {
  const [q, setQ] = useState("");
  const [status, setStatus] = useState("all");
  const [dept, setDept] = useState("all");

  const filtered = useMemo(() => {
    return ISSUES.filter((i) => {
      if (status !== "all" && i.status !== status) return false;
      if (dept !== "all" && i.department !== dept) return false;
      if (q && !`${i.id} ${i.title} ${i.ward}`.toLowerCase().includes(q.toLowerCase())) return false;
      return true;
    });
  }, [q, status, dept]);

  return (
    <>
      <PageHeader
        title="Issues"
        description="AI-grouped issues across all wards. Each issue may contain multiple linked reports."
        actions={<Button size="sm"><Plus className="h-4 w-4" /> New issue</Button>}
      />

      <Card>
        <CardContent className="space-y-4 p-4 md:p-5">
          <div className="grid grid-cols-1 gap-3 md:grid-cols-[1fr_auto_auto_auto]">
            <div className="relative">
              <Search className="pointer-events-none absolute left-3 top-1/2 h-4 w-4 -translate-y-1/2 text-muted-foreground" />
              <Input value={q} onChange={(e) => setQ(e.target.value)} placeholder="Search issues, wards…" className="pl-9" />
            </div>
            <Select value={status} onValueChange={setStatus}>
              <SelectTrigger className="min-w-[160px]"><SelectValue placeholder="Status" /></SelectTrigger>
              <SelectContent>
                <SelectItem value="all">All statuses</SelectItem>
                {STATUSES.map((s) => <SelectItem key={s} value={s}>{STATUS_LABELS[s]}</SelectItem>)}
              </SelectContent>
            </Select>
            <Select value={dept} onValueChange={setDept}>
              <SelectTrigger className="min-w-[160px]"><SelectValue placeholder="Department" /></SelectTrigger>
              <SelectContent>
                <SelectItem value="all">All departments</SelectItem>
                {DEPARTMENTS.map((d) => <SelectItem key={d} value={d}>{d}</SelectItem>)}
              </SelectContent>
            </Select>
            <Button variant="outline"><Filter className="h-4 w-4" /> Filters</Button>
          </div>

          <div className="-mx-4 overflow-x-auto md:-mx-5">
            <table className="w-full text-sm">
              <thead>
                <tr className="border-y border-border bg-muted/40 text-left text-xs uppercase tracking-wide text-muted-foreground">
                  <th className="px-5 py-2.5 font-medium">Issue</th>
                  <th className="px-5 py-2.5 font-medium">Category</th>
                  <th className="px-5 py-2.5 font-medium">Ward</th>
                  <th className="px-5 py-2.5 font-medium">Department</th>
                  <th className="px-5 py-2.5 font-medium">Priority</th>
                  <th className="px-5 py-2.5 font-medium">Status</th>
                  <th className="px-5 py-2.5 font-medium text-right">Reports</th>
                  <th className="px-5 py-2.5 font-medium">Updated</th>
                </tr>
              </thead>
              <tbody>
                {filtered.map((i) => (
                  <tr key={i.id} className="border-b border-border/60 last:border-0 hover:bg-muted/30">
                    <td className="px-5 py-3">
                      <Link to="/issues/$issueId" params={{ issueId: i.id }} className="font-medium text-foreground hover:text-primary">
                        {i.id}
                      </Link>
                      <p className="max-w-[280px] truncate text-xs text-muted-foreground">{i.title}</p>
                    </td>
                    <td className="px-5 py-3 text-muted-foreground">{i.category}</td>
                    <td className="px-5 py-3 text-muted-foreground">{i.ward}</td>
                    <td className="px-5 py-3 text-muted-foreground">{i.department}</td>
                    <td className="px-5 py-3"><PriorityBadge priority={i.priority} /></td>
                    <td className="px-5 py-3"><StatusBadge status={i.status} /></td>
                    <td className="px-5 py-3 text-right font-medium text-foreground">{i.reportsCount}</td>
                    <td className="px-5 py-3 text-muted-foreground">{timeAgo(i.lastUpdated)}</td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </CardContent>
      </Card>
    </>
  );
}
