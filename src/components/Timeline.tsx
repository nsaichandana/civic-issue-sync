import type { TimelineEvent } from "@/types";
import { timeAgo } from "@/lib/format";

export function Timeline({ events }: { events: TimelineEvent[] }) {
  return (
    <ol className="relative space-y-5 border-l border-border pl-5">
      {events.map((e) => (
        <li key={e.id} className="relative">
          <span className="absolute -left-[27px] top-1.5 h-3 w-3 rounded-full border-2 border-background bg-primary" />
          <div className="flex flex-wrap items-baseline gap-x-2">
            <p className="text-sm font-medium text-foreground">{e.actor}</p>
            <p className="text-xs text-muted-foreground">{timeAgo(e.at)}</p>
          </div>
          <p className="text-sm text-muted-foreground">{e.action}</p>
          {e.note && <p className="mt-1 text-xs text-muted-foreground/80">{e.note}</p>}
        </li>
      ))}
    </ol>
  );
}
