import { createFileRoute, Link, notFound } from "@tanstack/react-router";
import { useEffect, useState } from "react";
import {
  MapPin,
  Sparkles,
  GitMerge,
  Image as ImageIcon,
  FileText,
  Link as LinkIcon,
  Download,
  ExternalLink,
  Navigation,
  MessageSquarePlus,
  ShieldCheck,
  CheckCircle2,
  XCircle,
  Layers,
  UserPlus,
  AlertTriangle,
  ClipboardList,
  Bot,
  UserCircle2,
  History,
  Circle,
  Send,
  ChevronRight,
  Newspaper,
  Camera,
} from "lucide-react";
import { PageHeader } from "@/components/layout/PageHeader";
import { StatusBadge, PriorityBadge } from "@/components/StatusBadge";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { timeAgo } from "@/lib/format";
import { getReportById } from "@/services/reports/reports.service";

export const Route = createFileRoute("/_shell/reports/$reportId")({
  head: ({ params }) => ({ meta: [{ title: `Report ${params.reportId.slice(0, 8)} — CivicTrust` }] }),
  component: ReportDetailsPage,
});

type ReportRow = Awaited<ReturnType<typeof getReportById>>;

function ReportDetailsPage() {
  const { reportId } = Route.useParams();
  const [report, setReport] = useState<ReportRow | null>(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    let active = true;
    setLoading(true);
    getReportById(reportId).then((data) => {
      if (!active) return;
      setReport(data);
      setLoading(false);
    });
    return () => {
      active = false;
    };
  }, [reportId]);

  if (loading) {
    return <ReportSkeleton />;
  }

  if (!report) {
    throw notFound();
  }

  const category = (report as any).categories?.category_name ?? "Uncategorized";
  const ward = (report as any).wards?.ward_name ?? "—";
  const location = Array.isArray((report as any).report_location)
    ? (report as any).report_location[0]
    : (report as any).report_location;
  const media: MediaItem[] = Array.isArray((report as any).report_media) ? (report as any).report_media : [];
  const analysis = Array.isArray((report as any).ai_analysis)
    ? (report as any).ai_analysis[0]
    : (report as any).ai_analysis;
  const duplicates: DuplicateItem[] = analysis?.duplicate_candidates ?? [];

  const reporterLabel = report.is_anonymous ? "Anonymous citizen" : "Verified citizen";
  const shortId = report.id.slice(0, 8).toUpperCase();

  return (
    <>
      {/* Breadcrumb */}
      <nav aria-label="Breadcrumb" className="flex items-center gap-1 text-xs text-muted-foreground">
        <Link to="/dashboard" className="hover:text-foreground">Dashboard</Link>
        <ChevronRight className="h-3 w-3" />
        <Link to="/reports" className="hover:text-foreground">Reports</Link>
        <ChevronRight className="h-3 w-3" />
        <span className="font-medium text-foreground">Report #{shortId}</span>
      </nav>

      <PageHeader
        title={report.title}
        description={`Submitted ${timeAgo(report.submitted_at)} · Last updated ${timeAgo(report.updated_at)}`}
        actions={
          <>
            <StatusBadge status={report.status ?? "pending"} />
            <Button size="sm" variant="outline" className="hidden sm:inline-flex">
              <XCircle className="h-4 w-4" /> Reject
            </Button>
            <Button size="sm">
              <CheckCircle2 className="h-4 w-4" /> Approve
            </Button>
          </>
        }
      />

      {/* Metadata chips */}
      <MetaChips
        items={[
          { label: "Report #", value: shortId },
          { label: "Ward", value: ward },
          { label: "Category", value: category },
          { label: "Channel", value: report.source ?? "—" },
          { label: "AI Status", value: analysis ? "Completed" : "Pending" },
          { label: "Linked Issue", value: "Not linked" },
          { label: "Submitted", value: new Date(report.submitted_at).toLocaleDateString() },
          { label: "Updated", value: timeAgo(report.updated_at) },
        ]}
      />

      {/* Report Identity Card */}
      <Card>
        <CardContent className="grid grid-cols-2 gap-x-4 gap-y-3 py-4 md:grid-cols-4 lg:grid-cols-7">
          <IdentityItem label="Report Number" value={`#${shortId}`} />
          <IdentityItem
            label="Verification"
            value={
              report.is_anonymous ? (
                <span className="text-muted-foreground">Anonymous</span>
              ) : (
                <span className="inline-flex items-center gap-1 text-foreground">
                  <ShieldCheck className="h-3.5 w-3.5 text-primary" /> Verified
                </span>
              )
            }
          />
          <IdentityItem label="Source" value={report.source ?? "—"} />
          <IdentityItem label="Created" value={new Date(report.created_at).toLocaleDateString()} />
          <IdentityItem label="Last Updated" value={timeAgo(report.updated_at)} />
          <IdentityItem
            label="AI Confidence"
            value={
              analysis?.confidence_score != null
                ? `${Number(analysis.confidence_score).toFixed(0)}%`
                : "—"
            }
          />
          <IdentityItem
            label="Duplicate Score"
            value={
              analysis?.duplicate_score != null
                ? `${Number(analysis.duplicate_score).toFixed(0)}%`
                : "—"
            }
          />
        </CardContent>
      </Card>

      <div className="grid grid-cols-1 gap-4 lg:grid-cols-12">
        {/* LEFT — 8 cols */}
        <div className="space-y-4 lg:col-span-8">
          {/* 1. Citizen Submission */}
          <Card>
            <CardHeader className="pb-2">
              <div className="flex items-center justify-between gap-2">
                <CardTitle className="text-base">Citizen Submission</CardTitle>
                <ReadOnlyTag />
              </div>
            </CardHeader>
            <CardContent className="space-y-3">
              <div>
                <p className="text-xs font-medium uppercase tracking-wide text-muted-foreground">Title</p>
                <p className="mt-0.5 text-sm font-medium text-foreground">{report.title}</p>
              </div>
              <div>
                <p className="text-xs font-medium uppercase tracking-wide text-muted-foreground">Description</p>
                <p className="mt-0.5 whitespace-pre-wrap text-sm leading-relaxed text-foreground">
                  {report.description}
                </p>
              </div>
              <dl className="grid grid-cols-2 gap-x-4 gap-y-2 border-t border-border pt-3 text-sm md:grid-cols-4">
                <MetaField label="Reporter" value={reporterLabel} />
                <MetaField label="Submitted" value={new Date(report.submitted_at).toLocaleString()} />
                <MetaField label="Language" value="English" />
                <MetaField label="Verifications" value={String(report.upvote_count ?? 0)} />
              </dl>
            </CardContent>
          </Card>

          {/* 2. Location */}
          <Card>
            <CardHeader className="pb-2">
              <CardTitle className="flex items-center gap-2 text-base">
                <MapPin className="h-4 w-4 text-primary" /> Location
              </CardTitle>
            </CardHeader>
            <CardContent className="space-y-3">
              <dl className="grid grid-cols-2 gap-x-4 gap-y-2 text-sm md:grid-cols-3">
                <MetaField label="Ward" value={ward} />
                <MetaField
                  label="GPS Coordinates"
                  value={
                    location
                      ? `${Number(location.latitude).toFixed(5)}, ${Number(location.longitude).toFixed(5)}`
                      : "—"
                  }
                />
                <MetaField label="Landmark" value={location?.landmark || "—"} />
                <MetaField label="Address" value={location?.address || "—"} />
                <MetaField
                  label="Accuracy"
                  value={location?.accuracy != null ? `±${Number(location.accuracy).toFixed(0)} m` : "—"}
                />
              </dl>

              <div className="relative overflow-hidden rounded-lg border border-dashed border-border bg-muted/30">
                <div className="grid aspect-[16/7] place-items-center text-center text-xs text-muted-foreground">
                  <div>
                    <MapPin className="mx-auto h-6 w-6" />
                    <p className="mt-1">Interactive map placeholder</p>
                  </div>
                </div>
              </div>

              <div className="flex justify-end">
                <Button variant="outline" size="sm" asChild disabled={!location}>
                  <a
                    href={
                      location
                        ? `https://www.google.com/maps/dir/?api=1&destination=${location.latitude},${location.longitude}`
                        : "#"
                    }
                    target="_blank"
                    rel="noreferrer"
                  >
                    <Navigation className="h-4 w-4" /> Navigate
                  </a>
                </Button>
              </div>
            </CardContent>
          </Card>

          {/* 3. Source Evidence */}
          <Card>
            <CardHeader className="pb-2">
              <div className="flex items-center justify-between">
                <CardTitle className="text-base">Source Evidence</CardTitle>
                <span className="text-xs text-muted-foreground">{media.length} item{media.length === 1 ? "" : "s"}</span>
              </div>
            </CardHeader>
            <CardContent>
              {media.length === 0 ? (
                <EvidenceEmptyState />
              ) : (
                <ul className="grid grid-cols-1 gap-3 sm:grid-cols-2">
                  {media.map((m) => (
                    <EvidenceCard key={m.id} item={m} />
                  ))}
                </ul>
              )}
            </CardContent>
          </Card>

          {/* 4. AI Summary + Explainability */}
          <Card>
            <CardHeader className="pb-2">
              <CardTitle className="flex items-center gap-2 text-base">
                <Sparkles className="h-4 w-4 text-primary" /> AI Summary
              </CardTitle>
            </CardHeader>
            <CardContent className="space-y-3">
              {analysis ? (
                <>
                  <dl className="grid grid-cols-2 gap-x-4 gap-y-2 text-sm md:grid-cols-4">
                    <MetaField
                      label="Suggested Category"
                      value={analysis.predicted_category?.category_name || "—"}
                    />
                    <MetaField
                      label="Suggested Priority"
                      value={
                        analysis.predicted_priority ? (
                          <PriorityBadge priority={analysis.predicted_priority} />
                        ) : (
                          "—"
                        )
                      }
                    />
                    <MetaField
                      label="Confidence"
                      value={analysis.confidence_score != null ? `${Number(analysis.confidence_score).toFixed(1)}%` : "—"}
                    />
                    <MetaField
                      label="Human Review"
                      value={
                        (analysis.confidence_score ?? 0) < 70 ? (
                          <span className="inline-flex items-center gap-1 text-[var(--color-status-pending-foreground)]">
                            <AlertTriangle className="h-3.5 w-3.5" /> Required
                          </span>
                        ) : (
                          <span className="text-muted-foreground">Not required</span>
                        )
                      }
                    />
                  </dl>
                  <div className="rounded-lg border border-border bg-muted/30 p-3 text-sm leading-relaxed text-foreground">
                    {analysis.summary || "No summary generated."}
                  </div>

                  {/* Explainability */}
                  <div className="rounded-lg border border-border bg-background p-3">
                    <p className="text-xs font-semibold uppercase tracking-wide text-muted-foreground">
                      Why was this category suggested?
                    </p>
                    <ul className="mt-2 space-y-1 text-sm text-foreground">
                      <li className="flex gap-2">
                        <span className="mt-1.5 h-1 w-1 shrink-0 rounded-full bg-primary" />
                        <span>Permanent roadside structure detected in submitted evidence</span>
                      </li>
                      <li className="flex gap-2">
                        <span className="mt-1.5 h-1 w-1 shrink-0 rounded-full bg-primary" />
                        <span>Pedestrian obstruction identified from spatial context</span>
                      </li>
                      <li className="flex gap-2">
                        <span className="mt-1.5 h-1 w-1 shrink-0 rounded-full bg-primary" />
                        <span>Matches historical patterns from this ward</span>
                      </li>
                    </ul>
                  </div>
                </>
              ) : (
                <div className="flex items-center gap-3 rounded-lg border border-dashed border-border bg-muted/20 p-3 text-sm text-muted-foreground">
                  <Bot className="h-4 w-4" />
                  <span>AI analysis pending. Summary will appear once processing completes.</span>
                </div>
              )}
            </CardContent>
          </Card>

          {/* 5. AI Extraction Details */}
          <Card>
            <CardHeader className="pb-2">
              <CardTitle className="text-base">AI Extraction Details</CardTitle>
            </CardHeader>
            <CardContent>
              {analysis ? (
                <dl className="grid grid-cols-1 gap-3 text-sm md:grid-cols-2">
                  <MetaField
                    label="Severity Score"
                    value={analysis.severity_score != null ? `${Number(analysis.severity_score).toFixed(1)} / 100` : "—"}
                  />
                  <MetaField
                    label="Risk Score"
                    value={analysis.risk_score != null ? `${Number(analysis.risk_score).toFixed(1)} / 100` : "—"}
                  />
                  <MetaField label="Model" value={analysis.model_name || "—"} />
                  <MetaField label="Version" value={analysis.analysis_version || "—"} />
                  <MetaField label="Incident Type" value={<PlaceholderChip>Awaiting extraction</PlaceholderChip>} />
                  <MetaField label="Impact Scope" value={<PlaceholderChip>Awaiting extraction</PlaceholderChip>} />
                  <div className="md:col-span-2">
                    <p className="text-xs font-medium uppercase tracking-wide text-muted-foreground">Hazard Keywords</p>
                    <div className="mt-1"><PlaceholderChip>Awaiting extraction</PlaceholderChip></div>
                  </div>
                </dl>
              ) : (
                <p className="text-sm text-muted-foreground">Extraction details will appear once analysis completes.</p>
              )}
            </CardContent>
          </Card>

          {/* 6. Possible Duplicate Reports */}
          <Card>
            <CardHeader className="pb-2">
              <CardTitle className="flex items-center gap-2 text-base">
                <GitMerge className="h-4 w-4 text-primary" /> Possible Duplicate Reports
              </CardTitle>
            </CardHeader>
            <CardContent>
              {duplicates.length === 0 ? (
                <div className="flex items-center gap-3 rounded-lg border border-dashed border-border bg-muted/20 px-3 py-2.5 text-sm text-muted-foreground">
                  <GitMerge className="h-4 w-4" />
                  <span>No similar reports found.</span>
                </div>
              ) : (
                <ul className="space-y-2">
                  {duplicates.map((d) => (
                    <li
                      key={d.id}
                      className="flex flex-wrap items-center justify-between gap-3 rounded-lg border border-border p-3"
                    >
                      <div className="min-w-0">
                        <p className="truncate text-sm font-medium text-foreground">
                          {d.matched_report?.title ?? "Untitled report"}
                        </p>
                        <p className="mt-0.5 flex flex-wrap items-center gap-x-2 gap-y-0.5 truncate text-xs text-muted-foreground">
                          <span>#{(d.matched_report?.id ?? "").slice(0, 8).toUpperCase()}</span>
                          <span>·</span>
                          <span>{d.matched_report?.wards?.ward_name ?? "—"}</span>
                          <span>·</span>
                          <span>{d.matched_report?.categories?.category_name ?? "—"}</span>
                          <span>·</span>
                          <span className="font-medium text-foreground">
                            {Number(d.similarity_score ?? 0).toFixed(0)}% match
                          </span>
                        </p>
                      </div>
                      <div className="flex items-center gap-1.5">
                        {d.matched_report?.id && (
                          <Button asChild variant="outline" size="sm">
                            <Link
                              to="/reports/$reportId"
                              params={{ reportId: d.matched_report.id }}
                            >
                              View
                            </Link>
                          </Button>
                        )}
                        <Button variant="outline" size="sm">Merge</Button>
                        <Button variant="ghost" size="sm">Ignore</Button>
                      </div>
                    </li>
                  ))}
                </ul>
              )}
            </CardContent>
          </Card>

          {/* 7. Officer Notes — Jira-style comments */}
          <Card>
            <CardHeader className="pb-2">
              <CardTitle className="text-base">Officer Notes</CardTitle>
            </CardHeader>
            <CardContent className="space-y-3">
              <div className="flex items-start gap-2">
                <div className="grid h-8 w-8 shrink-0 place-items-center rounded-full bg-muted text-muted-foreground">
                  <UserCircle2 className="h-4 w-4" />
                </div>
                <div className="flex-1">
                  <textarea
                    rows={2}
                    placeholder="Add an internal note visible to the review team…"
                    className="min-h-16 w-full resize-none rounded-md border border-border bg-background px-3 py-2 text-sm text-foreground placeholder:text-muted-foreground focus-visible:outline-none focus-visible:ring-1 focus-visible:ring-ring"
                  />
                  <div className="mt-2 flex items-center justify-between">
                    <p className="text-xs text-muted-foreground">Notes are append-only and visible to reviewing officers.</p>
                    <Button size="sm" disabled>
                      <Send className="h-4 w-4" /> Post
                    </Button>
                  </div>
                </div>
              </div>
            </CardContent>
          </Card>

          {/* 8. Activity Timeline */}
          <Card>
            <CardHeader className="pb-2">
              <CardTitle className="flex items-center gap-2 text-base">
                <History className="h-4 w-4 text-primary" /> Activity Timeline
              </CardTitle>
            </CardHeader>
            <CardContent>
              <ActivityTimeline
                submittedAt={report.submitted_at}
                updatedAt={report.updated_at}
                aiAt={analysis?.created_at ?? null}
              />
            </CardContent>
          </Card>
        </div>

        {/* RIGHT — 4 cols, sticky on desktop */}
        <aside className="space-y-4 lg:col-span-4">
          <div className="space-y-4 lg:sticky lg:top-20">
            {/* Card 1 — Current Stage (enterprise workflow tracker) */}
            <Card>
              <CardHeader className="pb-2">
                <CardTitle className="text-base">Current Stage</CardTitle>
              </CardHeader>
              <CardContent>
                <StageTracker status={report.status ?? "pending"} />
              </CardContent>
            </Card>

            {/* Card 2 — Officer Actions (grouped) */}
            <Card>
              <CardHeader className="pb-2">
                <CardTitle className="text-base">Officer Actions</CardTitle>
              </CardHeader>
              <CardContent className="space-y-3">
                <ActionGroup label="Primary Decision">
                  <Button className="w-full justify-start">
                    <CheckCircle2 className="h-4 w-4" /> Approve Report
                  </Button>
                  <Button variant="outline" className="w-full justify-start">
                    <XCircle className="h-4 w-4" /> Reject Report
                  </Button>
                </ActionGroup>

                <ActionGroup label="Issue Management">
                  <Button variant="outline" className="w-full justify-start">
                    <ClipboardList className="h-4 w-4" /> Create Issue
                  </Button>
                  <Button variant="outline" className="w-full justify-start">
                    <LinkIcon className="h-4 w-4" /> Link Existing Issue
                  </Button>
                </ActionGroup>

                <ActionGroup label="Internal Actions">
                  <Button variant="outline" className="w-full justify-start">
                    <MessageSquarePlus className="h-4 w-4" /> Add Officer Note
                  </Button>
                  <Button variant="outline" className="w-full justify-start">
                    <Layers className="h-4 w-4" /> Escalate
                  </Button>
                  <Button variant="ghost" className="w-full justify-start text-muted-foreground" disabled>
                    <UserPlus className="h-4 w-4" /> Request More Information
                  </Button>
                </ActionGroup>
              </CardContent>
            </Card>

            {/* Card 3 — Linked Issue (compact intentional empty state) */}
            <Card>
              <CardHeader className="pb-2">
                <CardTitle className="text-base">Linked Issue</CardTitle>
              </CardHeader>
              <CardContent>
                <div className="rounded-lg border border-border bg-muted/20 p-3">
                  <p className="text-sm font-medium text-foreground">No linked issue</p>
                  <p className="mt-0.5 text-xs text-muted-foreground">
                    Reports must be approved before an issue can be created or linked.
                  </p>
                  <Button size="sm" className="mt-3 w-full">
                    <ClipboardList className="h-4 w-4" /> Create Issue
                  </Button>
                </div>
              </CardContent>
            </Card>
          </div>
        </aside>
      </div>

      {/* Sticky bottom action panel — mobile only */}
      <div className="pointer-events-none fixed inset-x-0 bottom-0 z-30 flex justify-center px-3 pb-3 lg:hidden">
        <div className="pointer-events-auto flex w-full max-w-md items-center gap-2 rounded-xl border border-border bg-background/95 p-2 shadow-lg backdrop-blur">
          <Button variant="outline" size="sm" className="flex-1">
            <XCircle className="h-4 w-4" /> Reject
          </Button>
          <Button size="sm" className="flex-1">
            <CheckCircle2 className="h-4 w-4" /> Approve
          </Button>
        </div>
      </div>
    </>
  );
}

/* ---------------- Sub-components ---------------- */

type MediaItem = {
  id: string;
  media_type: string;
  file_url: string;
  file_name: string;
  mime_type: string;
  file_size: number | null;
  uploaded_at: string;
};

type DuplicateItem = {
  id: string;
  similarity_score: number | null;
  reason: string | null;
  matched_report?: {
    id: string;
    title: string;
    status: string;
    categories?: { category_name: string } | null;
    wards?: { ward_name: string } | null;
  } | null;
};

function ReadOnlyTag() {
  return (
    <span className="rounded-full bg-muted px-2 py-0.5 text-[10px] font-medium uppercase tracking-wide text-muted-foreground">
      Read only
    </span>
  );
}

function PlaceholderChip({ children }: { children: React.ReactNode }) {
  return (
    <span className="inline-flex items-center rounded-md border border-dashed border-border px-2 py-0.5 text-xs text-muted-foreground">
      {children}
    </span>
  );
}

function MetaField({ label, value }: { label: string; value: React.ReactNode }) {
  return (
    <div className="min-w-0">
      <p className="text-xs font-medium uppercase tracking-wide text-muted-foreground">{label}</p>
      <div className="mt-0.5 truncate text-sm text-foreground">{value}</div>
    </div>
  );
}

function MetaChips({ items }: { items: { label: string; value: React.ReactNode }[] }) {
  return (
    <div className="flex flex-wrap gap-2">
      {items.map((i) => (
        <div
          key={i.label}
          className="inline-flex items-center gap-1.5 rounded-md border border-border bg-card px-2.5 py-1 text-xs"
        >
          <span className="uppercase tracking-wide text-muted-foreground">{i.label}</span>
          <span className="font-medium text-foreground">{i.value}</span>
        </div>
      ))}
    </div>
  );
}

function IdentityItem({ label, value }: { label: string; value: React.ReactNode }) {
  return (
    <div className="min-w-0">
      <p className="text-[10px] font-semibold uppercase tracking-wider text-muted-foreground">{label}</p>
      <div className="mt-1 truncate text-sm font-medium text-foreground">{value}</div>
    </div>
  );
}

function ActionGroup({ label, children }: { label: string; children: React.ReactNode }) {
  return (
    <div>
      <p className="mb-1.5 text-[10px] font-semibold uppercase tracking-wider text-muted-foreground">
        {label}
      </p>
      <div className="space-y-1.5">{children}</div>
    </div>
  );
}

function EvidenceEmptyState() {
  const types = [
    { icon: Camera, label: "Citizen Images" },
    { icon: FileText, label: "PDF Documents" },
    { icon: Newspaper, label: "News Articles" },
    { icon: LinkIcon, label: "External Links" },
  ];
  return (
    <div className="rounded-lg border border-dashed border-border bg-muted/20 p-4">
      <p className="text-sm font-medium text-foreground">No evidence available for this report.</p>
      <p className="mt-0.5 text-xs text-muted-foreground">
        This section will display all uploaded and AI-discovered evidence.
      </p>
      <div className="mt-3 grid grid-cols-2 gap-2 sm:grid-cols-4">
        {types.map((t) => (
          <div
            key={t.label}
            className="flex flex-col items-center gap-1 rounded-md border border-border bg-background/50 px-2 py-3 text-center"
          >
            <t.icon className="h-4 w-4 text-muted-foreground" />
            <span className="text-[11px] text-muted-foreground">{t.label}</span>
          </div>
        ))}
      </div>
    </div>
  );
}

function EvidenceCard({ item }: { item: MediaItem }) {
  const isImage = item.mime_type?.startsWith("image/");
  const isPdf = item.mime_type === "application/pdf";
  const isUrl = item.media_type?.toLowerCase() === "url" || item.media_type?.toLowerCase() === "link";
  const Icon = isImage ? ImageIcon : isPdf ? FileText : isUrl ? LinkIcon : FileText;
  const actionLabel = isImage ? "View Image" : isPdf ? "View PDF" : isUrl ? "Open Article" : "Open";

  return (
    <li className="flex items-center gap-3 rounded-lg border border-border p-3">
      <div className="grid h-12 w-12 shrink-0 place-items-center rounded-md bg-muted text-muted-foreground">
        {isImage && item.file_url ? (
          <img src={item.file_url} alt={item.file_name} className="h-full w-full rounded-md object-cover" />
        ) : (
          <Icon className="h-5 w-5" />
        )}
      </div>
      <div className="min-w-0 flex-1">
        <p className="truncate text-sm font-medium text-foreground">{item.file_name}</p>
        <p className="mt-0.5 truncate text-xs text-muted-foreground">
          {item.media_type} · uploaded {timeAgo(item.uploaded_at)}
        </p>
      </div>
      <div className="flex items-center gap-1">
        <Button asChild variant="outline" size="sm">
          <a href={item.file_url} target="_blank" rel="noreferrer">
            <ExternalLink className="h-4 w-4" /> {actionLabel}
          </a>
        </Button>
        <Button asChild variant="ghost" size="icon" className="h-8 w-8">
          <a href={item.file_url} download={item.file_name}>
            <Download className="h-4 w-4" />
          </a>
        </Button>
      </div>
    </li>
  );
}

const STAGES: { key: string; label: string; matches: string[] }[] = [
  { key: "submitted", label: "Submitted", matches: ["pending", "submitted"] },
  { key: "under_review", label: "Under Review", matches: ["under_review"] },
  { key: "approved", label: "Approved", matches: ["assigned"] },
  { key: "issue_created", label: "Issue Created", matches: ["in_progress"] },
  { key: "resolved", label: "Resolved", matches: ["resolved"] },
];

function StageTracker({ status }: { status: string }) {
  const normalized = status.toLowerCase();
  let activeIndex = STAGES.findIndex((s) => s.matches.includes(normalized));
  if (activeIndex === -1) activeIndex = 0;
  const rejected = normalized === "rejected";

  return (
    <ol className="relative">
      {STAGES.map((stage, i) => {
        const done = !rejected && i < activeIndex;
        const active = !rejected && i === activeIndex;
        const isLast = i === STAGES.length - 1;
        return (
          <li key={stage.key} className="relative flex gap-3 pb-4 last:pb-0">
            {/* connector line */}
            {!isLast && (
              <span
                aria-hidden
                className={
                  "absolute left-[11px] top-6 h-[calc(100%-1.25rem)] w-px " +
                  (done ? "bg-primary" : "bg-border")
                }
              />
            )}
            <span
              className={
                "relative z-10 grid h-6 w-6 shrink-0 place-items-center rounded-full border " +
                (done
                  ? "border-primary bg-primary text-primary-foreground"
                  : active
                    ? "border-primary bg-background text-primary ring-4 ring-primary/15"
                    : "border-border bg-background text-muted-foreground")
              }
            >
              {done ? <CheckCircle2 className="h-3.5 w-3.5" /> : <Circle className="h-2.5 w-2.5 fill-current" />}
            </span>
            <div className="min-w-0 pt-0.5">
              <p
                className={
                  "text-sm leading-tight " +
                  (active
                    ? "font-semibold text-foreground"
                    : done
                      ? "text-foreground"
                      : "text-muted-foreground")
                }
              >
                {stage.label}
              </p>
              {active && (
                <p className="mt-0.5 text-[11px] uppercase tracking-wide text-primary">Current stage</p>
              )}
            </div>
          </li>
        );
      })}
      {rejected && (
        <li className="mt-2 flex items-center gap-3 border-t border-border pt-3">
          <span className="grid h-6 w-6 place-items-center rounded-full border border-[var(--color-status-rejected-foreground)] text-[var(--color-status-rejected-foreground)]">
            <XCircle className="h-3.5 w-3.5" />
          </span>
          <span className="text-sm font-medium text-foreground">Rejected</span>
        </li>
      )}
    </ol>
  );
}

function ActivityTimeline({
  submittedAt,
  updatedAt,
  aiAt,
}: {
  submittedAt: string;
  updatedAt: string;
  aiAt: string | null;
}) {
  const events: { id: string; at: string; icon: React.ComponentType<{ className?: string }>; actor: string; description: string }[] = [
    { id: "submitted", at: submittedAt, icon: UserCircle2, actor: "Citizen", description: "Submitted report" },
  ];
  if (aiAt) {
    events.push({ id: "ai", at: aiAt, icon: Bot, actor: "AI Pipeline", description: "AI analysis completed" });
  }
  if (updatedAt && updatedAt !== submittedAt) {
    events.push({ id: "updated", at: updatedAt, icon: History, actor: "System", description: "Report record updated" });
  }
  events.sort((a, b) => new Date(a.at).getTime() - new Date(b.at).getTime());

  return (
    <ol className="relative space-y-3 border-l border-border pl-5">
      {events.map((e) => (
        <li key={e.id} className="relative">
          <span className="absolute -left-[27px] top-0.5 grid h-6 w-6 place-items-center rounded-full border border-border bg-background text-muted-foreground">
            <e.icon className="h-3.5 w-3.5" />
          </span>
          <div className="flex flex-wrap items-baseline gap-x-2">
            <p className="text-sm font-medium text-foreground">{e.actor}</p>
            <span className="text-muted-foreground/50">·</span>
            <p className="text-xs text-muted-foreground">{timeAgo(e.at)}</p>
          </div>
          <p className="text-sm text-muted-foreground">{e.description}</p>
        </li>
      ))}
    </ol>
  );
}

function ReportSkeleton() {
  return (
    <>
      <div className="h-4 w-48 animate-pulse rounded bg-muted" />
      <div className="h-8 w-2/3 animate-pulse rounded bg-muted" />
      <div className="grid grid-cols-1 gap-4 lg:grid-cols-12">
        <div className="space-y-4 lg:col-span-8">
          {[0, 1, 2].map((i) => (
            <div key={i} className="h-40 animate-pulse rounded-lg border border-border bg-muted/40" />
          ))}
        </div>
        <div className="space-y-4 lg:col-span-4">
          {[0, 1].map((i) => (
            <div key={i} className="h-40 animate-pulse rounded-lg border border-border bg-muted/40" />
          ))}
        </div>
      </div>
    </>
  );
}
