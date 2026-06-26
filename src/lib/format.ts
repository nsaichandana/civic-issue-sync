export function timeAgo(iso: string): string {
  const diff = Date.now() - new Date(iso).getTime();
  const future = diff < 0;
  const abs = Math.abs(diff);
  const mins = Math.round(abs / 60000);
  if (mins < 1) return "just now";
  if (mins < 60) return `${future ? "in " : ""}${mins}m${future ? "" : " ago"}`;
  const hours = Math.round(mins / 60);
  if (hours < 24) return `${future ? "in " : ""}${hours}h${future ? "" : " ago"}`;
  const days = Math.round(hours / 24);
  return `${future ? "in " : ""}${days}d${future ? "" : " ago"}`;
}
