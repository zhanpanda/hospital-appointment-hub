import { apiRequest } from "@/api/client";

export function fetchDoctorSchedules(token, doctorId) {
  return apiRequest(`/schedules?doctorId=${doctorId}`, { token });
}
