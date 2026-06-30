import { supabase } from "@/config/supabase";

export async function getReports() {
  const { data, error } = await supabase
    .from("reports")
    .select(`
      id,
      title,
      source,
      status,
      submitted_at,
      categories(category_name),
      wards(ward_name)
    `)
    .order("submitted_at", { ascending: false });

  if (error) {
    console.error(error);
    return [];
  }

  return data;
}