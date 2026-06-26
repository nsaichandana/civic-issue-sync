import { createFileRoute, Link } from "@tanstack/react-router";
import { ShieldCheck, Mail, Lock, ArrowRight } from "lucide-react";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";

export const Route = createFileRoute("/")({
  head: () => ({
    meta: [
      { title: "Sign in — CivicTrust" },
      {
        name: "description",
        content: "Sign in to CivicTrust to manage civic reports, issues and field operations.",
      },
    ],
  }),
  component: LoginPage,
});

function LoginPage() {
  return (
    <div className="grid min-h-screen lg:grid-cols-2">
      {/* Left — form */}
      <div className="flex items-center justify-center bg-background px-6 py-12">
        <div className="w-full max-w-sm">
          <div className="mb-8 flex items-center gap-2.5">
            <div className="grid h-9 w-9 place-items-center rounded-xl bg-primary text-primary-foreground shadow-sm">
              <ShieldCheck className="h-5 w-5" />
            </div>
            <div>
              <p className="text-sm font-semibold tracking-tight">CivicTrust</p>
              <p className="text-[11px] text-muted-foreground">Municipal Operations</p>
            </div>
          </div>

          <h1 className="text-2xl font-semibold tracking-tight text-foreground">Welcome back</h1>
          <p className="mt-1.5 text-sm text-muted-foreground">
            Sign in to review reports, manage issues and coordinate field response.
          </p>

          <form className="mt-8 space-y-4" onSubmit={(e) => e.preventDefault()}>
            <div className="space-y-1.5">
              <Label htmlFor="email">Work email</Label>
              <div className="relative">
                <Mail className="pointer-events-none absolute left-3 top-1/2 h-4 w-4 -translate-y-1/2 text-muted-foreground" />
                <Input id="email" type="email" placeholder="officer@city.gov" className="pl-9" />
              </div>
            </div>
            <div className="space-y-1.5">
              <div className="flex items-center justify-between">
                <Label htmlFor="password">Password</Label>
                <a href="#" className="text-xs font-medium text-primary hover:underline">
                  Forgot password?
                </a>
              </div>
              <div className="relative">
                <Lock className="pointer-events-none absolute left-3 top-1/2 h-4 w-4 -translate-y-1/2 text-muted-foreground" />
                <Input id="password" type="password" placeholder="••••••••" className="pl-9" />
              </div>
            </div>

            <Button asChild className="h-10 w-full">
              <Link to="/dashboard">
                Continue
                <ArrowRight className="ml-1.5 h-4 w-4" />
              </Link>
            </Button>

            <div className="relative py-1">
              <div className="absolute inset-0 flex items-center">
                <span className="w-full border-t border-border" />
              </div>
              <div className="relative flex justify-center">
                <span className="bg-background px-2 text-[11px] uppercase tracking-wide text-muted-foreground">
                  Or
                </span>
              </div>
            </div>

            <Button type="button" variant="outline" className="h-10 w-full gap-2">
              <GoogleIcon /> Sign in with Google
            </Button>
          </form>

          <p className="mt-8 text-xs text-muted-foreground">
            Authorized municipal personnel only. By signing in you agree to the city's acceptable
            use policy.
          </p>
        </div>
      </div>

      {/* Right — hero panel */}
      <div className="relative hidden overflow-hidden border-l border-border bg-card lg:block">
        <div className="absolute inset-0 bg-[radial-gradient(circle_at_20%_10%,var(--color-primary)/8%,transparent_50%),radial-gradient(circle_at_80%_80%,var(--color-accent)/10%,transparent_55%)]" />
        <div className="relative flex h-full flex-col justify-between p-12">
          <div className="flex items-center gap-2 text-xs font-medium text-muted-foreground">
            <span className="h-1.5 w-1.5 rounded-full bg-accent" /> Operational · v1.0
          </div>
          <div className="max-w-md">
            <p className="text-xs font-semibold uppercase tracking-[0.18em] text-primary">
              Trusted civic intelligence
            </p>
            <h2 className="mt-3 text-3xl font-semibold leading-tight tracking-tight text-foreground">
              One issue, many voices. Resolved faster.
            </h2>
            <p className="mt-3 text-sm leading-relaxed text-muted-foreground">
              CivicTrust groups reports from citizens, ward offices and verified news into a single
              actionable issue — so your teams act once, not many times.
            </p>
            <dl className="mt-8 grid grid-cols-3 gap-4 text-left">
              {[
                ["38%", "Faster triage"],
                ["6.2k", "Issues resolved"],
                ["24", "Wards online"],
              ].map(([v, l]) => (
                <div key={l} className="rounded-xl border border-border bg-background/60 p-3">
                  <dt className="text-lg font-semibold tracking-tight text-foreground">{v}</dt>
                  <dd className="text-[11px] text-muted-foreground">{l}</dd>
                </div>
              ))}
            </dl>
          </div>
          <p className="text-xs text-muted-foreground">© {new Date().getFullYear()} CivicTrust</p>
        </div>
      </div>
    </div>
  );
}

function GoogleIcon() {
  return (
    <svg viewBox="0 0 24 24" className="h-4 w-4" aria-hidden="true">
      <path
        fill="#EA4335"
        d="M12 10.2v3.9h5.5c-.2 1.4-1.7 4.1-5.5 4.1-3.3 0-6-2.7-6-6.1s2.7-6.1 6-6.1c1.9 0 3.1.8 3.8 1.5l2.6-2.5C16.8 3.3 14.6 2.4 12 2.4 6.7 2.4 2.4 6.7 2.4 12s4.3 9.6 9.6 9.6c5.5 0 9.2-3.9 9.2-9.4 0-.6-.1-1.1-.2-1.6H12z"
      />
    </svg>
  );
}
