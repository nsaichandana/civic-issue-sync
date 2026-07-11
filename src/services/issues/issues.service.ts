import { supabase } from "@/config/supabase";

export async function getIssues() {
  const { data, error } = await supabase
    .from("issues")
    .select(`
      id,
      issue_number,
      title,
      priority,
      status,
      updated_at,
      categories(category_name),
      departments(department_name),
      wards(ward_name)
    `)
    .order("updated_at", { ascending: false });

  if (error) {
    console.error(error);
    return [];
  }

  return data;
}