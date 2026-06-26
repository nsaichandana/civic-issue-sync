import { Bell, Search, HelpCircle } from "lucide-react";
import { SidebarTrigger } from "@/components/ui/sidebar";
import { Input } from "@/components/ui/input";
import { Button } from "@/components/ui/button";
import { useRouterState } from "@tanstack/react-router";

const TITLES: Record<string, string> = {
  "/dashboard": "Dashboard",
  "/reports": "Reports",
  "/issues": "Issues",
  "/assignments": "Assignments",
  "/field-workers": "Field Workers",
  "/analytics": "Analytics",
  "/settings": "Settings",
};

export function AppHeader() {
  const pathname = useRouterState({ select: (s) => s.location.pathname });
  const base = "/" + (pathname.split("/")[1] ?? "");
  const title = TITLES[base] ?? "CivicTrust";

  return (
    <header className="sticky top-0 z-20 grid grid-cols-[auto_1fr_auto] items-center gap-3 border-b border-border bg-background/80 px-4 py-3 backdrop-blur md:px-6">
      <div className="flex min-w-0 items-center gap-3">
        <SidebarTrigger className="-ml-1" />
        <div className="hidden h-5 w-px bg-border md:block" />
        <h1 className="truncate text-sm font-semibold text-foreground md:text-base">{title}</h1>
      </div>
      <div className="hidden justify-center md:flex">
        <div className="relative w-full max-w-md">
          <Search className="pointer-events-none absolute left-3 top-1/2 h-4 w-4 -translate-y-1/2 text-muted-foreground" />
          <Input
            placeholder="Search reports, issues, wards…"
            className="h-9 rounded-lg border-border bg-card pl-9 text-sm shadow-none focus-visible:ring-1"
          />
        </div>
      </div>
      <div className="flex items-center gap-1.5">
        <Button variant="ghost" size="icon" className="h-9 w-9 rounded-lg">
          <HelpCircle className="h-4 w-4" />
        </Button>
        <Button variant="ghost" size="icon" className="h-9 w-9 rounded-lg relative">
          <Bell className="h-4 w-4" />
          <span className="absolute right-2 top-2 h-1.5 w-1.5 rounded-full bg-primary" />
        </Button>
        <div className="ml-1 hidden h-8 w-8 place-items-center rounded-full bg-muted text-xs font-semibold text-foreground md:grid">
          MR
        </div>
      </div>
    </header>
  );
}
