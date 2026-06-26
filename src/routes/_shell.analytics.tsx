import { createFileRoute } from "@tanstack/react-router";
import { Map as MapIcon, TrendingUp, Building2, Layers } from "lucide-react";
import { PageHeader } from "@/components/layout/PageHeader";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { CATEGORIES, DEPARTMENTS, WARDS } from "@/lib/mock-data";

export const Route = createFileRoute("/_shell/analytics")({
  head: () => ({ meta: [{ title: "Analytics — CivicTrust" }] }),
  component: AnalyticsPage,
});

function AnalyticsPage() {
  return (
    <>
      <PageHeader title="Analytics" description="Operational health across wards and departments." />

      <div className="grid grid-cols-1 gap-4 lg:grid-cols-2">
        <Card>
          <CardHeader className="pb-3"><CardTitle className="flex items-center gap-2 text-base"><Layers className="h-4 w-4 text-primary" /> Issues by category</CardTitle></CardHeader>
          <CardContent className="space-y-2.5">
            {CATEGORIES.map((c, i) => {
              const v = [82, 64, 48, 39, 27][i] ?? 30;
              return (
                <div key={c}>
                  <div className="mb-1 flex items-center justify-between text-xs">
                    <span className="text-muted-foreground">{c}</span>
                    <span className="font-medium text-foreground">{v * 4}</span>
                  </div>
                  <div className="h-2 w-full overflow-hidden rounded-full bg-muted">
                    <div className="h-full rounded-full bg-primary" style={{ width: `${v}%` }} />
                  </div>
                </div>
              );
            })}
          </CardContent>
        </Card>

        <Card>
          <CardHeader className="pb-3"><CardTitle className="flex items-center gap-2 text-base"><Building2 className="h-4 w-4 text-primary" /> Department performance</CardTitle></CardHeader>
          <CardContent className="space-y-2.5">
            {DEPARTMENTS.map((d, i) => {
              const v = [88, 72, 64, 79][i] ?? 60;
              return (
                <div key={d}>
                  <div className="mb-1 flex items-center justify-between text-xs">
                    <span className="text-muted-foreground">{d}</span>
                    <span className="font-medium text-foreground">{v}% on-time</span>
                  </div>
                  <div className="h-2 w-full overflow-hidden rounded-full bg-muted">
                    <div className="h-full rounded-full bg-accent" style={{ width: `${v}%` }} />
                  </div>
                </div>
              );
            })}
          </CardContent>
        </Card>

        <Card className="lg:col-span-2">
          <CardHeader className="pb-3"><CardTitle className="flex items-center gap-2 text-base"><TrendingUp className="h-4 w-4 text-primary" /> Resolution trends</CardTitle></CardHeader>
          <CardContent>
            <div className="flex h-56 items-end gap-2">
              {[40, 48, 52, 47, 60, 64, 71, 68, 76, 82, 88, 95].map((h, i) => (
                <div key={i} className="flex flex-1 flex-col items-center gap-1.5">
                  <div className="w-full rounded-md bg-gradient-to-t from-primary/70 to-primary/30" style={{ height: `${h}%` }} />
                  <span className="text-[10px] text-muted-foreground">M{i + 1}</span>
                </div>
              ))}
            </div>
          </CardContent>
        </Card>

        <Card>
          <CardHeader className="pb-3"><CardTitle className="text-base">Ward performance</CardTitle></CardHeader>
          <CardContent className="space-y-2">
            {WARDS.slice(0, 6).map((w, i) => (
              <div key={w} className="flex items-center justify-between rounded-lg border border-border px-3 py-2 text-sm">
                <span className="font-medium text-foreground">{w}</span>
                <span className="text-muted-foreground">{[92, 86, 81, 78, 74, 69][i]}% SLA</span>
              </div>
            ))}
          </CardContent>
        </Card>

        <Card>
          <CardHeader className="pb-3"><CardTitle className="flex items-center gap-2 text-base"><MapIcon className="h-4 w-4 text-primary" /> Hotspot map</CardTitle></CardHeader>
          <CardContent>
            <div className="grid aspect-[4/3] place-items-center rounded-lg border border-dashed border-border bg-muted/40 text-center text-sm text-muted-foreground">
              <div>
                <MapIcon className="mx-auto h-8 w-8 opacity-60" />
                <p className="mt-2">Map view connects when Google Maps is enabled.</p>
              </div>
            </div>
          </CardContent>
        </Card>

        <Card className="lg:col-span-2">
          <CardHeader className="pb-3"><CardTitle className="text-base">SLA overview</CardTitle></CardHeader>
          <CardContent>
            <div className="grid grid-cols-1 gap-4 sm:grid-cols-4">
              {[
                ["On-time", "82%", "text-[var(--color-status-resolved-foreground)]"],
                ["At risk", "11%", "text-[var(--color-status-pending-foreground)]"],
                ["Breached", "7%", "text-[var(--color-status-rejected-foreground)]"],
                ["Avg resolution", "3.4d", "text-foreground"],
              ].map(([l, v, c]) => (
                <div key={l} className="rounded-xl border border-border p-4">
                  <p className="text-xs text-muted-foreground">{l}</p>
                  <p className={`mt-1 text-2xl font-semibold ${c}`}>{v}</p>
                </div>
              ))}
            </div>
          </CardContent>
        </Card>
      </div>
    </>
  );
}
