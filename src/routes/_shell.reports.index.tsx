import { createFileRoute, Link } from "@tanstack/react-router";
import { useMemo, useState } from "react";
import { Search, SlidersHorizontal, Download, ChevronLeft, ChevronRight } from "lucide-react";
import { PageHeader } from "@/components/layout/PageHeader";
import { StatusBadge } from "@/components/StatusBadge";
import { Card, CardContent } from "@/components/ui/card";
import { Input } from "@/components/ui/input";
import { Button } from "@/components/ui/button";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";
import { CATEGORIES, REPORTS, SOURCES, STATUS_LABELS, STATUSES } from "@/lib/mock-data";
import { timeAgo } from "@/lib/format";

export const Route = createFileRoute("/_shell/reports/")({
  head: () => ({ meta: [{ title: "Reports — CivicTrust" }] }),
  component: ReportsPage,
});

function ReportsPage() {
  const [q, setQ] = useState("");
  const [status, setStatus] = useState<string>("all");
  const [category, setCategory] = useState<string>("all");
  const [source, setSource] = useState<string>("all");
  const [page, setPage] = useState(1);
  const pageSize = 10;

  const filtered = useMemo(() => {
    return REPORTS.filter((r) => {
      if (status !== "all" && r.status !== status) return false;
      if (category !== "all" && r.category !== category) return false;
      if (source !== "all" && r.source !== source) return false;
      if (q && !`${r.id} ${r.category} ${r.ward} ${r.reporter}`.toLowerCase().includes(q.toLowerCase()))
        return false;
      return true;
    });
  }, [q, status, category, source]);

  const totalPages = Math.max(1, Math.ceil(filtered.length / pageSize));
  const current = filtered.slice((page - 1) * pageSize, page * pageSize);

  return (
    <>
      <PageHeader
        title="Reports"
        description="Every incoming report from citizens, wards, municipality and verified news."
        actions={
          <Button variant="outline" size="sm">
            <Download className="h-4 w-4" /> Export
          </Button>
        }
      />

      <Card>
        <CardContent className="space-y-4 p-4 md:p-5">
          <div className="grid grid-cols-1 gap-3 md:grid-cols-[1fr_auto_auto_auto_auto]">
            <div className="relative">
              <Search className="pointer-events-none absolute left-3 top-1/2 h-4 w-4 -translate-y-1/2 text-muted-foreground" />
              <Input
                placeholder="Search by ID, category, ward, reporter…"
                value={q}
                onChange={(e) => { setQ(e.target.value); setPage(1); }}
                className="pl-9"
              />
            </div>
            <FilterSelect value={status} onChange={(v) => { setStatus(v); setPage(1); }} placeholder="Status"
              options={[["all", "All statuses"], ...STATUSES.map((s) => [s, STATUS_LABELS[s]] as [string, string])]} />
            <FilterSelect value={category} onChange={(v) => { setCategory(v); setPage(1); }} placeholder="Category"
              options={[["all", "All categories"], ...CATEGORIES.map((c) => [c, c] as [string, string])]} />
            <FilterSelect value={source} onChange={(v) => { setSource(v); setPage(1); }} placeholder="Source"
              options={[["all", "All sources"], ...SOURCES.map((s) => [s, s] as [string, string])]} />
            <Button variant="outline" size="default" className="gap-2">
              <SlidersHorizontal className="h-4 w-4" /> More
            </Button>
          </div>

          <div className="-mx-4 overflow-x-auto md:-mx-5">
            <table className="w-full text-sm">
              <thead>
                <tr className="border-y border-border bg-muted/40 text-left text-xs uppercase tracking-wide text-muted-foreground">
                  <th className="px-5 py-2.5 font-medium">Report ID</th>
                  <th className="px-5 py-2.5 font-medium">Source</th>
                  <th className="px-5 py-2.5 font-medium">Category</th>
                  <th className="px-5 py-2.5 font-medium">Ward</th>
                  <th className="px-5 py-2.5 font-medium">Submitted</th>
                  <th className="px-5 py-2.5 font-medium">Status</th>
                </tr>
              </thead>
              <tbody>
                {current.map((r) => (
                  <tr key={r.id} className="border-b border-border/60 last:border-0 hover:bg-muted/30">
                    <td className="px-5 py-3">
                      <Link to="/reports/$reportId" params={{ reportId: r.id }} className="font-medium text-foreground hover:text-primary">
                        {r.id}
                      </Link>
                    </td>
                    <td className="px-5 py-3 text-muted-foreground">{r.source}</td>
                    <td className="px-5 py-3 text-muted-foreground">{r.category}</td>
                    <td className="px-5 py-3 text-muted-foreground">{r.ward}</td>
                    <td className="px-5 py-3 text-muted-foreground">{timeAgo(r.submittedAt)}</td>
                    <td className="px-5 py-3"><StatusBadge status={r.status} /></td>
                  </tr>
                ))}
                {current.length === 0 && (
                  <tr><td colSpan={6} className="px-5 py-10 text-center text-sm text-muted-foreground">No reports match your filters.</td></tr>
                )}
              </tbody>
            </table>
          </div>

          <div className="flex items-center justify-between pt-1">
            <p className="text-xs text-muted-foreground">
              Showing <span className="font-medium text-foreground">{current.length}</span> of{" "}
              <span className="font-medium text-foreground">{filtered.length}</span> reports
            </p>
            <div className="flex items-center gap-1">
              <Button variant="outline" size="icon" className="h-8 w-8" disabled={page === 1} onClick={() => setPage((p) => p - 1)}>
                <ChevronLeft className="h-4 w-4" />
              </Button>
              <span className="px-2 text-xs text-muted-foreground">Page {page} / {totalPages}</span>
              <Button variant="outline" size="icon" className="h-8 w-8" disabled={page === totalPages} onClick={() => setPage((p) => p + 1)}>
                <ChevronRight className="h-4 w-4" />
              </Button>
            </div>
          </div>
        </CardContent>
      </Card>
    </>
  );
}

function FilterSelect({
  value, onChange, placeholder, options,
}: {
  value: string; onChange: (v: string) => void; placeholder: string; options: [string, string][];
}) {
  return (
    <Select value={value} onValueChange={onChange}>
      <SelectTrigger className="min-w-[160px]"><SelectValue placeholder={placeholder} /></SelectTrigger>
      <SelectContent>
        {options.map(([v, l]) => <SelectItem key={v} value={v}>{l}</SelectItem>)}
      </SelectContent>
    </Select>
  );
}
