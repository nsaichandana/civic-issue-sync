import { createFileRoute } from "@tanstack/react-router";
import { ClipboardCheck } from "lucide-react";
import { PageHeader } from "@/components/layout/PageHeader";
import { PriorityBadge } from "@/components/StatusBadge";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Label } from "@/components/ui/label";
import { Input } from "@/components/ui/input";
import {
  Select, SelectContent, SelectItem, SelectTrigger, SelectValue,
} from "@/components/ui/select";
import { DEPARTMENTS, ISSUES, PRIORITIES, PRIORITY_LABELS } from "@/lib/mock-data";

export const Route = createFileRoute("/_shell/assignments")({
  head: () => ({ meta: [{ title: "Assignments — CivicTrust" }] }),
  component: AssignmentsPage,
});

const OFFICERS = ["M. Rao", "S. Iyer", "P. Banerjee", "A. Khan"];
const FIELD_WORKERS = ["Team Alpha", "Team Bravo", "R. Kumar", "N. Singh"];

function AssignmentsPage() {
  const unassigned = ISSUES.filter((i) => i.status === "pending" || i.status === "under_review").slice(0, 4);

  return (
    <>
      <PageHeader
        title="Assignments"
        description="Route issues to the right department, officer and field team."
      />

      <div className="grid grid-cols-1 gap-4 lg:grid-cols-3">
        <Card className="lg:col-span-2">
          <CardHeader className="pb-3"><CardTitle className="text-base">Assign an issue</CardTitle></CardHeader>
          <CardContent className="space-y-4">
            <Field label="Issue">
              <Select defaultValue={unassigned[0]?.id}>
                <SelectTrigger><SelectValue placeholder="Select issue" /></SelectTrigger>
                <SelectContent>
                  {ISSUES.slice(0, 12).map((i) => (
                    <SelectItem key={i.id} value={i.id}>{i.id} · {i.title}</SelectItem>
                  ))}
                </SelectContent>
              </Select>
            </Field>

            <div className="grid grid-cols-1 gap-4 sm:grid-cols-2">
              <Field label="Department">
                <Select><SelectTrigger><SelectValue placeholder="Choose department" /></SelectTrigger>
                  <SelectContent>{DEPARTMENTS.map((d) => <SelectItem key={d} value={d}>{d}</SelectItem>)}</SelectContent>
                </Select>
              </Field>
              <Field label="Officer">
                <Select><SelectTrigger><SelectValue placeholder="Assign officer" /></SelectTrigger>
                  <SelectContent>{OFFICERS.map((o) => <SelectItem key={o} value={o}>{o}</SelectItem>)}</SelectContent>
                </Select>
              </Field>
              <Field label="Field worker">
                <Select><SelectTrigger><SelectValue placeholder="Field team / worker" /></SelectTrigger>
                  <SelectContent>{FIELD_WORKERS.map((w) => <SelectItem key={w} value={w}>{w}</SelectItem>)}</SelectContent>
                </Select>
              </Field>
              <Field label="Priority">
                <Select defaultValue="high">
                  <SelectTrigger><SelectValue placeholder="Priority" /></SelectTrigger>
                  <SelectContent>{PRIORITIES.map((p) => <SelectItem key={p} value={p}>{PRIORITY_LABELS[p]}</SelectItem>)}</SelectContent>
                </Select>
              </Field>
              <Field label="Expected completion">
                <Input type="date" />
              </Field>
              <Field label="Notify">
                <Select defaultValue="email">
                  <SelectTrigger><SelectValue /></SelectTrigger>
                  <SelectContent>
                    <SelectItem value="email">Email</SelectItem>
                    <SelectItem value="sms">SMS</SelectItem>
                    <SelectItem value="both">Email + SMS</SelectItem>
                  </SelectContent>
                </Select>
              </Field>
            </div>

            <div className="flex justify-end gap-2 pt-2">
              <Button variant="outline">Save draft</Button>
              <Button><ClipboardCheck className="h-4 w-4" /> Assign</Button>
            </div>
          </CardContent>
        </Card>

        <Card>
          <CardHeader className="pb-3"><CardTitle className="text-base">Awaiting assignment</CardTitle></CardHeader>
          <CardContent className="space-y-2">
            {unassigned.map((i) => (
              <div key={i.id} className="rounded-lg border border-border p-3">
                <div className="flex items-start justify-between gap-2">
                  <p className="text-sm font-medium text-foreground">{i.id}</p>
                  <PriorityBadge priority={i.priority} />
                </div>
                <p className="mt-1 line-clamp-2 text-xs text-muted-foreground">{i.title}</p>
                <p className="mt-2 text-[11px] text-muted-foreground">{i.ward} · {i.category}</p>
              </div>
            ))}
          </CardContent>
        </Card>
      </div>
    </>
  );
}

function Field({ label, children }: { label: string; children: React.ReactNode }) {
  return (
    <div className="space-y-1.5">
      <Label className="text-xs font-medium text-muted-foreground">{label}</Label>
      {children}
    </div>
  );
}
