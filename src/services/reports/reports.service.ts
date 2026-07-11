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

export async function getReportById(reportId: string) {
  const { data, error } = await supabase
    .from("reports")
    .select(`
      id,
      title,
      description,
      source,
      status,
      is_anonymous,
      upvote_count,
      submitted_at,
      created_at,
      updated_at,
      reporter_id,
      categories(category_name),
      wards(ward_name),
      report_location(latitude, longitude, accuracy, address, landmark),
      report_media(id, media_type, file_url, file_name, mime_type, file_size, uploaded_at),
      ai_analysis(
        id,
        model_name,
        analysis_version,
        summary,
        predicted_priority,
        severity_score,
        confidence_score,
        duplicate_score,
        risk_score,
        created_at,
        predicted_category:categories(category_name),
        duplicate_candidates(
          id,
          similarity_score,
          reason,
          matched_report:reports(
            id,
            title,
            status,
            categories(category_name),
            wards(ward_name)
          )
        )
      )
    `)
    .eq("id", reportId)
    .maybeSingle();

  if (error) {
    console.error(error);
    return null;
  }
  return data;
}
