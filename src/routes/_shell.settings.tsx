import { createFileRoute } from "@tanstack/react-router";
import { useState } from "react";
import { PageHeader } from "@/components/layout/PageHeader";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Button } from "@/components/ui/button";
import { Switch } from "@/components/ui/switch";
import { cn } from "@/lib/utils";

export const Route = createFileRoute("/_shell/settings")({
  head: () => ({ meta: [{ title: "Settings — CivicTrust" }] }),
  component: SettingsPage,
});

const TABS = ["Profile", "Notifications", "Appearance", "About"] as const;
type Tab = (typeof TABS)[number];

function SettingsPage() {
  const [tab, setTab] = useState<Tab>("Profile");
  return (
    <>
      <PageHeader title="Settings" description="Manage your profile, notifications and workspace preferences." />

      <div className="grid grid-cols-1 gap-6 md:grid-cols-[200px_1fr]">
        <nav className="flex flex-row gap-1 overflow-x-auto md:flex-col">
          {TABS.map((t) => (
            <button
              key={t}
              onClick={() => setTab(t)}
              className={cn(
                "rounded-lg px-3 py-2 text-left text-sm transition-colors",
                tab === t ? "bg-muted font-medium text-foreground" : "text-muted-foreground hover:bg-muted/60",
              )}
            >
              {t}
            </button>
          ))}
        </nav>

        <div className="space-y-4">
          {tab === "Profile" && (
            <Card>
              <CardHeader className="pb-3"><CardTitle className="text-base">Profile</CardTitle></CardHeader>
              <CardContent className="space-y-4">
                <div className="grid gap-4 sm:grid-cols-2">
                  <Row label="Full name"><Input defaultValue="M. Rao" /></Row>
                  <Row label="Role"><Input defaultValue="Officer · Roads" /></Row>
                  <Row label="Email"><Input type="email" defaultValue="m.rao@city.gov" /></Row>
                  <Row label="Phone"><Input defaultValue="+91 98xxxxxx12" /></Row>
                </div>
                <div className="flex justify-end"><Button>Save changes</Button></div>
              </CardContent>
            </Card>
          )}

          {tab === "Notifications" && (
            <Card>
              <CardHeader className="pb-3"><CardTitle className="text-base">Notifications</CardTitle></CardHeader>
              <CardContent className="space-y-4">
                <Toggle label="New reports in my wards" defaultChecked />
                <Toggle label="Issue assigned to me" defaultChecked />
                <Toggle label="SLA breach warnings" defaultChecked />
                <Toggle label="Weekly performance digest" />
              </CardContent>
            </Card>
          )}

          {tab === "Appearance" && (
            <Card>
              <CardHeader className="pb-3"><CardTitle className="text-base">Appearance</CardTitle></CardHeader>
              <CardContent className="space-y-4">
                <p className="text-sm text-muted-foreground">Theme and density controls will live here.</p>
                <Toggle label="Compact tables" />
                <Toggle label="Reduce motion" />
              </CardContent>
            </Card>
          )}

          {tab === "About" && (
            <Card>
              <CardHeader className="pb-3"><CardTitle className="text-base">About CivicTrust</CardTitle></CardHeader>
              <CardContent className="space-y-2 text-sm text-muted-foreground">
                <p>Version 1.0.0 · Sprint 1 frontend foundation.</p>
                <p>CivicTrust is built to help municipalities resolve community issues faster by intelligently grouping trusted reports.</p>
              </CardContent>
            </Card>
          )}
        </div>
      </div>
    </>
  );
}

function Row({ label, children }: { label: string; children: React.ReactNode }) {
  return (
    <div className="space-y-1.5">
      <Label className="text-xs font-medium text-muted-foreground">{label}</Label>
      {children}
    </div>
  );
}

function Toggle({ label, defaultChecked }: { label: string; defaultChecked?: boolean }) {
  return (
    <div className="flex items-center justify-between rounded-lg border border-border p-3">
      <span className="text-sm text-foreground">{label}</span>
      <Switch defaultChecked={defaultChecked} />
    </div>
  );
}
