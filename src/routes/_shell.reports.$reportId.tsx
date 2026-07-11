import { createFileRoute, Link, notFound } from "@tanstack/react-router";
import { useEffect, useState } from "react";
import {
  ArrowLeft,
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
} from "lucide-react";
import { PageHeader } from "@/components/layout/PageHeader";
import { StatusBadge, PriorityBadge } from "@/components/StatusBadge";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { EmptyState } from "@/components/EmptyState";
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
      <div>
        <Button asChild variant="ghost" size="sm" className="-ml-2 text-muted-foreground">
          <Link to="/reports">
            <ArrowLeft className="h-4 w-4" /> Back to Reports
          </Link>
        </Button>
      </div>

      <PageHeader
        title={report.title}
        description={`Report #${shortId} · Submitted ${timeAgo(report.submitted_at)}`}
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

      <ReportMeta
        ward={ward}
        category={category}
        source={report.source ?? "—"}
        updatedAt={report.updated_at}
        aiStatus={analysis ? "Completed" : "Pending"}
        linkedStatus="Not linked"
      />

      <div className="grid grid-cols-1 gap-6 lg:grid-cols-12">
        {/* LEFT — 8 cols */}
        <div className="space-y-4 lg:col-span-8">
          {/* 1. Citizen Submission */}
          <Card>
            <CardHeader className="pb-3">
              <div className="flex items-center justify-between gap-2">
                <CardTitle className="text-base">Citizen Submission</CardTitle>
                <ReadOnlyTag />
              </div>
            </CardHeader>
            <CardContent className="space-y-4">
              <div>
                <p className="text-xs font-medium uppercase tracking-wide text-muted-foreground">Title</p>
                <p className="mt-1 text-sm font-medium text-foreground">{report.title}</p>
              </div>
              <div>
                <p className="text-xs font-medium uppercase tracking-wide text-muted-foreground">Description</p>
                <p className="mt-1 whitespace-pre-wrap text-sm leading-relaxed text-foreground">
                  {report.description}
                </p>
              </div>
              <dl className="grid grid-cols-2 gap-x-4 gap-y-3 border-t border-border pt-4 text-sm md:grid-cols-4">
                <MetaField label="Reporter" value={reporterLabel} />
                <MetaField
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
                <MetaField label="Submitted" value={new Date(report.submitted_at).toLocaleString()} />
                <MetaField label="Language" value="English" />
                <MetaField label="Ward" value={ward} />
                <MetaField label="Channel" value={report.source ?? "—"} />
                <MetaField label="Community Verifications" value={String(report.upvote_count ?? 0)} />
              </dl>
            </CardContent>
          </Card>

          {/* 2. Location */}
          <Card>
            <CardHeader className="pb-3">
              <CardTitle className="flex items-center gap-2 text-base">
                <MapPin className="h-4 w-4 text-primary" /> Location
              </CardTitle>
            </CardHeader>
            <CardContent className="space-y-4">
              <dl className="grid grid-cols-2 gap-x-4 gap-y-3 text-sm md:grid-cols-3">
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
                {/* Placeholder: replace with Google Maps embed later */}
                <div className="grid aspect-[16/7] place-items-center text-center text-xs text-muted-foreground">
                  <div>
                    <MapPin className="mx-auto h-6 w-6" />
                    <p className="mt-2">Interactive map placeholder</p>
                  </div>
                </div>
              </div>

              <div className="flex justify-end">
                <Button
                  variant="outline"
                  size="sm"
                  asChild
                  disabled={!location}
                >
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
            <CardHeader className="pb-3">
              <div className="flex items-center justify-between">
                <CardTitle className="text-base">Source Evidence</CardTitle>
                <span className="text-xs text-muted-foreground">{media.length} item{media.length === 1 ? "" : "s"}</span>
              </div>
            </CardHeader>
            <CardContent>
              {media.length === 0 ? (
                <EmptyState icon={ImageIcon} title="No evidence uploaded." description="Media attached by the citizen will appear here." />
              ) : (
                <ul className="grid grid-cols-1 gap-3 sm:grid-cols-2">
                  {media.map((m) => (
                    <EvidenceCard key={m.id} item={m} />
                  ))}
                </ul>
              )}
            </CardContent>
          </Card>

          {/* 4. AI Summary */}
          <Card>
            <CardHeader className="pb-3">
              <CardTitle className="flex items-center gap-2 text-base">
                <Sparkles className="h-4 w-4 text-primary" /> AI Summary
              </CardTitle>
            </CardHeader>
            <CardContent className="space-y-4">
              {analysis ? (
                <>
                  <dl className="grid grid-cols-2 gap-x-4 gap-y-3 text-sm md:grid-cols-4">
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
                </>
              ) : (
                <EmptyState
                  icon={Bot}
                  title="AI analysis pending"
                  description="The AI pipeline has not returned a summary for this report yet."
                />
              )}
            </CardContent>
          </Card>

          {/* 5. AI Extraction Details */}
          <Card>
            <CardHeader className="pb-3">
              <CardTitle className="text-base">AI Extraction Details</CardTitle>
            </CardHeader>
            <CardContent>
              {analysis ? (
                <dl className="grid grid-cols-1 gap-4 text-sm md:grid-cols-2">
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
                  {/* Placeholder rows — replace when AI extraction JSON is exposed */}
                  <MetaField label="Incident Type" value={<PlaceholderChip>Awaiting extraction</PlaceholderChip>} />
                  <MetaField label="Impact Scope" value={<PlaceholderChip>Awaiting extraction</PlaceholderChip>} />
                  <div className="md:col-span-2">
                    <p className="text-xs font-medium uppercase tracking-wide text-muted-foreground">Hazard Keywords</p>
                    <div className="mt-1"><PlaceholderChip>Awaiting extraction</PlaceholderChip></div>
                  </div>
                  <div className="md:col-span-2">
                    <p className="text-xs font-medium uppercase tracking-wide text-muted-foreground">Reasoning</p>
                    <p className="mt-1 text-sm text-muted-foreground">
                      Structured reasoning will appear here once the extraction pipeline surfaces it.
                    </p>
                  </div>
                </dl>
              ) : (
                <p className="text-sm text-muted-foreground">Extraction details will appear once analysis completes.</p>
              )}
            </CardContent>
          </Card>

          {/* 6. Possible Duplicate Reports */}
          <Card>
            <CardHeader className="pb-3">
              <CardTitle className="flex items-center gap-2 text-base">
                <GitMerge className="h-4 w-4 text-primary" /> Possible Duplicate Reports
              </CardTitle>
            </CardHeader>
            <CardContent>
              {duplicates.length === 0 ? (
                <EmptyState icon={GitMerge} title="No similar reports found." />
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

          {/* 7. Officer Notes — UI ready, backing table not yet wired */}
          <Card>
            <CardHeader className="pb-3">
              <div className="flex items-center justify-between gap-2">
                <CardTitle className="text-base">Officer Notes</CardTitle>
                <Button size="sm" variant="outline">
                  <MessageSquarePlus className="h-4 w-4" /> Add Note
                </Button>
              </div>
            </CardHeader>
            <CardContent>
              <EmptyState
                icon={MessageSquarePlus}
                title="No officer notes yet."
                description="Append-only notes from reviewing officers will appear here."
              />
              {/* Isolated placeholder composer — no state is persisted */}
              <div className="mt-4 rounded-lg border border-dashed border-border bg-muted/20 p-3">
                <label className="text-xs font-medium uppercase tracking-wide text-muted-foreground">
                  Add a note (preview)
                </label>
                <div className="mt-2 flex items-start gap-2">
                  <textarea
                    rows={2}
                    placeholder="Write a note visible to the review team…"
                    disabled
                    className="min-h-16 flex-1 resize-none rounded-md border border-border bg-background px-3 py-2 text-sm text-foreground placeholder:text-muted-foreground focus-visible:outline-none focus-visible:ring-1 focus-visible:ring-ring disabled:cursor-not-allowed disabled:opacity-70"
                  />
                  <Button size="sm" disabled>
                    <Send className="h-4 w-4" /> Post
                  </Button>
                </div>
              </div>
            </CardContent>
          </Card>

          {/* 8. Activity Timeline — placeholder events derived from real report fields */}
          <Card>
            <CardHeader className="pb-3">
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
            {/* Card 1 — Current Stage */}
            <Card>
              <CardHeader className="pb-3">
                <CardTitle className="text-base">Current Stage</CardTitle>
              </CardHeader>
              <CardContent>
                <StageTracker status={report.status ?? "pending"} />
              </CardContent>
            </Card>

            {/* Card 2 — Officer Actions */}
            <Card>
              <CardHeader className="pb-3">
                <CardTitle className="text-base">Officer Actions</CardTitle>
              </CardHeader>
              <CardContent className="space-y-2">
                <Button className="w-full justify-start">
                  <CheckCircle2 className="h-4 w-4" /> Approve Report
                </Button>
                <Button variant="outline" className="w-full justify-start">
                  <XCircle className="h-4 w-4" /> Reject Report
                </Button>
                <div className="my-2 h-px bg-border" />
                <Button variant="outline" className="w-full justify-start">
                  <ClipboardList className="h-4 w-4" /> Create Issue
                </Button>
                <Button variant="outline" className="w-full justify-start">
                  <LinkIcon className="h-4 w-4" /> Link Existing Issue
                </Button>
                <Button variant="outline" className="w-full justify-start">
                  <MessageSquarePlus className="h-4 w-4" /> Add Officer Note
                </Button>
                <Button variant="outline" className="w-full justify-start">
                  <Layers className="h-4 w-4" /> Escalate
                </Button>
                <Button variant="ghost" className="w-full justify-start text-muted-foreground" disabled>
                  <UserPlus className="h-4 w-4" /> Request More Information
                </Button>
              </CardContent>
            </Card>

            {/* Card 3 — Linked Issue */}
            <Card>
              <CardHeader className="pb-3">
                <CardTitle className="text-base">Linked Issue</CardTitle>
              </CardHeader>
              <CardContent>
                <EmptyState
                  icon={AlertTriangle}
                  title="No linked issue."
                  description="Approving this report will let you create or link an issue."
                  action={
                    <Button size="sm" variant="outline">
                      <ClipboardList className="h-4 w-4" /> Create Issue
                    </Button>
                  }
                />
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
      <div className="mt-1 truncate text-sm text-foreground">{value}</div>
    </div>
  );
}

function ReportMeta({
  shortId,
  ward,
  category,
  source,
  submittedAt,
  updatedAt,
  aiStatus,
  linkedStatus,
}: {
  shortId: string;
  ward: string;
  category: string;
  source: string;
  submittedAt: string;
  updatedAt: string;
  aiStatus: string;
  linkedStatus: string;
}) {
  const items = [
    { label: "Report", value: `#${shortId}` },
    { label: "Ward", value: ward },
    { label: "Category", value: category },
    { label: "Channel", value: source },
    { label: "AI", value: aiStatus },
    { label: "Issue", value: linkedStatus },
    { label: "Submitted", value: timeAgo(submittedAt) },
    { label: "Updated", value: timeAgo(updatedAt) },
  ];
  return (
    <span className="flex flex-wrap items-center gap-x-3 gap-y-1 text-xs text-muted-foreground">
      {items.map((i, idx) => (
        <span key={i.label} className="inline-flex items-center gap-1">
          <span className="uppercase tracking-wide">{i.label}:</span>
          <span className="font-medium text-foreground">{i.value}</span>
          {idx < items.length - 1 && <span className="text-border">·</span>}
        </span>
      ))}
    </span>
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
  const activeIndex = STAGES.findIndex((s) => s.matches.includes(normalized));
  const rejected = normalized === "rejected";
  return (
    <ol className="space-y-3">
      {STAGES.map((stage, i) => {
        const done = !rejected && activeIndex >= 0 && i < activeIndex;
        const active = !rejected && i === activeIndex;
        return (
          <li key={stage.key} className="flex items-center gap-3">
            <span
              className={
                "grid h-6 w-6 shrink-0 place-items-center rounded-full border " +
                (done
                  ? "border-primary bg-primary text-primary-foreground"
                  : active
                    ? "border-primary text-primary"
                    : "border-border text-muted-foreground")
              }
            >
              {done ? <CheckCircle2 className="h-3.5 w-3.5" /> : <Circle className="h-3 w-3" />}
            </span>
            <span
              className={
                "text-sm " +
                (active ? "font-medium text-foreground" : done ? "text-foreground" : "text-muted-foreground")
              }
            >
              {stage.label}
            </span>
          </li>
        );
      })}
      {rejected && (
        <li className="flex items-center gap-3 border-t border-border pt-3">
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
    { id: "submitted", at: submittedAt, icon: UserCircle2, actor: "Citizen", description: "Report submitted" },
  ];
  if (aiAt) {
    events.push({ id: "ai", at: aiAt, icon: Bot, actor: "AI Pipeline", description: "AI analysis completed" });
  }
  if (updatedAt && updatedAt !== submittedAt) {
    events.push({ id: "updated", at: updatedAt, icon: History, actor: "System", description: "Report record updated" });
  }
  events.sort((a, b) => new Date(a.at).getTime() - new Date(b.at).getTime());

  return (
    <ol className="relative space-y-5 border-l border-border pl-5">
      {events.map((e) => (
        <li key={e.id} className="relative">
          <span className="absolute -left-[27px] top-1 grid h-6 w-6 place-items-center rounded-full border border-border bg-background text-muted-foreground">
            <e.icon className="h-3.5 w-3.5" />
          </span>
          <div className="flex flex-wrap items-baseline gap-x-2">
            <p className="text-sm font-medium text-foreground">{e.actor}</p>
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
      <div className="h-4 w-32 animate-pulse rounded bg-muted" />
      <div className="h-8 w-2/3 animate-pulse rounded bg-muted" />
      <div className="grid grid-cols-1 gap-6 lg:grid-cols-12">
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
