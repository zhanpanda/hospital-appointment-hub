import { apiRequest } from "@/api/client";

export function fetchDepartments(token) {
  return apiRequest("/departments", { token });
}
